//
//  MenuItem.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/15/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem
- (id)initWithData:(NSDictionary*)data
{
    self = [super init];
    if (self)
    {
        _item_id = data[@"item_id"];
        _item_name = data[@"item_name"];
        _item_price = data[@"item_price"];
        _item_description = data[@"item_description"];
        _item_image = data[@"item_image"];
        _brand_id  = data[@"brand_id"];
    }
    return self;
}
@end
