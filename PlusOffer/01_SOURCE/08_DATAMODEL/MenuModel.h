//
//  MenuModel.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/14/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MenuModel : NSManagedObject

@property (nonatomic, retain) NSNumber * item_id;
@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSNumber * item_price;
@property (nonatomic, retain) NSString * item_description;
@property (nonatomic, retain) NSString * item_image;
@property (nonatomic, retain) NSNumber * brand_id;
@property (nonatomic, retain) NSNumber * order_id;
@end
