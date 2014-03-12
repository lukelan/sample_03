//
//  BranchModel.m
//  PlusOffer
//
//  Created by trongvm on 1/18/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "BranchModel.h"


@implementation BranchModel

@dynamic branch_id;
@dynamic branch_name;
@dynamic branch_name_slug;
@dynamic branch_address;
@dynamic branch_tel;
@dynamic brand_id;
@dynamic location_id;
@dynamic category_id;
@dynamic latitude;
@dynamic longitude;
@dynamic hour_open;
@dynamic hour_close;
@dynamic number;
@dynamic is_active;
@dynamic date_add;
@dynamic date_update;
@dynamic size1;
@dynamic size2;
@dynamic size3;

@synthesize location = _location;

-(CLLocationCoordinate2D)location
{
    if (_location.latitude == 0 && _location.longitude == 0) {
        CGFloat latitude = [self.latitude floatValue];
        CGFloat longtitude = [self.longitude floatValue];
        _location = CLLocationCoordinate2DMake(latitude, longtitude);
    }
    
    return _location;
}

-(NSString *)title
{
    return self.branch_name;
}

-(NSString *)subtitle
{
    return self.branch_address;
}

-(CLLocationCoordinate2D)coordinate
{
    return self.location;
}

@end
