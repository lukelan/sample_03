//
//  AppDelegate.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"
#import "RKXMLReaderSerialization.h"
#import "PlusOfferViewController.h"
#import "FacebookManager.h"
#import "SBJsonParser.h"
#import "OfferMapViewController.h"

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize userPosition,locationManager;

UpdateLocationType updateLocationFrom = UpdateLocationTypeAuto;

#pragma mark -
#pragma mark UIApplicationDelegate method
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // TrongV - 18/12/2013 - Check store DB schema compatible with current schema
    if(![self validateLocalDatabase]) {
        [self replaceDatabase];
    }
    
    //setup restkit
    [self setupReskit123Phim];
    
    // init cache and clear mem
    [[SDWebImageManager sharedManagerWithCachePath:CACHE_IMAGE_PATH] setCacheKeyFilter:^NSString *(NSURL *url) {
        if ([url isKindOfClass:[NSURL class]])
        {
            return [url absoluteString];
        }
        return (NSString *)url;
    }];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIImage *selectedImage0 = [UIImage imageNamed:@"tab-bar-plus-offer-active.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"tab-bar-plus-offer.png"];
    UIImage *selectedImage1 = [UIImage imageNamed:@"tab-bar-redeem-active.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"tab-bar-redeem.png"];    UIImage *selectedImage2 = [UIImage imageNamed:@"tab-bar-account-active.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"tab-bar-account.png"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    view.backgroundColor = [UIColor blueColor];
    UITabBar *tabBar = tabBarController.tabBar;
   // [tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab-bar.png"]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [tabBar setTintColor:UIColorFromRGB(0x8ed400)];
    }

    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    
    [item0 setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:11]} forState:UIControlStateNormal];
    [item2 setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:11]} forState:UIControlStateNormal];
   // [item1 setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    item0.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    item1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item2.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tab-bar-bg.png"]];
//    [tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab-bar-selected.png"]];
    //
    CGRect myRect = tabBarController.tabBar.frame;
    myRect.size.height = 20;
    tabBarController.tabBar.frame = myRect;
    //
    NSArray *arrNav = [tabBarController childViewControllers] ;
    for (int i = 0; i < arrNav.count; i++) {
        UINavigationController *temp = [arrNav objectAtIndex:i];
        if ([temp isKindOfClass:[UINavigationController class]])
        {
            if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0)
            {
                [temp.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:15], UITextAttributeTextColor : [UIColor blackColor]}];
                [temp setBackGroundImage:@"nav-bar-bg.png" forNavigationBar:temp.navigationBar];
             
            } else {
                [temp.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:15], NSForegroundColorAttributeName : [UIColor blackColor]}];
                [temp setBackGroundImage:@"nav-bar-bg-ios7.png" forNavigationBar:temp.navigationBar];
            }
        }
    }
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x666666), UITextAttributeTextColor, nil] forState:UIControlStateHighlighted];
 #ifdef IS_GA_ENABLE
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        [GAI sharedInstance].dispatchInterval = 20;
        [GAI sharedInstance].debug = !YES;
        id ga = [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKING_ID];
        [ga setAppVersion:[AppDelegate getVersionOfApplication]];
        [GAI sharedInstance].defaultTracker = ga;
#endif
 
#ifdef DEBUG
    [Crittercism enableWithAppID:@"52bd2b0c8b2e334653000001"]; //Dev
#else
    [Crittercism enableWithAppID:@"52bd2b5140020530ee000004"]; // Pro
#endif
    
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    
    //Tranking Conversion only support ios 6.0 or later
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        [GoogleConversionPing pingWithConversionId:@"983463027" label:@"FaebCO3VswUQ8-j51AM" value:@"5000" isRepeatable:NO idfaOnly:YES];
    }
    
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    
    // init location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100.0f;
    userPosition = [[Position alloc] init];
    [self updateUserLocationWithType:UpdateLocationTypeAuto];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(NSString *)getVersionOfApplication
{
    NSString* versionNum = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (versionNum.length < 4) {
        return versionNum;
    }
    NSString* tmp = [versionNum substringWithRange:NSMakeRange([versionNum length]-3, 3)];
    return tmp;
}

#pragma mark -
#pragma mark register Push notification
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // Send device token to the Provider
    NSString *tokenStr=[deviceToken description];
    NSString *pushToken=[[[tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"--------------device token = %@", pushToken);
//    NSString *deviceLocal = [APIManager getStringInAppForKey:KEY_STORE_MY_DEVICE_TOKEN];//lay device luu local
//    if (![pushToken isEqualToString:deviceLocal]) {
//        [[APIManager sharedAPIManager] postUIID:[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] andDeviceToken:pushToken context:[MainViewController sharedMainViewController]];
//        [APIManager setStringInApp:pushToken ForKey:KEY_STORE_MY_DEVICE_TOKEN];
//    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	LOG_APP(@"Failed to get token, error: %@", error.localizedDescription);
}

#pragma mark -
#pragma mark check compatible core data before launch to prevent crash when update to new version
#pragma mark override database prevent crash app
- (void)replaceDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // remove old sqlite database from documents directory
    NSURL *dbDocumentsURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",kSqliteFileName]];
    NSString *dbDocumentsPath = [dbDocumentsURL path];
    if ([fileManager fileExistsAtPath:dbDocumentsPath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:dbDocumentsPath error:&error];
        if (error) {
            LOG_APP(@"Error deleting sqlite database: %@", [error localizedDescription]);
        }
    }
}

