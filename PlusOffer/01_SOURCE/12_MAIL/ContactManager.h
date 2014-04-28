//
//  ContactManager.h
//  PlusOffer
//
//  Created by Trong Vu on 4/28/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataContacts.h"

@interface ContactManager : NSObject {
    GDataFeedContact *mContactFeed;
    GDataServiceTicket *mContactFetchTicket;
    NSError *mContactFetchError;
    
    NSString *mContactImageETag;

}

-(void)fetchAllContacts;

+(ContactManager*)sharedContactManager;


@end
