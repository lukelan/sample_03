//
//  ContactModel.h
//  PlusOffer
//
//  Created by Trong Vu on 4/28/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GDataContacts.h"

@interface ContactModel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * im;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postal;
@property (nonatomic, retain) NSString * group;

+ (void)insertContactDataFromServer:(GDataFeedContact *)dataList;

@end
