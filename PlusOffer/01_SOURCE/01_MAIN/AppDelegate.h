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
#import "Position.h"
#import "UserProfile.h"
#import "FlipBoardNavigationController.h"

@protocol OpenBarcodeScannerDelegate <NSObject>

- (void)processOpenBarcodeScanner;

@end

@protocol OpenMapViewDelegate <NSObject>

- (void)processOpenMapView;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate, RKManagerDelegate>
{
    double lastSentLat;
    double lastSentLog;
}

@property (nonatomic, assign) int punch_item_count;
#pragma mark property using for core data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark - location
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) Position* userPosition;
@property (nonatomic, strong) UserProfile *userProfile;

#pragma mark -
@property (nonatomic, strong) NSString* currentView;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FlipBoardNavigationController * flipBoardNVC;
@property (strong, nonatomic) UIViewController * mainVC;
@property (strong, nonatomic) UIWindow *foregroundWindow;
- (NSString *)storyboardName;

+(void) explode: (id) aView level: (int) level;
+(NSString *)getVersionOfApplication;
-(UIViewController *) getCurrentViewController;
-(UIViewController *) getViewControllerAtIndex:(int)index;
- (void)saveContext;

#pragma mark - facebook handle
- (BOOL)isUserLoggedIn;
- (void)handleLogout;
- (void)handleUserAccount;
- (BOOL)checkShowRequestLogin;

#pragma mark get record in DB
- (NSMutableArray *)fetchRecords:(NSString *)entityName sortWithKey:(NSString *)keyName ascending:(BOOL)isAscending withPredicate:(NSPredicate *)predicate;
@end
