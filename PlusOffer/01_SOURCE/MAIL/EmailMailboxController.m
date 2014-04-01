#import "EmailMailboxController.h"
#import "Imap.h"
#import "EmailMessageController.h"
#import "Utils.h"

#define MESSAGES_TO_FETCH 20


@implementation EmailMailboxController

@synthesize mailboxName;

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.title = self.mailboxName;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(imap_ChangedMessages:) name:IMAP_CHANGEDMESSAGES object:imap];
    
	[self openMailbox];
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void) openMailbox
{
	self.title = [ImapMailbox decodeName:self.mailboxName];
	
	if ([imap selectedMailbox] == NULL || ![[[imap selectedMailbox] name] isEqual:self.mailboxName])
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
		[imap deselectMailbox];
		[imap select:self mailboxName:self.mailboxName];
		[self.tableView reloadData];
	}
	else
		[self finishLoad];
}

- (bool) canLoadMore
{
	return ([[imap messages] count] < [imap exists]);
}

- (void) imap_FetchFinished
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
	if (updating)
	{
		[self setLastUpdate:[NSDate date]];
		updating = false;
	}
	[self finishLoad];
}

- (void) imap_ExamineFinished
{
	int st = MAX(1, [imap exists] - MESSAGES_TO_FETCH);
	if ([[imap messages] count] > 0)
	{
		ImapMessage *lastMessage = [[imap messages] lastObject];
		st = lastMessage.sequenceNumber + 1;
	}
	
	if (st >= 1 && st <= [imap exists])
		[imap fetch:self firstMessage:st lastMessage:[imap exists] filter:@"BODY[HEADER.FIELDS (DATE FROM SUBJECT)]"];
	else
		[self imap_FetchFinished];
}

- (void) startUpdateNoExamine
{
	[super startUpdate];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
	updating = true;
	[self imap_ExamineFinished];
}

- (void) imap_SelectFinished
{
	if ([self canLoadMore])
		[self startUpdateNoExamine];
	else
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
}

- (void) startUpdate
{
	[super startUpdate];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
	updating = true;
	[imap examine:self mailboxName:self.mailboxName];
}

- (void) startLoadMore
{
	[super startLoadMore];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
	
	int en = [imap exists];
	if ([[imap messages] count] > 0)
	{
		ImapMessage *firstMessage = [[imap messages] objectAtIndex:0];
		en = firstMessage.sequenceNumber - 1;
	}
	if (en >= 1)
		[imap fetch:self firstMessage:MAX(1, en - MESSAGES_TO_FETCH)
        lastMessage:en filter:@"UID BODY[HEADER.FIELDS (DATE FROM SUBJECT)]"];
}

- (void) imap_ChangedMessages:(NSNotification *)notification
{
	[self.tableView reloadData];
	[self animateOnFinishLoad];
}

- (void) imap_Error:(NSString *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
	[Utils alertError:error];
}


// UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[imap messages] count];
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [sender dequeueReusableCellWithIdentifier:NULL];
	if (cell == NULL)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NULL];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	ImapMessage *message = [[imap messages] objectAtIndex:([[imap messages] count]-indexPath.row-1)];
	
	NSString *names = @"";
	for (NSArray *address in message.fromAddresses)
	{
		NSString *name = [address objectAtIndex:0];
		if (name.length == 0)
			name = [address objectAtIndex:1];
		names = [names stringByAppendingFormat:@"%@%@", (names.length > 0 ? @", " : @""), name];
	}
	
	cell.textLabel.text = names;
	
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar]
		components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
		fromDate:message.date];
	NSDateComponents *nowComponents = [[NSCalendar currentCalendar]
		components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
		fromDate:[NSDate date]];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if (dateComponents.year != nowComponents.year || dateComponents.month != nowComponents.month
		|| dateComponents.day != nowComponents.day)
	{
		[formatter setTimeStyle:NSDateFormatterNoStyle];
		[formatter setDateStyle:NSDateFormatterShortStyle];
	}
	else
	{
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		[formatter setDateStyle:NSDateFormatterNoStyle];
	}

	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",
		message.subject, [formatter stringFromDate:message.date]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ImapMessage *message = [[imap messages] objectAtIndex:([[imap messages] count]-indexPath.row-1)];
    
	EmailMessageController *ctr = [[EmailMessageController alloc] init];
	ctr.uid = message.uid;
	[self.flipboardNavigationController pushViewController:ctr];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
