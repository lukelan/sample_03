//
//  OfferTableItem.h
//  PlusOffer
//
//  Created by Trongvm on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferTableItem : NSObject
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *discount;
@property (nonatomic, retain) NSString *distance;

-(id)initWithData:(NSDictionary*)data;
@end
