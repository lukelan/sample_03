//
//  BrandModel.h
//  PlusOffer
//
//  Created by Le Ngoc Duy on 1/16/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BrandModel : NSManagedObject

@property (nonatomic, retain) NSString * brand_card_color;
@property (nonatomic, retain) NSString * brand_card_image;
@property (nonatomic, retain) NSString * brand_card_logo;
@property (nonatomic, retain) NSNumber * brand_id;
@property (nonatomic, retain) NSString * brand_name;
@property (nonatomic, retain) NSString * date_end;
@property (nonatomic, retain) id list_prize;
@property (nonatomic, retain) NSNumber * max_punch;
@property (nonatomic, retain) NSNumber * order_id;
@property (nonatomic, retain) NSString * punch_color;
@property (nonatomic, retain) NSString * punch_color_active;
@property (nonatomic, retain) NSNumber * user_punch;
@property (nonatomic, retain) NSString * punch_image_select;
@property (nonatomic, retain) NSString * punch_image;
@property (nonatomic, retain) NSString * punch_image_active;

@end
