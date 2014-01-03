
//
//  OfferDetailItem.m
//  PlusOffer
//
//  Created by Le Ngoc Duy on 1/2/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "OfferDetailItem.h"

@implementation OfferDetailItem
-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        _offer_id = data[@"id"];
        _bannerUrl = data[@"banner"];
        _branch_name = data[@"name"];
        _branch_address = data[@"address"];
        _branch_tel = data[@"tel"];
        _hour_working  = data[@"hour_working"];
        
        _iconURL = data[@"icon"];
        _offer_name = data[@"offer_name"];
        _offer_description = data[@"description"];
        
        _max_punch = data[@"max"];
        _count_puch = data[@"count"];
        
        _branch_id = data[@"branch_id"];
        CGFloat latitude = [[data objectForKey:@"latitude"] floatValue];
        CGFloat longtitude = [[data objectForKey:@"longitude"] floatValue];
        self.location = CLLocationCoordinate2DMake(latitude, longtitude);
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate
{
    return self.location;
}
@end
