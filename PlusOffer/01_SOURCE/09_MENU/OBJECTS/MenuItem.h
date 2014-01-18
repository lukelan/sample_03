//
//  MenuItem.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/15/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
@property (nonatomic, retain) NSString *item_id;
@property (nonatomic, retain) NSString *item_name;
@property (nonatomic, retain) NSString *item_price;
@property (nonatomic, retain) NSString *item_description;
@property (nonatomic, retain) NSString *item_image;
@property (nonatomic, retain) NSString *brand_id;

-(id)initWithData:(NSDictionary*)data;
@end
