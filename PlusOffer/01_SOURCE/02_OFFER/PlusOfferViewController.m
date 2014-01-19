//
//  PlusOfferViewController.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusOfferViewController.h"
#import "VersionNotificationViewController.h"
#import "OfferTableItem.h"
#import "NearByOffer.h"
#import "CuisineOffer.h"
#import "EntertainmentOffer.h"
#import "BranchModel.h"

@interface PlusOfferViewController () <NSFetchedResultsControllerDelegate, RKManagerDelegate>
@property (nonatomic, retain) NSMutableArray *listOffers;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_NearByOffer;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_CuisineOffer;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_EntertainmentOffer;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController_Branches;
@end

@implementation PlusOfferViewController
{
    ENUM_PLUS_OFFER_CATEGORY_TYPE checkOfferCategory;
}

- (void)dealloc {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:NOTIFICATION_NAME_PLUSOFFER_GPS_USER_LOCATION_DID_RECEIVE object:nil];
    [center removeObserver:self name:NOTIFICATION_NAME_APP_BECOME_ACTICE object:nil];
    
    [_listOffers removeAllObjects];
    [_dataSource removeAllObjects];
    _fetchedResultsController = nil;
    
    _listView = nil;
    _mapView = nil;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarDisplayType = TAB_BAR_DISPLAY_SHOW;
    
    //check New version to update
    [(PlusAPIManager *)[PlusAPIManager sharedAPIManager] RK_RequestApiCheckAppVersion:[AppDelegate getVersionOfApplication] responseContext:self];
    
    // Register receive notification
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveUserLocation:) name:NOTIFICATION_NAME_PLUSOFFER_GPS_USER_LOCATION_DID_RECEIVE object:nil];
    
    [self fetchedResultsController_NearByOffer];
    [self fetchedResultsController_CuisineOffer];
    [self fetchedResultsController_EntertainmentOffer];
    [self fetchedResultsController_Branches];
    self.navigationController.navigationBar.translucent = NO;
    if (IOS_VERSION >= 7.0) {
        self.navigationController.navigationBar.layer.opacity = 0.95f;
    }
    else {
        self.navigationController.navigationBar.layer.opacity = 0.8f;
    }
    viewName = PLUS_VIEW_CONTROLLER;
    self.trackedViewName = viewName;
    [self setCustomBarRightWithImage:[UIImage imageNamed:@"nav-bar-icon-map.png"] selector:@selector(selectMap:) context_id:self];
    [self setCustomBarLeftWithImage:[UIImage imageNamed:@"nav-bar-icon-map.png"] selector:@selector(favourite:) context_id:self];
    // just for testing purpose
    self.listOffers = [NSMutableArray array];
    _vcType = enumOfferInterfaceType_List;
    [self loadInterface:_vcType];
    [self reloadInterface:_vcType];
    [self setPropertiesForSegmentControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:NOTIFICATION_NAME_APP_BECOME_ACTICE object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [AppDelegate explode:self.view level:0];
//    PINGREMARKETING
    switch (_vcType) {
        case enumOfferInterfaceType_List: {
            self.tabBarDisplayType = TAB_BAR_DISPLAY_SHOW;
            break;
        }
        case enumOfferInterfaceType_Map: {
            //[self.view setFrame:CGRectMake(0, 0, 320, 480)];
            self.tabBarDisplayType = TAB_BAR_DISPLAY_HIDE;
            [_mapView setIsRegisteredHanleTap:YES];
            self.navigationController.navigationBar.translucent = YES;
            [self setImageCustomBarRight:[UIImage imageNamed:@"map-icon-list.png"]];
            _checkListOrMap = NO;
            [_mapView reloadInterface:self.fetchedResultsController_Branches.fetchedObjects];
            break;
        }
        default:
            break;
    }
    
    if (IOS_VERSION >= 7.0) {
        self.navigationController.navigationBar.layer.opacity = 0.95f;
    }
    else {
        self.navigationController.navigationBar.layer.opacity = 0.8f;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPropertiesForSegmentControl
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        UIImage *segUnselectedSelected = [UIImage imageNamed:@"segment_deselected_selected.png"];
        [self.segmentPlusOffers setDividerImage:segUnselectedSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        
        UIImage *segmentSelectedUnselected = [UIImage imageNamed:@"segment_selected_deselected.png"];
        [self.segmentPlusOffers setDividerImage:segmentSelectedUnselected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        UIImage *segmentUnselectedUnselected = [UIImage imageNamed:@"segment_deselected_deselected.png"];
        [self.segmentPlusOffers setDividerImage:segmentUnselectedUnselected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.segmentPlusOffers.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.97f];
    }
    self.segmentPlusOffers.tintColor = UIColorFromRGB(0x777777);
    [_segmentPlusOffers setContentOffset:CGSizeMake(0, 1) forSegmentAtIndex:0];
     [_segmentPlusOffers setContentOffset:CGSizeMake(0, 1) forSegmentAtIndex:0];
     [_segmentPlusOffers setContentOffset:CGSizeMake(0, 1) forSegmentAtIndex:0];
    [self.segmentPlusOffers setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                     [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:13], UITextAttributeFont,UIColorFromRGB(0x777777),UITextAttributeTextColor,[UIColor clearColor], UITextAttributeTextShadowColor,
                                                              nil] forState:UIControlStateNormal];
    [self.segmentPlusOffers setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                              [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:13], UITextAttributeFont,[UIColor whiteColor], UITextAttributeTextColor
                                                              ,[UIColor clearColor], UITextAttributeTextShadowColor,
                                                              nil] forState:UIControlStateSelected];
    
    [self.segmentPlusOffers setBackgroundImage:[UIImage imageNamed:@"segment_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentPlusOffers setBackgroundImage:[UIImage imageNamed:@"segment_selected_hl.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;

}

#pragma mark - Interface
-(void)loadInterface:(enumOfferInterfaceType)type
{
    _vcType = type;
    switch (type) {
        case enumOfferInterfaceType_List:
        {
            if (!_listView) {
                _listView = [[PlusOfferListView alloc] initWithFrame: CGRectMake(0, 0, 320, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - CHECK_IOS )];
            }
      
            if (_mapView)
            {
                [_mapView removeFromSuperview];
            }
            self.navigationController.navigationBar.translucent = NO;
            [self showTabBar];
            
            [self setImageCustomBarRight:[UIImage imageNamed:@"nav-bar-icon-map.png"]];
            _checkListOrMap = YES;
            _listView.dataSource = self.listOffers;
            [self.view addSubview:_listView];
            [self reloadInterface:type];
            break;
        }
        case enumOfferInterfaceType_Map:
        {
            [self hideTabBar];
            
            if (!_mapView) {
              
                if (IOS_VERSION >= 7.0)
                {
                    _mapView = [[PlusOfferMapView alloc] initWithFrame: CGRectMake(0, 0, 320, IS_IPHONE5 ? 568  : 480)];
                }
                else
                {
                    _mapView = [[PlusOfferMapView alloc] initWithFrame: CGRectMake(0, 0, 320, IS_IPHONE5 ? 460  : 372)];
                }
                _mapView.delegate = self;
            }
            [_mapView setIsRegisteredHanleTap:YES];
            if (_listView)
            {
                [_listView removeFromSuperview];
            }
            self.navigationController.navigationBar.translucent = YES;
            [self setImageCustomBarRight:[UIImage imageNamed:@"map-icon-list.png"]];
            [self.view addSubview:_mapView];
//            [AppDelegate explode:self.view level:0];
            _checkListOrMap = NO;
            [_mapView reloadInterface:self.fetchedResultsController_Branches.fetchedObjects];
            
            break;
        }
        default:
            break;
    }
}

- (void) hideTabBar {
    if (IOS_VERSION >= 7.0) {
        [self performHideTabBar];
        self.navigationController.navigationBar.layer.opacity = 0.95f;
    }
    else {
        [self performHideTabBarIOS6:self.tabBarController];
        self.navigationController.navigationBar.layer.opacity = 0.8f;
    }
}

- (void) showTabBar {

    if (IOS_VERSION >= 7.0) {
        [self performShowTabBar];
        self.navigationController.navigationBar.layer.opacity = 0.95f;
    }
    else {
        [self performShowTabBarIOS6:self.tabBarController];
        self.navigationController.navigationBar.layer.opacity = 0.8f;
    }
}

-(void)selectMap:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (_checkListOrMap) {
        _checkListOrMap = NO;
        [self loadInterface:enumOfferInterfaceType_Map];
    }
    else {
        [self loadInterface:enumOfferInterfaceType_List];
    }
}

-(void)favourite:(UIButton*)sender
{
    sender.selected = !sender.selected;

}

-(void)receiveUserLocation:(NSNotification *)notification
{
    if ([notification object] && _vcType == enumOfferInterfaceType_List)
    {
        [self reloadInterface:_vcType];
    }
}

#pragma mark - API
-(void)loadOffers
{
    [self reloadInterface:_vcType];
}

-(void)appBecomeActive
{
    // banches
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListBranch:self ofBrand:nil];
    
    // nearest
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListPlusOffer:self];
    
    // cuisine
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListPlusOfferWithCategory:self forCategory:[NSString stringWithFormat:@"%u", ENUM_PLUS_OFFER_CATEGORY_CUISINE]];
    
    // entertainment
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListPlusOfferWithCategory:self forCategory:[NSString stringWithFormat:@"%u", ENUM_PLUS_OFFER_CATEGORY_ENTERTAINMENT]];
}

