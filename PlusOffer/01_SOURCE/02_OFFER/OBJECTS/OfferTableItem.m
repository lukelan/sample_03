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
    }
    return self;
}
@end
