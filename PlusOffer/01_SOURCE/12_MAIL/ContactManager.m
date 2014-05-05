//
//  ContactManager.m
//  PlusOffer
//
//  Created by Trong Vu on 4/28/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "ContactManager.h"
#import "FXKeychain.h"
#import "ContactModel.h"
#import "EmailModel.h"

@implementation ContactManager


static ContactManager* _sharedContactManager = nil;
+(ContactManager*)sharedContactManager
{
    //This way guaranttee only a thread execute and other thread will be returned when thread was running finished process
    if(_sharedContactManager != nil)
    {
        return _sharedContactManager;
    }
    static dispatch_once_t _single_thread;//block thread
    dispatch_once(&_single_thread, ^ {
        _sharedContactManager = [[super allocWithZone:nil] init];
    });//This code is called most once.
    return _sharedContactManager;
}

#pragma mark -

// get a contact service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleContact *)contactService {
    
    static GDataServiceGoogleContact* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleContact alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    // update the username/password each time the service is requested
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey];
	NSString *password = [[FXKeychain defaultKeychain] objectForKey:PasswordKey];
    
    [service setUserCredentialsWithUsername:username
                                   password:password];
    
    return service;
}

#pragma mark Setters and Getters

- (GDataFeedContact *)contactFeed {
    return mContactFeed;
}

- (void)setContactFeed:(GDataFeedContact *)feed {
    mContactFeed = feed;
}

- (NSError *)contactFetchError {
    return mContactFetchError;
}

- (void)setContactFetchError:(NSError *)error {
    mContactFetchError = error;
}

- (GDataServiceTicket *)contactFetchTicket {
    return mContactFetchTicket;
}

- (void)setContactFetchTicket:(GDataServiceTicket *)ticket {
    mContactFetchTicket = ticket;
}

#pragma mark Fetch all contacts

- (NSURL *)contactFeedURL {
    NSURL *feedURL = [GDataServiceGoogleContact contactFeedURLForUserID:kGDataServiceDefaultUser];
    return feedURL;
}

// begin retrieving the list of the user's contacts
- (void)fetchAllContacts {
    
    GDataServiceGoogleContact *service = [self contactService];
    GDataServiceTicket *ticket;
    
    BOOL shouldShowDeleted = YES;
    
    // request a whole buncha contacts; our service object is set to
    // follow next links as well in case there are more than 2000
    const int kBuncha = 2000;
    
    NSURL *feedURL = [self contactFeedURL];
    
    GDataQueryContact *query = [GDataQueryContact contactQueryWithFeedURL:feedURL];
    [query setShouldShowDeleted:shouldShowDeleted];
    [query setMaxResults:kBuncha];
    
    ticket = [service fetchFeedWithQuery:query
                                delegate:self
                       didFinishSelector:@selector(contactsFetchTicket:finishedWithFeed:error:)];
}

// contacts fetched callback
- (void)contactsFetchTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedContact *)feed
                      error:(NSError *)error {
    
    [self setContactFeed:feed];
    [self setContactFetchError:error];
    [self setContactFetchTicket:nil];
    
    [ContactModel insertContactDataFromServer:feed];
    [EmailModel insertEmailDataFromServer:feed];
    //[self updateUI];
}

#pragma mark - NSFetchResultControllerDelegate
-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *_managedObjectContext = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.includesSubentities = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[EmailModel description] inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"email"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if (![_searchStr isEqualToString:@""])
    {
        // init predicate to search
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"email CONTAINS[c] %@", _searchStr];
        [fetchRequest setPredicate:pred];
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)performSearchEmailForKey:(NSString*)key
{
    _searchStr = key;
    _fetchedResultsController = nil;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
    }
    NSLog(@"--coun===--%i",[self.fetchedResultsController.fetchedObjects count]);
}


@end