#pragma mark - Actions Segment change

- (IBAction)btSegmented:(id)sender {
       checkOfferCategory = self.segmentPlusOffers.selectedSegmentIndex;
     [self loadOffers];
   // NSLog(@"%u",checkOfferCategory );
}
#pragma mark - NSFetchedResultsControllerDelegate

-(NSFetchedResultsController *)fetchedResultsController
{
    if (!_checkListOrMap) {
        // map: get branches of all brand
        _fetchedResultsController = _fetchedResultsController_Branches;
    }
    else {
        // list
        switch (checkOfferCategory) {
            case ENUM_PLUS_OFFER_CATEGORY_GETLIST: {
                _fetchedResultsController = _fetchedResultsController_NearByOffer;
                break;
            }
            case ENUM_PLUS_OFFER_CATEGORY_CUISINE: {
                _fetchedResultsController = _fetchedResultsController_CuisineOffer;
                break;
            }
            case ENUM_PLUS_OFFER_CATEGORY_ENTERTAINMENT: {
                _fetchedResultsController = _fetchedResultsController_EntertainmentOffer;
                break;
            }
            default:
                break;
        }
    }
    
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsController_NearByOffer{
    
    if (!_fetchedResultsController_NearByOffer)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([NearByOffer class])];
        [fetchRequest setIncludesSubentities:NO];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"offer_id" ascending:YES]];
        
        _fetchedResultsController_NearByOffer = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController_NearByOffer setDelegate:self];
        
        NSError *error = nil;
        [_fetchedResultsController_NearByOffer performFetch:&error];
        
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController_NearByOffer;
}

