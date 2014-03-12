//
//  OfferModel.h
//  PlusOffer
//
//  Created by Trong Vu on 12/31/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OfferModel : NSManagedObject

@property (nonatomic, retain) NSNumber * branch_id;
@property (nonatomic, retain) NSNumber * brand_id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * offer_id;
@property (nonatomic, retain) NSString * offer_name;
@property (nonatomic, retain) NSString * branch_name;
@property (nonatomic, retain) NSString * brand_name;
@property (nonatomic, retain) NSNumber * user_punch;
@property (nonatomic, retain) NSNumber * is_bookmark;
@property (nonatomic, retain) NSNumber * category_id;
@property (nonatomic, retain) NSNumber * discount_type;
@property (nonatomic, retain) NSNumber * discount_value;
@property (nonatomic, retain) NSString * date_add;
// additional variables
@property (nonatomic, assign) double  distance; // meter
@property (nonatomic, retain) NSString * distanceStr;
@property (nonatomic, readonly) BOOL allowRedeem;

// update new api
@property (nonatomic, retain) NSString *size2;
@property (nonatomic, retain) NSString *size1;
@property (nonatomic, retain) NSString *offer_date_end;
@property (nonatomic, retain) NSNumber *max_punch;
@property (nonatomic, retain) NSNumber * order_id;


+ (OfferModel*) getOfferWithID:(NSString*)offerID;
+ (void) updateOfferID:(NSString*)offerID withBookMark:(BOOL)isBookMark;
+ (void) removeOfferID:(NSString*)offerID;

@end
