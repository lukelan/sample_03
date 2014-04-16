//
//  MasterViewController.m
//  iOS UI Test
//
//  Created by Jonathan Willing on 4/8/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "MasterViewController.h"
#import <MailCore/MailCore.h>
#import "FXKeychain.h"
#import "MCTMsgViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "MCTTableViewCell.h"

#define CLIENT_ID @"the-client-id"
#define CLIENT_SECRET @"the-client-secret"
#define KEYCHAIN_ITEM_NAME @"MailCore OAuth 2.0 Token"

#define NUMBER_OF_MESSAGES_TO_LOAD		10

static NSString *mailCellIdentifier = @"MailCell";
static NSString *inboxInfoIdentifier = @"InboxStatusCell";

@interface MasterViewController ()
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) MCOIMAPOperation *imapCheckOp;
@property (nonatomic, strong) MCOIMAPSession *imapSession;
@property (nonatomic, strong) MCOIMAPIdleOperation *idleOperation;
@property (nonatomic, strong) MCOIMAPFetchMessagesOperation *imapMessagesFetchOp;


@property (nonatomic) NSInteger totalNumberOfInboxMessages;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic, strong) NSMutableDictionary *messagePreviews;
@end

@implementation MasterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.tableView registerClass:[MCTTableViewCell class]
		   forCellReuseIdentifier:mailCellIdentifier];

	self.loadMoreActivityView =
	[[UIActivityIndicatorView alloc]
	 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{ HostnameKey: @"imap.gmail.com" }];
	
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"OAuth2Enabled"]) {
        [self startOAuth2];
    }
    else {
        [self startLogin];
    }
}

- (void) startLogin
{
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:UsernameKey];
	NSString *password = [[FXKeychain defaultKeychain] objectForKey:PasswordKey];
	NSString *hostname = [[NSUserDefaults standardUserDefaults] objectForKey:HostnameKey];
    
    if (!username.length || !password.length) {
        [self performSelector:@selector(showSettingsViewController:) withObject:nil afterDelay:0.5];
        return;
    }

	[self loadAccountWithUsername:username password:password hostname:hostname oauth2Token:nil];
}

- (void) startOAuth2
{
    GTMOAuth2Authentication * auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:KEYCHAIN_ITEM_NAME
                                                                                        clientID:CLIENT_ID
                                                                                    clientSecret:CLIENT_SECRET];
    
    if ([auth refreshToken] == nil) {
        MasterViewController * __weak weakSelf = self;
        GTMOAuth2ViewControllerTouch *viewController = [GTMOAuth2ViewControllerTouch controllerWithScope:@"https://mail.google.com/"
                                                                                               clientID:CLIENT_ID
                                                                                           clientSecret:CLIENT_SECRET
                                                                                       keychainItemName:KEYCHAIN_ITEM_NAME
                                                                                       completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *retrievedAuth, NSError *error) {
                                                                                           [weakSelf loadWithAuth:retrievedAuth];
                                                                                       }];
        [self.navigationController pushViewController:viewController
                                             animated:YES];
    }
    else {
        [auth beginTokenFetchWithDelegate:self
                        didFinishSelector:@selector(auth:finishedRefreshWithFetcher:error:)];
    }
}

- (void)auth:(GTMOAuth2Authentication *)auth
finishedRefreshWithFetcher:(GTMHTTPFetcher *)fetcher
       error:(NSError *)error {
    [self loadWithAuth:auth];
}

- (void)loadWithAuth:(GTMOAuth2Authentication *)auth
{
	NSString *hostname = [[NSUserDefaults standardUserDefaults] objectForKey:HostnameKey];
	[self loadAccountWithUsername:[auth userEmail] password:nil hostname:hostname oauth2Token:[auth accessToken]];
}

