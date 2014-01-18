//
//  OfferDetailModel.h
//  PlusOffer
//
//  Created by Trong Vu on 12/31/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OfferDetailModel : NSManagedObject

@property (nonatomic, retain) NSNumber * branch_id;
@property (nonatomic, retain) NSString * branch_name;
@property (nonatomic, retain) NSNumber * brand_id;
@property (nonatomic, retain) NSNumber * user_punch;
@property (nonatomic, retain) NSNumber * discount_value;
@property (nonatomic, retain) NSNumber * discount_type;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * max_punch;
@property (nonatomic, retain) NSString * offer_content;
@property (nonatomic, retain) NSString * offer_description;
@property (nonatomic, retain) NSNumber * offer_id;
@property (nonatomic, retain) NSString * offer_name;
@property (nonatomic, retain) NSNumber * category_id;
@property (nonatomic, retain) NSString * hour_open;
@property (nonatomic, retain) NSString * hour_close;
@property (nonatomic, retain) NSString * branch_tel;
@property (nonatomic, retain) NSString * branch_address;
@property (nonatomic, retain) NSString * date_add;
@property (nonatomic, retain) NSString * discount_type_name;
// update new api
@property (nonatomic, retain) NSString *offer_date_end;
@property (nonatomic, retain) NSString *size2;
@property (nonatomic, retain) NSString *size1;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *brand_name;
@property (nonatomic, retain) id menu;


@end