- (NSFetchedResultsController *)fetchedResultsController_CuisineOffer{
    
    if (!_fetchedResultsController_CuisineOffer)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([CuisineOffer class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"offer_id" ascending:YES]];
        [fetchRequest setIncludesSubentities:NO];
        
        _fetchedResultsController_CuisineOffer = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController_CuisineOffer setDelegate:self];
        
        NSError *error = nil;
        [_fetchedResultsController_CuisineOffer performFetch:&error];
        
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController_CuisineOffer;
}

- (NSFetchedResultsController *)fetchedResultsController_EntertainmentOffer{
    
    if (!_fetchedResultsController_EntertainmentOffer)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([EntertainmentOffer class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"offer_id" ascending:YES]];
        [fetchRequest setIncludesSubentities:NO];
        
        _fetchedResultsController_EntertainmentOffer = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController_EntertainmentOffer setDelegate:self];
        
        NSError *error = nil;
        [_fetchedResultsController_EntertainmentOffer performFetch:&error];
        
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController_EntertainmentOffer;
}

- (NSFetchedResultsController *)fetchedResultsController_Branches {
    
    if (!_fetchedResultsController_Branches)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BranchModel class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"branch_id" ascending:YES]];
        [fetchRequest setIncludesSubentities:NO];
        
        _fetchedResultsController_Branches = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController_Branches setDelegate:self];
        
        NSError *error = nil;
        [_fetchedResultsController_Branches performFetch:&error];
        
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController_Branches;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self reloadInterface:_vcType];
}

