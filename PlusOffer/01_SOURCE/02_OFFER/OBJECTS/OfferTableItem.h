//
//  OfferTableItem.h
//  PlusOffer
//
//  Created by Trongvm on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ENUM_MCDONALDS = 1,
    ENUM_URBAN_STATION,
    ENUM_BHD,
}ENUM_BRAND_ID;

typedef enum
{
    ENUM_DISTANCE = 0,
    ENUM_HERE,
}ENUM_lOCATION;

typedef enum
{
    ENUM_DISCOUNT = 1,
    ENUM_VALUE,
    ENUM_GIFT,
    ENUM_GIFT_TICKET
}ENUM_DISCOUNT_TYPE;

@interface OfferTableItem : NSObject <MKAnnotation>
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *discount;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *offer_id;
@property (nonatomic, retain) NSString *offer_name;
@property (nonatomic, retain) NSNumber *brand_id;
@property (nonatomic, retain) NSNumber *category_id;
@property (nonatomic, retain) NSNumber *discount_type;
@property (nonatomic, retain) NSNumber *allowRedeem;
@property (assign, nonatomic) CLLocationCoordinate2D          location;
-(id)initWithData:(NSDictionary*)data;
@end
