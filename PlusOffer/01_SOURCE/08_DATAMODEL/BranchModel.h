//
//  BranchModel.h
//  PlusOffer
//
//  Created by trongvm on 1/18/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BranchModel : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSNumber * branch_id;
@property (nonatomic, retain) NSString * branch_name;
@property (nonatomic, retain) NSString * branch_name_slug;
@property (nonatomic, retain) NSString * branch_address;
@property (nonatomic, retain) NSString * branch_tel;
@property (nonatomic, retain) NSNumber * brand_id;
@property (nonatomic, retain) NSNumber * category_id;
@property (nonatomic, retain) NSNumber * location_id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * hour_open;
@property (nonatomic, retain) NSString * hour_close;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * is_active;
@property (nonatomic, retain) NSString * date_add;
@property (nonatomic, retain) NSString * date_update;
@property (nonatomic, retain) NSString * size1;
@property (nonatomic, retain) NSString * size2;
@property (nonatomic, retain) NSString * size3;

// additional variables
@property (assign, nonatomic) CLLocationCoordinate2D location;
@end
