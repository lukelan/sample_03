#import "Settings.h"


Settings *settings = NULL;

@implementation Settings

@synthesize imapHost;
@synthesize imapPort;
@synthesize imapSsl;
@synthesize imapUsername;
@synthesize imapPassword;

- (id) init
{
	if (self = [super init])
	{
		self.imapHost = @"imap.gmail.com";
		self.imapPort = 993;
		self.imapSsl = true;
	}
	return self;
}

- (void) dealloc
{
	[imapHost release];
	[imapUsername release];
	[imapPassword release];
	[super dealloc];
}

@end
