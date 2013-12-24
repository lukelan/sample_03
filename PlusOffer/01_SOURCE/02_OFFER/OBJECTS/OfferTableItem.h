//
//  OfferTableItem.h
//  PlusOffer
//
//  Created by Tai Truong on 12/24/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferTableItem : NSObject
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *discount;
@property (nonatomic, retain) NSString *distance;

-(id)initWithData:(NSDictionary*)data;
@end