- (void)loadAccountWithUsername:(NSString *)username
                       password:(NSString *)password
                       hostname:(NSString *)hostname
                    oauth2Token:(NSString *)oauth2Token
{
	self.imapSession = [[MCOIMAPSession alloc] init];
	self.imapSession.hostname = hostname;
	self.imapSession.port = 993;
	self.imapSession.username = username;
	self.imapSession.password = password;
    if (oauth2Token != nil) {
        self.imapSession.OAuth2Token = oauth2Token;
        self.imapSession.authType = MCOAuthTypeXOAuth2;
    }
	self.imapSession.connectionType = MCOConnectionTypeTLS;
    MasterViewController * __weak weakSelf = self;
	self.imapSession.connectionLogger = ^(void * connectionID, MCOConnectionLogType type, NSData * data) {
        @synchronized(weakSelf) {
            if (type != MCOConnectionLogTypeSentPrivate) {
//                NSLog(@"event logged:%p %i withData: %@", connectionID, type, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }
        }
    };
	
	// Reset the inbox
	self.messages = nil;
	self.totalNumberOfInboxMessages = -1;
	self.isLoading = NO;
	self.messagePreviews = [NSMutableDictionary dictionary];
	[self.tableView reloadData];
    
	NSLog(@"checking account");
	self.imapCheckOp = [self.imapSession checkAccountOperation];
	[self.imapCheckOp start:^(NSError *error) {
		MasterViewController *strongSelf = weakSelf;
		NSLog(@"finished checking account.");
		if (error == nil) {
			[strongSelf loadLastNMessages:NUMBER_OF_MESSAGES_TO_LOAD];
		} else {
			NSLog(@"error loading account: %@", error);
		}
		
		strongSelf.imapCheckOp = nil;
	}];
    
    [self.imapSession setConnectionLogger:^(void * connectionID, MCOConnectionLogType type, NSData * data) {
        NSLog(@"event logged: %i withData: %@", type, data);
    }];
    
    
    // check incomming message background
    
    NSString *folder = @"INBOX";
    if (self.folderName) {
        folder = self.folderName;
    }
    MCOIMAPIdleOperation *idleOperation = [self.imapSession idleOperationWithFolder:folder lastKnownUID:self.totalNumberOfInboxMessages];
    self.idleOperation = idleOperation;
    
//    [idleOperation start:[self idleHandler]];
    
    // delete email
//    [self updateMessageFlag:MCOMessageFlagDeleted withMessageID:11173];
    
}

- (void (^)(NSError * error))idleHandler {
    NSString *folder = self.folderName;
    void(^idleHandler)(NSError *error) = ^(NSError *error) {
        if (!error) {
            long start = self.totalNumberOfInboxMessages + 1;
            long end = UINT64_MAX;
            
            MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
            MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(start, end)];
            
            MCOIMAPFetchMessagesOperation *fetchOperation = [self.imapSession fetchMessagesByUIDOperationWithFolder:folder
                                                                                                    requestKind:requestKind
                                                                                                           uids:uids];
            
            void(^fetchHandler)(NSError*,NSArray*,MCOIndexSet*) = ^(NSError *error, NSArray *fetchedMessages, MCOIndexSet *vanishedMessages) {
                if(error) {
                    NSLog(@"Error downloading message headers:%@", error);
                }
                
                // Iterate through the messages...
                for (MCOIMAPMessage *message in fetchedMessages) {
                    NSLog(@"downloaded message with ID: %i", message.uid);
                }
            };
            
            [fetchOperation start:fetchHandler];
        } else {
            NSLog(@"There was a problem with the idle connection!");
        }
    };
    
    return idleHandler;
}

