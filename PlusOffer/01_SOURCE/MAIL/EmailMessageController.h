#import <UIKit/UIKit.h>


#define EMAILMESSAGECONTROLLER_OPENEDATTACHMENT @"EMAILMESSAGECONTROLLER_OPENEDATTACHMENT"

@interface EmailAttachmentHelper : NSObject

@property (nonatomic, assign) int attachmentIndex;
@property (nonatomic, assign) id delegate;

@end


@interface EmailMessageController : UIViewController <UIActionSheetDelegate>
{
	UIWebView *webView;
	bool requestedBodystructure;
	bool requestedContentPart;
	EmailAttachmentHelper *attachmentHelper;
	UIBarButtonItem *btnAttach;
}

@property (nonatomic, assign) int uid;
@property (nonatomic, retain) NSString *textContent;
@property (nonatomic, retain) NSArray *attachments;

- (void) getMessageContent;

@end