- (void)reloadInterface:(enumOfferInterfaceType)type
{
    switch (type) {
        case enumOfferInterfaceType_List: {
            self.dataSource = [self.fetchedResultsController.fetchedObjects mutableCopy];
            
            self.listOffers = [NSMutableArray array];
            for (OfferModel *itemModel in self.dataSource)
            {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:itemModel.discount_value.stringValue forKey:@"discount"];
                [dic setValue:itemModel.distanceStr forKey:@"distance"];
                [dic setValue:@(itemModel.distance) forKey:@"distanceNum"];
                [dic setValue:itemModel.offer_id.stringValue forKey:@"offer_id"];
                [dic setValue:itemModel.offer_name forKey:@"offer_name"];
                [dic setValue:itemModel.brand_id forKey:@"brand_id"];
                [dic setValue:itemModel.branch_name forKey:@"branch_name"];
                [dic setValue:itemModel.brand_name forKey:@"brand_name"];
                [dic setValue:itemModel.discount_type forKey:@"discount_type"];
                [dic setValue:@(itemModel.allowRedeem)  forKey:@"allow_redeem"];
                [dic setValue:itemModel.latitude forKey:@"latitude"];
                [dic setValue:itemModel.longitude forKey:@"longitude"];
                [dic setValue:itemModel.category_id forKey:@"category_id"];
                [dic setValue:itemModel.offer_date_end forKey:@"offer_date_end"];
                [dic setValue:itemModel.user_punch forKey:@"user_punch"];
                [dic setValue:itemModel.max_punch forKey:@"max_punch"];
                [dic setValue:itemModel.size1 forKey:@"size1"];
                [dic setValue:itemModel.size2 forKey:@"size2"];
                OfferTableItem *item = [[OfferTableItem alloc] initWithData:dic];
                [self.listOffers addObject:item];
            }
            
            self.listOffers = [NSMutableArray arrayWithArray:[self.listOffers sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                float first = [(OfferTableItem*)a distanceNum];
                float second = [(OfferTableItem*)b distanceNum];
                return (first>second);
            }]];
            
            _listView.dataSource = self.listOffers;
            
            [_listView.tableView reloadData];
            break;
        }
        case enumOfferInterfaceType_Map: {
            
            [_mapView reloadInterface:self.fetchedResultsController_Branches.fetchedObjects];
            break;
        }
        default:
            break;
    }
    
}
#pragma mark -
#pragma mark RKManagerDelegate
#pragma mark -
-(void)processResultResponseDictionaryMapping:(DictionaryMapping *)dictionary requestId:(int)request_id
{
    if (request_id == ID_REQUEST_CHECK_VERSION)
    {
        [self getResultCheckVersionResponse:[(PlusAPIManager *)[PlusAPIManager sharedAPIManager] parseToGetVersionInfo:dictionary.curDictionary]];
    }
}

- (void)getResultCheckVersionResponse:(NSDictionary *)dic
{
    if (dic)
    {
        // Fix bug VersionNotificationViewController no action
        NSString *imageLink = [dic objectForKey:@"logo"];
        NSNumber *status = [dic objectForKey:@"status"];
        BOOL canSkip = status.intValue < 2;
        VersionNotificationViewController *versionNotifiCation = [[VersionNotificationViewController alloc] init];
        versionNotifiCation.canSkip = canSkip;
        versionNotifiCation.imageLink = imageLink;
        versionNotifiCation.dismissWhenSkip = YES;
        [self.navigationController presentViewController:versionNotifiCation animated:YES completion:^{
        }];
    }
    else
    {
        [self loadOffers];
    }
}
@end
