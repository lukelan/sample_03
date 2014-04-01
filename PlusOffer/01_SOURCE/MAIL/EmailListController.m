#import "EmailListController.h"
#import "Imap.h"
#import "Utils.h"
#import "Settings.h"
#import "EmailMailboxController.h"


@implementation EmailListController

- (void) viewDidLoad
{
	[super viewDidLoad];
    
	self.title = @"Mailboxes";

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
	[imap list:self refName:@"" mailboxName:@"*"];
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[imap logout:NULL];

	[super dealloc];
}

- (void) imap_ListFinished
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
	[self.tableView reloadData];
}

- (void) imap_Error:(NSString *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
	[Utils alertError:error];
}

- (void) openMailbox:(NSString *)mailboxName
{
	EmailMailboxController *ctr = [[EmailMailboxController alloc] init];
	ctr.mailboxName = mailboxName;
	[ctr openMailbox];
	[self.flipboardNavigationController pushViewController:ctr];
	[ctr release];
}


// UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[imap mailboxes] count];
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [sender dequeueReusableCellWithIdentifier:NULL];
	if (cell == NULL)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NULL];
		cell.textLabel.font = [UIFont systemFontOfSize:15.0];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	ImapMailbox *mailbox = [[imap mailboxes] objectAtIndex:indexPath.row];
	cell.textLabel.text = [ImapMailbox decodeName:mailbox.name];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ImapMailbox *mailbox = [[imap mailboxes] objectAtIndex:indexPath.row];
	[self openMailbox:mailbox.name];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
