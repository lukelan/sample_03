//
//  OfferTableItem.h
//  PlusOffer
//
//  Created by Trongvm on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferTableItem : NSObject
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *discount;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *offer_id;
@property (nonatomic, retain) NSString *offer_name;
@property (nonatomic, retain) NSNumber *brand_id;
@property (nonatomic, retain) NSNumber *discount_type;
@property (nonatomic, retain) NSNumber *allowRedeem;
-(id)initWithData:(NSDictionary*)data;
@end
