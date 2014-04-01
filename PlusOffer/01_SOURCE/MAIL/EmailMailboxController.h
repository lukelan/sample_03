#import "MoreTableViewController.h"


@interface EmailMailboxController : MoreTableViewController
{
	UIBarButtonItem *btnCancel;
	bool updating;
}

@property (nonatomic, retain) NSString *mailboxName;

- (void) openMailbox;

@end
