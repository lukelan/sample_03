//
//  OfferModel.m
//  PlusOffer
//
//  Created by Trong Vu on 12/31/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "OfferModel.h"
#import "AppDelegate.h"

@implementation OfferModel

@dynamic branch_id;
@dynamic brand_id;
@dynamic latitude;
@dynamic longitude;
@dynamic offer_id;
@dynamic offer_name;
@dynamic count_punch;
@dynamic category_id;
@dynamic discount_type;
@dynamic discount_value;
@dynamic date_add;

@synthesize distance = _distance;
@synthesize distanceStr = _distanceStr;
@synthesize allowRedeem = _allowRedeem;


-(double)distance
{
    Location *userLocation = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) userPosition];
    
    CLLocation *pinLocation = [[CLLocation alloc]
                               initWithLatitude:[self.latitude doubleValue]
                               longitude:[self.longitude doubleValue]];
    
    CLLocation *currentLocation = [[CLLocation alloc]
                                   initWithLatitude:userLocation.latitude
                                   longitude:userLocation.longtitude];
    
    _distance = [pinLocation distanceFromLocation:currentLocation];
    
    return _distance;
}

-(NSString *)distanceStr
{
    if (self.distance < 1000) {
        _distanceStr = [NSString stringWithFormat:@"%.0fm", _distance];
    }
    else {
        _distanceStr = [NSString stringWithFormat:@"%.1fkm", _distance / 1000.0f];
    }
    return _distanceStr;
}

-(BOOL)allowRedeem
{
    return self.distance <= MINIMUM_DISTANCE_ALLOW_USER_REDEEM;
}

@end
