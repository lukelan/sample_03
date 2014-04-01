#import "EmailMessageController.h"
#import "Imap.h"
#import "ImapEncoding.h"
#import "UIViewSizeShortcuts.h"
#import "Utils.h"


@implementation EmailMessageController

@synthesize uid;
@synthesize textContent;
@synthesize attachments;

- (void) viewDidLoad
{
	self.title = @"Message";

	btnAttach = [[[UIBarButtonItem alloc] initWithTitle:@"Attachments"
		style:UIBarButtonItemStyleBordered target:self action:@selector(btnAttach_Touched)] autorelease];
	self.navigationItem.rightBarButtonItem = btnAttach;
	
	attachmentHelper = [[EmailAttachmentHelper alloc] init];
	attachmentHelper.delegate = self;
    
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.scalesPageToFit = true;
	webView.dataDetectorTypes = 0;
	[self.view addSubview:webView];
    
	[self getMessageContent];
}

- (void) dealloc
{
	attachmentHelper.delegate = NULL;
	[super dealloc];
}

- (void) btnAttach_Touched
{
	UIActionSheet *sheet = [[UIActionSheet alloc] init];
	sheet.title = @"Attachments";
	sheet.delegate = self;
	
	for (ImapBodypart *part in attachments)
	{
		NSString *name = [part.parameters objectForKey:@"name"];
		if (name == NULL)
			name = part.contentType;
		
		[sheet addButtonWithTitle:name];
	}
	
	[sheet addButtonWithTitle:@"Cancel"];
	sheet.cancelButtonIndex = sheet.numberOfButtons-1;
	[sheet showInView:self.view];
}

- (void) handleAttachmentData:(ImapBodypart *)part
{
	if (part.data == NULL || part.subtype == NULL)
		return;
    
	NSString *suffix = [[part.parameters objectForKey:@"name"] pathExtension];
	if ([suffix length] == 0)
	{
		if ([part.contentType isEqual:@"text/plain"])
			suffix = @"txt";
		else
			suffix = part.subtype;
	}

	// Check if subtype valid
	for (int i = 0; i < suffix.length; i++)
		if (!(([suffix characterAtIndex:i] >= 'a' && [suffix characterAtIndex:i] <= 'z')
			|| ([suffix characterAtIndex:i] >= 'A' && [suffix characterAtIndex:i] <= 'Z')))
		{
			suffix = @"txt";
			break;
		}

	NSMutableString *filename = [NSMutableString string];
	srand(time(0));
	for (int i = 0; i < 20; i++)
		[filename appendFormat:@"%c", 'a' + rand() % ('z'-'a')];

	if (suffix != NULL)
		[filename appendFormat:@".%@", suffix];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
	
	[[part dataWithCharset] writeToFile:path options:0 error:NULL];
	part.data = NULL; // release large object
    
	NSURL *url = [NSURL fileURLWithPath:path isDirectory:false];

	// Subscribe to this event to use attachment
	[[NSNotificationCenter defaultCenter] postNotificationName:EMAILMESSAGECONTROLLER_OPENEDATTACHMENT
		object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", NULL]];
		
	[Utils alert:NULL title:@"Attachment saved to file"];
}

- (void) handleAttachment:(int)index
{
	ImapBodypart *part = [attachments objectAtIndex:index];
	
	if (part.data != NULL)
	{
		[self handleAttachmentData:part];
		return;
	}
    
	ImapMessage *message = [imap messageWithUid:self.uid];
	if (message == NULL || message.bodyStructure == NULL)
		return;
	NSString *partCode = [message codeForPart:part];
	if (partCode == NULL)
		return;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
	attachmentHelper.attachmentIndex = index;
	[imap uidFetch:attachmentHelper uid:message.uid filter:[NSString stringWithFormat:@"BODY[%@]", partCode]];
}

- (void) attachmentHelper_FetchFinished
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
	ImapBodypart *part = [attachments objectAtIndex:attachmentHelper.attachmentIndex];
	[self handleAttachmentData:part];
}