// TrongV - 18/12/2013 - Check store DB schema compatible with current schema

#pragma mark - managedObjectContext

- (void)saveContext
{
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            LOG_APP(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [_managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kSqliteFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationCacheDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",kSqliteFileName]];
    
    LOG_APP(@"Local database path: %@", storeURL);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        LOG_APP(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns YES if local database is compatible with current model. Else return NO
- (BOOL)validateLocalDatabase
{
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",kSqliteFileName]];
    LOG_APP(@"Local database path: %@", [storeURL path]);
    
    NSError * error = nil;
    NSDictionary *storeMeta = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil URL:storeURL error:&error];
    
    if (!storeMeta) {
        LOG_APP(@"Unable to load store metadata from URL: %@; Error = %@", storeURL, error);
        return YES;
    }
    
    BOOL result = [[self managedObjectModel] isConfiguration: nil compatibleWithStoreMetadata: storeMeta];
    
    if (!result) {
        // reset _managedObjectModel to reload new model
        _managedObjectModel = nil;
        LOG_APP(@"Unable to load store metadata from URL: %@; Error = %i", storeURL, result);
    }
    return result;
}

#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory
{
    //    return [[NSBundle mainBundle] resourceURL];
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark setup config for restkit
- (void)setupReskit123Phim
{
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    // Initialize RestKit
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL_SERVER]];//[[RKObjectManager alloc] initWithHTTPClient:client];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    manager.managedObjectStore = managedObjectStore;
    
    /**
     Complete Core Data stack initialization
     */
    [managedObjectStore createPersistentStoreCoordinator];
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"PlusOfferModel.sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil  withConfiguration:nil options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    
    [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"text/html"];
    [[RKObjectManager sharedManager] setAcceptHeaderWithMIMEType:@"text/html"];
    
    [[RKObjectManager sharedManager] addFetchRequestBlock:^NSFetchRequest *(NSURL *URL)
     {
         RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:BASE_URL_SERVER];
         NSDictionary *filmDict = nil;
         BOOL match = [pathMatcher matchesPath:BASE_URL_SERVER tokenizeQueryStrings:NO parsedArguments:&filmDict];
         if (match) {
             RKResponseDescriptor *currentResponse = nil;
             if (![RKObjectManager sharedManager].responseDescriptors || [RKObjectManager sharedManager].responseDescriptors.count == 0) {
                 return nil;
             }
             currentResponse = [RKObjectManager sharedManager].responseDescriptors[0];
             if (!currentResponse || ![currentResponse.mapping isKindOfClass:[RKEntityMapping class]]) {
                 return nil;
             }
             NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
             NSEntityDescription *entity = [NSEntityDescription entityForName:[(RKEntityMapping *)currentResponse.mapping entity].name inManagedObjectContext:[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext];
             [fetchRequest setEntity:entity];
             return fetchRequest;
         }
         
         return nil;
     }];
}
-(UIViewController *) getCurrentViewController
{
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *currentNavi = (UINavigationController *)[tabBarController selectedViewController] ;
    UIViewController *currentViewController = [currentNavi topViewController];
    return currentViewController;
}


#pragma mark - Location
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    double distance = CGFLOAT_MAX;
    if (oldLocation)
    {
        distance = [newLocation distanceFromLocation:oldLocation];
    }
    // accurary is 100 metters
    if (distance > 100.0) //metters
    {
        // update new location
        [self getUserPositionFromLocation:newLocation];//it also reload Location cell in Accout view
    }
    
    [locationManager stopUpdatingLocation];
}

- (void)getUserPositionFromLocation:(CLLocation *)newLocation
{
    userPosition.positionCoodinate2D = newLocation.coordinate;
    //Use apple to get address not ful (ward, dictrict)
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation:newLocation
//                   completionHandler:^(NSArray *placemarks, NSError *error) {
//                       if (error){
//                           NSLog(@"Geocode failed with error: %@", error);
//                           return;
//                       }
//                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                       NSLog(@"placemark.ISOcountryCode %@",placemark.name);
//                   }];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error)
        {
            SBJsonParser* parsor = [[SBJsonParser alloc] init];
            NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary* rawData = [parsor objectWithString:string];
            
            if ([[rawData objectForKey:@"status"] isEqual:@"OK"]) {
                
                NSArray* result = [rawData objectForKey:@"results"];
                
                NSDictionary* address = [result objectAtIndex:0];
                
                NSString* formatted_address = [address objectForKey:@"formatted_address"];
                
                userPosition.address = formatted_address;
                
                if (updateLocationFrom == UpdateLocationTypeAuto) {
                    //get user location then save on server
                    [self storeUserLocationHistory];
                }
            }
        }
    }];
}

