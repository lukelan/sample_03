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
@dynamic branch_name;
@dynamic brand_name;
@dynamic user_punch;
@dynamic category_id;
@dynamic discount_type;
@dynamic discount_value;
@dynamic date_add;
@dynamic order_id;
@dynamic is_bookmark;
// update new api
@dynamic offer_date_end;
@dynamic max_punch;
//@dynamic user_punch;
@dynamic size1;
@dynamic size2;
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


// CRUD actions on database

+ (OfferModel*) getOfferWithID:(NSString*)offerID  {
    NSManagedObjectContext *_managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.includesSubentities = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[[self class] description] inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"offer_id"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // init predicate to search
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"offer_id == %@", offerID];
    [fetchRequest setPredicate:pred];
    
    //    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"kardName" cacheName:nil];
    
    NSError *error;
    
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (items.count == 0) {
        return nil;
    }
    
    return [items objectAtIndex:0];
}

+ (void) updateOfferID:(NSString*)offerID withBookMark:(BOOL)isBookMark  {
    //NSManagedObjectContext *_managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    
    OfferModel *kardModel = [self getOfferWithID:offerID];
    kardModel.is_bookmark = [NSNumber numberWithBool:isBookMark];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}

+ (void) removeKardID:(NSString*)kardID {
    NSManagedObjectContext *_managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    OfferModel *kardModel = [self getOfferWithID:kardID];
    [_managedObjectContext deleteObject:kardModel];
}


@end
