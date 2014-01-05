//
//  AppDelegate.h
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DefineConstant.h"
#import "Location.h"
#import "OfferTableItem.h"

@protocol OpenBarcodeScannerDelegate <NSObject>

- (void)processOpenBarcodeScanner;

@end

@protocol OpenMapViewDelegate <NSObject>

- (void)processOpenMapView;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
#pragma mark property using for core data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark - location
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) Location* userPosition;

#pragma mark -
@property (nonatomic, strong) NSString* currentView;
@property (strong, nonatomic) UIWindow *window;

+(NSString *)getVersionOfApplication;
-(UIViewController *) getCurrentViewController;


#pragma mark - OfferDetailViewController
-(void) changeToOfferDetailViewController:(OfferTableItem*)item;
@end