- (void)updateUserLocationWithType:(UpdateLocationType)type
{
    //    LOG_123PHIM(@"updateUserLocationWithType");
    [locationManager startUpdatingLocation];
    updateLocationFrom = type;
}

- (void)storeUserLocationHistory
{
    // Trongvm - 27/12/2013 - Skip check user login due to user_ID is optional
    //    if (!self.isUserLoggedIn) {
    //        return;
    //    }
    
//    NSString* addr;
//    NSString* lat;
//    NSString* log;
//    NSString* time;
//    
//    addr =  userPosition.address;
//    lat =  [NSString stringWithFormat:@"%f", userPosition.positionCoodinate2D.latitude];
//    log =  [NSString stringWithFormat:@"%f", userPosition.positionCoodinate2D.longitude];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    time = [dateFormatter stringFromDate:[NSDate date]];
//    if ([lat doubleValue] != lastSentLat || [log doubleValue] != lastSentLog) { //if new location
//        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
//        if ((now - lastTimeSentLocationToServer) > INTERVAL_BETWEEN_TWO_SEND_USER_LOCATION_TO_SERVER) {
//            [[APIManager sharedAPIManager] user: (self.isUserLoggedIn?self.userProfile.user_id:[NSString stringWithFormat:@"%d", NO_USER_ID]) beInAddress:addr lat:lat log:log atTime:time context:[MainViewController sharedMainViewController]];
//            lastSentLat = [lat doubleValue];
//            lastSentLog = [log doubleValue];
//            lastTimeSentLocationToServer = now;
//        }
//    }
}


#pragma mark - OfferDetailViewController
// OfferDetailViewController
-(void) changeToOfferDetailViewController:(OfferTableItem*)item {
    OfferDetailViewController *offerDetailViewController = [[self getCurrentViewController].storyboard instantiateViewControllerWithIdentifier:@"OfferDetailViewController"];
    [offerDetailViewController setOffer_id:item.offer_id];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [offerDetailViewController setHidesBottomBarWhenPushed:YES];
    }
    [[self getCurrentViewController].navigationController pushViewController:offerDetailViewController animated:YES];
}

#pragma mark - offerMapViewController
// OfferDetailViewController
-(void) toMapViewController:(id)object withTitle:(NSString*)title isHandleAction:(BOOL)isHandle
{
    OfferMapViewController *offerMapViewController = [[self getCurrentViewController].storyboard instantiateViewControllerWithIdentifier:@"OfferMapViewController"];
    [offerMapViewController setHidesBottomBarWhenPushed:YES];
    [offerMapViewController setBrandName:title];
    [offerMapViewController setObject:object];
    [offerMapViewController setIsRegisterHandleTapAnotation:isHandle];
    [[self getCurrentViewController].navigationController pushViewController:offerMapViewController animated:YES];
}

#pragma mark - Facebook Handle
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [self handleLaunchOpenUrl:url];
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)handleUserAccount
{
    FacebookManager *fbManager = [FacebookManager shareMySingleton];
    BOOL actived = [fbManager initFacebookSession];
    if (actived)
    {
        //[self performSelectorInBackground:@selector(getFacebookAccountInfo) withObject:nil];
        [self getFacebookAccountInfo];
    }
}

-(void)getFacebookAccountInfo
{
    LOG_APP(@"begin get face book info");
    FacebookManager *fbManager = [FacebookManager shareMySingleton];
    [fbManager getFacebookAccountInfoWithResponseContext:self selector:@selector(finishGetFacebookAccountInfo:)];
}

- (void)finishGetFacebookAccountInfo:(id<FBGraphUser>)fbUser
{
    if (fbUser)
    {
        //send request login to our server
//        [[APIManager sharedAPIManager] getRequestLoginFaceBookAccountWithContext:[APIManager sharedAPIManager]];
        
        //Chua co api login tam thoi login = facebook => login sucessful
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOAD_AVATAR object:nil];
    }
    else
    {
        //        login but can not get profile
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Không thể kết nối tới Facebook" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

- (BOOL)isUserLoggedIn
{
    return self.userProfile != nil;
}

- (void)handleLogout
{
    [[FacebookManager shareMySingleton] logout];
    _userProfile = nil;
}

-(void)handleLaunchOpenUrl:(NSURL *) idUrl
{
    //try to catch link to open view in my app (config in .plist) URL_scheme
}
@end