- (void)updateMessageFlag:(MCOMessageFlag)NEW_FLAGS withMessageID:(long)MESSAGE_UID {
    
    BOOL deleted = NEW_FLAGS & MCOMessageFlagDeleted;
    
    MCOIMAPOperation *op = [self.imapSession storeFlagsOperationWithFolder:self.folderName
                                                             uids:[MCOIndexSet indexSetWithIndex:MESSAGE_UID]
                                                             kind:MCOIMAPStoreFlagsRequestKindSet
                                                            flags:NEW_FLAGS];
    [op start:^(NSError * error) {
        if(!error) {
            NSLog(@"Updated flags!");
        } else {
            NSLog(@"Error updating flags:%@", error);
        }
        
        if(deleted) {
            MCOIMAPOperation *deleteOp = [self.imapSession expungeOperation:self.folderName];
            [deleteOp start:^(NSError *error) {
                if(error) {
                    NSLog(@"Error expunging folder:%@", error);
                } else {
                    NSLog(@"Successfully expunged folder");
                }
            }];
        }
    }];
}

- (void)loadLastNMessages:(NSUInteger)nMessages
{
	self.isLoading = YES;
	
	MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
	(MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
	 MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
	 MCOIMAPMessagesRequestKindFlags);
	
	NSString *inboxFolder = self.folderName;
	MCOIMAPFolderInfoOperation *inboxFolderInfo = [self.imapSession folderInfoOperation:inboxFolder];
	
	[inboxFolderInfo start:^(NSError *error, MCOIMAPFolderInfo *info)
	{
		BOOL totalNumberOfMessagesDidChange =
		self.totalNumberOfInboxMessages != [info messageCount];
		
		self.totalNumberOfInboxMessages = [info messageCount];
		
		NSUInteger numberOfMessagesToLoad =
		MIN(self.totalNumberOfInboxMessages, nMessages);
		
		if (numberOfMessagesToLoad == 0)
		{
			self.isLoading = NO;
			return;
		}
		
		MCORange fetchRange;
		
		// If total number of messages did not change since last fetch,
		// assume nothing was deleted since our last fetch and just
		// fetch what we don't have
		if (!totalNumberOfMessagesDidChange && self.messages.count)
		{
			numberOfMessagesToLoad -= self.messages.count;
			
			fetchRange =
			MCORangeMake(self.totalNumberOfInboxMessages -
						 self.messages.count -
						 (numberOfMessagesToLoad - 1),
						 (numberOfMessagesToLoad - 1));
		}
		
		// Else just fetch the last N messages
		else
		{
			fetchRange =
			MCORangeMake(self.totalNumberOfInboxMessages -
						 (numberOfMessagesToLoad - 1),
						 (numberOfMessagesToLoad - 1));
		}
		
		self.imapMessagesFetchOp =
		[self.imapSession fetchMessagesByNumberOperationWithFolder:inboxFolder
													   requestKind:requestKind
														   numbers:
		 [MCOIndexSet indexSetWithRange:fetchRange]];
		
		[self.imapMessagesFetchOp setProgress:^(unsigned int progress) {
			NSLog(@"Progress: %u of %u", progress, numberOfMessagesToLoad);
		}];
		
		__weak MasterViewController *weakSelf = self;
		[self.imapMessagesFetchOp start:
		 ^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages)
		{
			MasterViewController *strongSelf = weakSelf;
			NSLog(@"fetched all messages.");
			
			self.isLoading = NO;
			
			NSSortDescriptor *sort =
			[NSSortDescriptor sortDescriptorWithKey:@"header.date" ascending:NO];
			
			NSMutableArray *combinedMessages =
			[NSMutableArray arrayWithArray:messages];
			[combinedMessages addObjectsFromArray:strongSelf.messages];
			
			strongSelf.messages =
            [NSMutableArray arrayWithArray:[combinedMessages sortedArrayUsingDescriptors:@[sort]]];
			[strongSelf.tableView reloadData];
		}];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 1)
	{
		if (self.totalNumberOfInboxMessages >= 0)
			return 1;
		
		return 0;
	}
	
	return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section)
	{
		case 0:
		{
			MCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mailCellIdentifier forIndexPath:indexPath];
			MCOIMAPMessage *message = self.messages[indexPath.row];
			
			cell.textLabel.text = message.header.subject;
			
			NSString *uidKey = [NSString stringWithFormat:@"%d", message.uid];
			NSString *cachedPreview = self.messagePreviews[uidKey];
			
			if (cachedPreview)
			{
				cell.detailTextLabel.text = cachedPreview;
			}
			else
			{
				cell.messageRenderingOperation = [self.imapSession plainTextBodyRenderingOperationWithMessage:message
																									   folder:self.folderName];
				
				[cell.messageRenderingOperation start:^(NSString * plainTextBodyString, NSError * error) {
					cell.detailTextLabel.text = plainTextBodyString;
					cell.messageRenderingOperation = nil;
					self.messagePreviews[uidKey] = plainTextBodyString;
				}];
			}
			
			return cell;
			break;
		}
			
		case 1:
		{
			UITableViewCell *cell =
			[tableView dequeueReusableCellWithIdentifier:inboxInfoIdentifier];
			
			if (!cell)
			{
				cell =
				[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:inboxInfoIdentifier];
				
				cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
				cell.textLabel.textAlignment = NSTextAlignmentCenter;
				cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
			}
			
			if (self.messages.count < self.totalNumberOfInboxMessages)
			{
				cell.textLabel.text =
				[NSString stringWithFormat:@"Load %d more",
				 MIN(self.totalNumberOfInboxMessages - self.messages.count,
					 NUMBER_OF_MESSAGES_TO_LOAD)];
			}
			else
			{
				cell.textLabel.text = nil;
			}
			
			cell.detailTextLabel.text =
			[NSString stringWithFormat:@"%d message(s)",
			 self.totalNumberOfInboxMessages];
			
			cell.accessoryView = self.loadMoreActivityView;
			
			if (self.isLoading)
				[self.loadMoreActivityView startAnimating];
			else
				[self.loadMoreActivityView stopAnimating];
			
			return cell;
			break;
		}
			
		default:
			return nil;
			break;
	}
	
}

