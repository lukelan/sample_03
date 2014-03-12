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
#import "FacebookManager.h"
#import "SBJsonParser.h"
#import "BackgroundViewController.h"

void doLog(int level, id formatstring,...)
{
    int i;
    for (i = 0; i < level; i++) printf("    ");
    
    va_list arglist;
    if (formatstring)
    {
        va_start(arglist, formatstring);
        id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
        fprintf(stderr, "%s\n", [outstring UTF8String]);
        va_end(arglist);
    }
}

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
    
    
//    UIStoryboard * storyboard=[UIStoryboard storyboardWithName:[self storyboardName] bundle:nil];
//    self.mainVC = [storyboard instantiateViewControllerWithIdentifier:@"root1_vc"];
//    self.flipBoardNVC = [[FlipBoardNavigationController alloc]initWithRootViewController:self.mainVC];
//    self.window.rootViewController = [BackgroundViewController new]; //self.flipBoardNVC;
////    [self.window makeKeyAndVisible];
//    
//    self.foregroundWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.foregroundWindow.backgroundColor = [UIColor clearColor];
//    self.foregroundWindow.rootViewController = self.flipBoardNVC; //[ForegroundViewController new];
//    self.foregroundWindow.windowLevel = UIWindowLevelStatusBar;
//    self.foregroundWindow.hidden = NO;
   
    UIStoryboard * storyboard=[UIStoryboard storyboardWithName:[self storyboardName] bundle:nil];
    self.mainVC = [storyboard instantiateViewControllerWithIdentifier:@"root1_vc"];
    self.flipBoardNVC = [[FlipBoardNavigationController alloc]initWithRootViewController:self.mainVC];
    self.window.rootViewController = self.flipBoardNVC;
    [self.window makeKeyAndVisible];
    
    
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
    
#ifdef IS_GA_ENABLE
//        [GAI sharedInstance].trackUncaughtExceptions = YES;
//        [GAI sharedInstance].dispatchInterval = 20;
//        [GAI sharedInstance].debug = !YES;
//        id ga = [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKING_ID];
//        [ga setAppVersion:[AppDelegate getVersionOfApplication]];
//        [GAI sharedInstance].defaultTracker = ga;
#endif
 
#ifdef DEBUG
//    [Crittercism enableWithAppID:@"52bd2b0c8b2e334653000001"]; //Dev
#else
//    [Crittercism enableWithAppID:@"52bd2b5140020530ee000004"]; // Pro
#endif
    
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    
    //Tranking Conversion only support ios 6.0 or later
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
//    {
//        [GoogleConversionPing pingWithConversionId:@"983463027" label:@"FaebCO3VswUQ8-j51AM" value:@"5000" isRepeatable:NO idfaOnly:YES];
//    }
    
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    
    // init location manager
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    locationManager.distanceFilter = 100.0f;
//    userPosition = [[Position alloc] init];
//    [userPosition setCoordinateLongAndLat:CLLocationCoordinate2DMake(0, 0)];
//    [self updateUserLocationWithType:UpdateLocationTypeAuto];

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
    if (![tabBarController isKindOfClass:[UITabBarController class]]) {
        return nil;
    }
    UINavigationController *currentNavi = (UINavigationController *)[tabBarController selectedViewController] ;
    UIViewController *currentViewController = [currentNavi topViewController];
    return currentViewController;
}

-(UIViewController *) getViewControllerAtIndex:(int)index
{
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    if (![tabBarController isKindOfClass:[UITabBarController class]]) {
        return nil;
    }
    NSArray *arrNav = [tabBarController childViewControllers];
    if (arrNav.count <= index) {
        return nil;
    }
    UINavigationController *currentNavi = (UINavigationController *)[arrNav objectAtIndex:index];
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
        
        // Notification update user location
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:NOTIFICATION_NAME_PLUSOFFER_GPS_USER_LOCATION_DID_RECEIVE object:newLocation];
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
    NSString *addr =  userPosition.address;
    NSString *lat =  [NSString stringWithFormat:@"%f", userPosition.positionCoodinate2D.latitude];
    NSString *log =  [NSString stringWithFormat:@"%f", userPosition.positionCoodinate2D.longitude];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* time = [dateFormatter stringFromDate:[NSDate date]];
    if ([lat doubleValue] != lastSentLat || [log doubleValue] != lastSentLog)
    { //if new location
        [[CoreAPIManager sharedAPIManager] RK_UpdateLocationUserId:(self.isUserLoggedIn?self.userProfile.user_id:@"0") beInAddress:addr latitude:lat longitude:log atTime:time context:nil];
        lastSentLat = [lat doubleValue];
        lastSentLog = [log doubleValue];
    }
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

#pragma mark ultility Function
// Debug show structure of View
+ (void) explode: (id) aView level: (int) level
{
    doLog(level, @"%@", [[aView class] description]);
    doLog(level, @"%@", NSStringFromCGRect([aView frame]));
    for (UIView *subview in [aView subviews])
    [self explode:subview level:(level + 1)];
}

- (BOOL)checkShowRequestLogin
{
    if (![self isUserLoggedIn]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PlusOffer" message:@"Bạn phải đăng nhập để sử dụng tính năng này." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return YES;
    }
    return NO;
}

#pragma mark
#pragma mark RKManageDelegate method
- (void)processResultResponseDictionaryMapping:(DictionaryMapping *)dictionary requestId:(int)request_id
{
    if (request_id == ID_POST_UDID_DEVICE_TOKEN) {
        //process data return
        id result = [dictionary.curDictionary objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]])
        {
            //punch result
            if (self.userProfile == nil)
            {
                self.userProfile = [[UserProfile alloc] init];
            }
            [self.userProfile setUser_id:[result objectForKey:@"user_id"]];
            [self.userProfile setUser_code:[result objectForKey:@"user_code"]];
            NSLog(@"-----user_id = %@, user_code = %@", self.userProfile.user_id, self.userProfile.user_code);
        } else {
            NSLog(@"error = %@", [dictionary.curDictionary objectForKey:@"error"]);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_APP_BECOME_ACTICE object:nil];
    }
}

#pragma mark get record in DB
-(NSMutableArray *)fetchRecords:(NSString *)entityName sortWithKey:(NSString *)keyName ascending:(BOOL)isAscending withPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *nsManagedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    
    //Define out table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:nsManagedObjectContext];
    
    //setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //Create predicate (contraint dieu kien de lay du lieu)
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    //Define how we will sort the records
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyName ascending:isAscending];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    
    [request setSortDescriptors:sortArray];
    
    //Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[nsManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        //Handle error here
    }
    
    return  mutableFetchResults;
}

- (NSString *)storyboardName
{
	// fetch the appropriate storyboard name depending on platform
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		return @"Main";
	else
		return @"MainStoryboard_iPad";
}

@end