- (NSString *) processTextForHtml:(NSString *)text
{
	text = [text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	text = [text stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	text = [text stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
	text = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
	text = [NSString stringWithFormat:@"<html><body style=\"word-wrap:break-word\">%@</body></html>", text];
	return text;
}

- (int) positionIn:(NSString *)html afterTag:(NSString *)tagName
{
	NSRange	rng1 = [html rangeOfString:[NSString stringWithFormat:@"<%@", tagName]
                               options:NSCaseInsensitiveSearch];
	if (rng1.location == NSNotFound)
		return 0;
	NSRange rng2 = [html rangeOfString:@">" options:0 range:NSMakeRange(rng1.location,
                                                                        html.length - rng1.location)];
	if (rng2.location == NSNotFound)
		return 0;
	return rng2.location + 1;
}

- (NSString *) processHtml:(NSString *)html message:(ImapMessage *)message
{
	int afterHtml = [self positionIn:html afterTag:@"html"];
	int afterHead = [self positionIn:html afterTag:@"head"];
	if (afterHead == 0)
		afterHead = afterHtml;
    
	html = [html stringByReplacingCharactersInRange:NSMakeRange(afterHead, 0) withString:
		@"<meta name=\"viewport\" content=\"width=device-width; initial-scale=1\">"\
		@"<style>"\
		@" body { font-family: Helvetica; font-size: 11pt; }"\
		@"</style>"
		];
  
	int afterBody = [self positionIn:html afterTag:@"body"];
	if (afterBody == 0)
		afterBody = afterHtml;
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *date = [formatter stringFromDate:message.date];
	
	NSMutableString *from = [NSMutableString string];
	for (int i = 0; i < message.fromAddresses.count; i++)
	{
		NSArray *address = [message.fromAddresses objectAtIndex:i];
		NSString *name = [address objectAtIndex:0];
		NSString *email = [address objectAtIndex:1];
		
		[from appendFormat:@"%@<b>%@</b> &lt;<a href=\"mailto:%@\">%@</a>&gt;",
         (i > 0 ? @", " : @""), name, email, email];
	}
	
	html = [html stringByReplacingCharactersInRange:NSMakeRange(afterBody, 0) withString:
		[NSString stringWithFormat:
		@"<div style=\"color: @000000; font-weight: bold;   font-family: Helvetica; font-size: 10pt; margin-bottom: 0.2em;\">%@</div>"\
		@"<div style=\"color: #606060; font-weight: normal; font-family: Helvetica; font-size: 10pt; margin-bottom: 0.2em;\">From: %@</div>"\
		@"<div style=\"color: #606060; font-weight: normal; font-family: Helvetica; font-size: 10pt; margin-bottom: 0.2em;\">%@</div>"\
		@"<hr><br>",
		message.subject, from, date]];
  
	return html;
}

- (NSString *) processTextForPrint:(NSString *)text fromMessage:(ImapMessage *)message
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *date = [formatter stringFromDate:message.date];
	
	NSMutableString *from = [NSMutableString string];
	for (int i = 0; i < message.fromAddresses.count; i++)
	{
		NSArray *address = [message.fromAddresses objectAtIndex:i];
		NSString *name = [address objectAtIndex:0];
		NSString *email = [address objectAtIndex:1];
		
		[from appendFormat:@"%@%@ <%@>", (i > 0 ? @", " : @""), name, email];
	}
	
	text = [text stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:
		[NSString stringWithFormat:
		 @"Subject: %@\r\n"\
		 @"From: %@\r\n"\
		 @"Date: %@\r\n"\
		 @"\r\n",
		 message.subject, from, date]];
  
	return text;
}

- (void) getMessageContent
{
	ImapMessage *message = [imap messageWithUid:self.uid];
	if (message == NULL || message.bodyStructure == NULL)
	{
		if (!requestedBodystructure)
		{
			requestedBodystructure = true;
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
			[imap uidFetch:self uid:uid filter:@"BODY"];
		}
		else
		{
			[Utils alertError:@"Failed to fetch message"];
		}
		return;
	}
    
	// Find content part
	ImapBodypart *contentPart = [message findContentPart];
	if (contentPart == NULL)
		return;
    
	// Attachments
	self.attachments = [message findAttachments];
	btnAttach.enabled = (self.attachments.count > 0);
    
	// Fetch data
	if (contentPart.data == NULL)
	{
		NSString *partCode = [message codeForPart:contentPart];
		if (partCode == NULL)
			return;
		if (!requestedContentPart)
		{
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
			[imap uidFetch:self uid:message.uid filter:[NSString stringWithFormat:@"BODY[%@]", partCode]];
			requestedContentPart = true;
		}
		return;
	}
    
	// Display content
	NSString *text = [contentPart stringWithCharset];
    
	if ([contentPart.contentType isEqual:@"text/plain"])
	{
		self.textContent = [self processTextForPrint:text fromMessage:message];
		text = [self processTextForHtml:text];
	}
	
	[webView loadHTMLString:[self processHtml:text message:message] baseURL:NULL];
}

- (void) imap_UidFetchFinished
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
	[self getMessageContent];
}

- (void) imap_Error:(NSString *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
	[Utils alertError:error];
}

// UIActionSheet

- (void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == sheet.cancelButtonIndex)
		return;
	[self handleAttachment:buttonIndex];
}

@end


@implementation EmailAttachmentHelper

@synthesize delegate;
@synthesize attachmentIndex;

- (void) imap_UidFetchFinished
{
	[delegate performSelector:@selector(attachmentHelper_FetchFinished)];
}

@end