- (void)showSettingsViewController:(id)sender {
	[self.imapMessagesFetchOp cancel];
	
	SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
	settingsViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	[self presentViewController:nav animated:YES completion:nil];
}

- (void)settingsViewControllerFinished:(SettingsViewController *)viewController {
	[self dismissViewControllerAnimated:YES completion:nil];
	
	NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey];
	NSString *password = [[FXKeychain defaultKeychain] objectForKey:PasswordKey];
	NSString *hostname = [[NSUserDefaults standardUserDefaults] objectForKey:HostnameKey];
	
	if (![username isEqualToString:self.imapSession.username] ||
		![password isEqualToString:self.imapSession.password] ||
		![hostname isEqualToString:self.imapSession.hostname]) {
		self.imapSession = nil;
		[self loadAccountWithUsername:username password:password hostname:hostname oauth2Token:nil];
	}
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Perform the real delete action here. Note: you may need to check editing style
        //   if you do not perform delete only.
        MCOIMAPMessage *msg = self.messages[indexPath.row];
        NSLog(@"Deleted uid - %i:",msg.uid);
        [self updateMessageFlag:MCOMessageFlagDeleted withMessageID:msg.uid];
        [self.messages removeObjectAtIndex:indexPath.row];
        self.totalNumberOfInboxMessages --;
        //[self.tableView reloadData];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section)
	{
		case 0:
		{
			MCOIMAPMessage *msg = self.messages[indexPath.row];
			MCTMsgViewController *vc = [[MCTMsgViewController alloc] init];
			vc.folder = self.folderName;
			vc.message = msg;
			vc.session = self.imapSession;
			[self.flipboardNavigationController pushViewController:vc];
			
			break;
		}
			
		case 1:
		{
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			
			if (!self.isLoading &&
				self.messages.count < self.totalNumberOfInboxMessages)
			{
				[self loadLastNMessages:self.messages.count + NUMBER_OF_MESSAGES_TO_LOAD];
				cell.accessoryView = self.loadMoreActivityView;
				[self.loadMoreActivityView startAnimating];
			}
			
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			break;
		}
			
		default:
			break;
	}

}

@end
