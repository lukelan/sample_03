//
//  OfferTableItem.m
//  PlusOffer
//
//  Created by Tai Truong on 12/24/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
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
