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
        CGFloat latitude = [[data objectForKey:@"latitude"] floatValue];
        CGFloat longtitude = [[data objectForKey:@"longitude"] floatValue];
        self.location = CLLocationCoordinate2DMake(latitude, longtitude);
        
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
