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
    }
    return self;
}
@end
