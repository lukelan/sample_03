//
//  RedeemTableViewItem.h
//  PlusOffer
//
//  Created by Trongvm on 12/25/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    enumRedeemItemType_allowRedeem = 0,
    enumRedeemItemType_notAllow,
    enumRedeemItemType_num
}enumRedeemItemType;

@interface RedeemTableViewItem : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *redeemDetail;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, assign) enumRedeemItemType type;

-(id)initWithData:(NSDictionary*)data andType:(enumRedeemItemType)type;
@end
