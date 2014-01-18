//
//  RedeemModel.m
//  PlusOffer
//
//  Created by Trongvm on 12/29/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "RedeemModel.h"
#import "AppDelegate.h"

@implementation RedeemModel

@dynamic redeem_id;
@dynamic offer_id;
@dynamic brand_id;
@dynamic branch_id;
@dynamic offer_name;
@dynamic offer_description;
@dynamic offer_content;
@dynamic brand_name;
@dynamic branch_name;
@dynamic latitude;
@dynamic longitude;
@dynamic user_punch;
@dynamic max_punch;
@dynamic is_redeem;
@dynamic is_redeemable;
@dynamic order_id;
@synthesize distance = _distance;
@synthesize distanceStr = _distanceStr;
@synthesize allowRedeem = _allowRedeem;

-(double)distance
{
    Position *userLocation = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) userPosition];
    
    CLLocation *pinLocation = [[CLLocation alloc]
                               initWithLatitude:[self.latitude doubleValue]
                               longitude:[self.longitude doubleValue]];
    
    CLLocation *currentLocation = [[CLLocation alloc]
                                   initWithLatitude:userLocation.positionCoodinate2D.latitude
                                   longitude:userLocation.positionCoodinate2D.longitude];
    
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
