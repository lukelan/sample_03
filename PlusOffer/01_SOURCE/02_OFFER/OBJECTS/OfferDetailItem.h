//
//  OfferDetailItem.h
//  PlusOffer
//
//  Created by Le Ngoc Duy on 1/2/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferDetailItem : NSObject
@property (nonatomic, retain) NSString *offer_id;
//data cell Info
@property (nonatomic, retain) NSString *bannerUrl;
@property (nonatomic, retain) NSString *branch_name;
@property (nonatomic, retain) NSString *branch_address;
@property (nonatomic, retain) NSString *branch_tel;
@property (nonatomic, retain) NSString *hour_working;
//data cell Discount
@property (nonatomic, retain) NSString *iconURL;
@property (nonatomic, retain) NSString *offer_name;
@property (nonatomic, retain) NSString *offer_description;
//data cell punch
@property (nonatomic, retain) NSString *max_punch;
@property (nonatomic, retain) NSString *count_puch;
-(id)initWithData:(NSDictionary*)data;
@end
