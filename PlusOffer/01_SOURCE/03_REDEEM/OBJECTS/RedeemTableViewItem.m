//
//  RedeemTableViewItem.m
//  PlusOffer
//
//  Created by Tai Truong on 12/25/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "RedeemTableViewItem.h"

@implementation RedeemTableViewItem

-(id)initWithData:(NSDictionary *)data andType:(enumRedeemItemType)type
{
    self = [super init];
    if (self) {
        _name = data[@"name"];
        _redeemDetail = data[@"detail"];
        _distance = data[@"distance"];
        _imageUrl = data[@"imageUrl"];
        _type = type;
    }
    
    return self;
}
@end
