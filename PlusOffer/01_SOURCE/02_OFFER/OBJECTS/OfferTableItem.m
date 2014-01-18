//
//  OfferTableItem.m
//  PlusOffer
//
//  Created by Trongvm on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "OfferTableItem.h"

@implementation OfferTableItem

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        _imageUrl = data[@"url"];
        _discount = data[@"discount"];
        _distance = data[@"distance"];
        _offer_id = data[@"offer_id"];
        _offer_name = data[@"offer_name"];
        _brand_id = data[@"brand_id"];
         _discount_type = data[@"discount_type"];
        _allowRedeem = data[@"allow_redeem"];
        _category_id = data[@"category_id"];
        _branch_name = data[@"branch_name"];
        _brand_name = data[@"brand_name"];
        CGFloat latitude = [[data objectForKey:@"latitude"] floatValue];
        CGFloat longtitude = [[data objectForKey:@"longitude"] floatValue];
        self.location = CLLocationCoordinate2DMake(latitude, longtitude);
        // update new api
        _size1 = data[@"size1"];
        _size2 = data[@"size2"];
        _offer_date_end = data[@"offer_date_end"];
        _max_punch = data[@"max_punch"];
        _user_punch = data[@"user_punch"];
        _distanceNum = [data[@"distanceNum"] floatValue];
      
    }
    return self;
}
-(NSString *)title
{
    return self.offer_name;
}

-(NSString *)subtitle
{
    return self.offer_name;
}

-(CLLocationCoordinate2D)coordinate
{
    return self.location;
}
@end
