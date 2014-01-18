//
//  OfferDetailItem.h
//  PlusOffer
//
//  Created by Le Ngoc Duy on 1/2/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferDetailItem : NSObject
@property (nonatomic, retain) NSString *branch_id;
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
@property (nonatomic, retain) NSString *offer_content;
//data cell punch
@property (nonatomic, retain) NSString *max_punch;
@property (nonatomic, retain) NSString *count_puch;
@property (nonatomic, retain) NSString *offer_date_end;
@property (nonatomic, retain) NSString *user_punch;
@property (nonatomic, retain) NSString *size1;
@property (nonatomic, retain) NSString *size2;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *is_like;
@property (nonatomic, retain) id menu;
@property (nonatomic, retain) NSString *brand_name;
@property (nonatomic, retain) NSString *brand_id;
@property (assign, nonatomic) CLLocationCoordinate2D  location;
-(id)initWithData:(NSDictionary*)data;
@end
