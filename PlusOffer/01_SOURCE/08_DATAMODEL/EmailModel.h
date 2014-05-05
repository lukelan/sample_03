//
//  EmailModel.h
//  PlusOffer
//
//  Created by Trong Vu on 5/5/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GDataContacts.h"

@interface EmailModel : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;

+ (void)insertEmailDataFromServer:(GDataFeedContact *)dataList;

@end
