//
//  RedeemModel.h
//  PlusOffer
//
//  Created by Trongvm on 12/29/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RedeemModel : NSManagedObject

@property (nonatomic, retain) NSNumber * redeem_id;
@property (nonatomic, retain) NSNumber * offer_id;
@property (nonatomic, retain) NSNumber * brand_id;
@property (nonatomic, retain) NSNumber * branch_id;
@property (nonatomic, retain) NSString * offer_name;
@property (nonatomic, retain) NSString * offer_description;
@property (nonatomic, retain) NSString * offer_content;
@property (nonatomic, retain) NSString * brand_name;
@property (nonatomic, retain) NSString * branch_name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * user_punch;
@property (nonatomic, retain) NSNumber * max_punch;
@property (nonatomic, retain) NSNumber * is_redeem;
@property (nonatomic, retain) NSNumber * is_redeemable;

// additional variables
@property (nonatomic, assign) double  distance; // meter
@property (nonatomic, retain) NSString * distanceStr;
@property (nonatomic, readonly) BOOL allowRedeem;
@property (nonatomic, retain) NSNumber * order_id;
@end
