//
//  ContactManager.h
//  PlusOffer
//
//  Created by Trong Vu on 4/28/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataContacts.h"

@interface ContactManager : NSObject <NSFetchedResultsControllerDelegate> {
    GDataFeedContact *mContactFeed;
    GDataServiceTicket *mContactFetchTicket;
    NSError *mContactFetchError;
    
    NSString *mContactImageETag;

}

@property (retain, nonatomic) NSFetchedResultsController    *fetchedResultsController;
@property (retain, nonatomic) NSString    *searchStr;

-(void)fetchAllContacts;
- (void)performSearchEmailForKey:(NSString*)key;

+(ContactManager*)sharedContactManager;


@end
