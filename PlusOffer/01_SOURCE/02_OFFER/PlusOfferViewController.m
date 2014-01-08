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
#import "OfferModel.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface PlusOfferViewController () <NSFetchedResultsControllerDelegate, RKManagerDelegate>
@property (nonatomic, retain) NSMutableArray *listOffers;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end

@implementation PlusOfferViewController
{
    ENUM_PLUS_OFFER_CATEGORY_TYPE checkOfferCategory;
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
	// Do any additional setup after loading the view.
    // init fetched result controller
  //   self.navigationController.navigationBar.layer.opacity = 1.0f;
    [self fetchedResultsController];
    self.navigationController.navigationBar.translucent = NO;
    viewName = PLUS_VIEW_CONTROLLER;
    self.trackedViewName = viewName;
    
    [self setCustomBarRightWithImage:[UIImage imageNamed:@"nav-bar-icon-map.png"] selector:@selector(selectMap:) context_id:self];
    // just for testing purpose
    self.listOffers = [NSMutableArray array];
    _vcType = enumOfferInterfaceType_List;
    [self loadInterface:_vcType];
    [self reloadInterface:_vcType];
    [self setPropertiesForSegmentControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    PINGREMARKETING
    switch (_vcType) {
        case enumOfferInterfaceType_List: {
            self.tabBarController.tabBar.hidden = NO;
            break;
        }
        case enumOfferInterfaceType_Map: {
            self.tabBarController.tabBar.hidden = YES;
            break;
        }
        default:
            break;
    }
    //check New version to update
    [(PlusAPIManager *)[PlusAPIManager sharedAPIManager] RK_RequestApiCheckAppVersion:[AppDelegate getVersionOfApplication] responseContext:self];
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
    self.segmentPlusOffers.tintColor = UIColorFromRGB(0x8ed400);
    [_segmentPlusOffers setContentOffset:CGSizeMake(0, 1) forSegmentAtIndex:0];
     [_segmentPlusOffers setContentOffset:CGSizeMake(0, 1) forSegmentAtIndex:0];
     [_segmentPlusOffers setContentOffset:CGSizeMake(0, 1) forSegmentAtIndex:0];
    [self.segmentPlusOffers setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                     [UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:13], UITextAttributeFont,UIColorFromRGB(0x8ed400),UITextAttributeTextColor,[UIColor clearColor], UITextAttributeTextShadowColor,
                                                              nil] forState:UIControlStateNormal];
    [self.segmentPlusOffers setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                              [UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:13], UITextAttributeFont,[UIColor whiteColor], UITextAttributeTextColor
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
            self.navigationController.navigationBar.layer.opacity = 1.0f;
            if (IS_IOS7)
            {
                [self performShowTabBar];
            }
            else
            {
                [self performShowTabBarIOS6:self.tabBarController];
            }
            [self setImageCustomBarRight:[UIImage imageNamed:@"nav-bar-icon-map.png"]];
            _checkListOrMap = YES;
            _listView.dataSource = self.listOffers;
            [self.view addSubview:_listView];
            [self reloadInterface:type];
            break;
        }
        case enumOfferInterfaceType_Map:
        {
            if (IS_IOS7)
            {
                [self performHideTabBar];
                self.navigationController.navigationBar.layer.opacity = 0.95f;
            }
            else
            {
                _mapView.frame = CGRectMake(_mapView.frame.origin.x , _mapView.frame.origin.y , 320, IS_IPHONE5 ? 550 : 460 );
                [self performHideTabBarIOS6:self.tabBarController];
                self.navigationController.navigationBar.layer.opacity = 0.8f;
            }
            
            if (!_mapView) {
              
                if (IS_IOS7)
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
            _checkListOrMap = NO;
            [_mapView reloadInterface:self.listOffers];
            break;
        }
        default:
            break;
    }
}
-(void)selectMap:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (_checkListOrMap) {
        
        [self loadInterface:enumOfferInterfaceType_Map];
    }
    else {
        [self loadInterface:enumOfferInterfaceType_List];
    }
}
#pragma mark - API
-(void)loadOffers
{
    switch (checkOfferCategory) {
        case ENUM_PLUS_OFFER_CATEGORY_GETLIST: {
            [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListPlusOffer:self];
            break;
        }
        case ENUM_PLUS_OFFER_CATEGORY_CUISINE: {
            [(PlusAPIManager*)[PlusAPIManager sharedAPIManager]
             RK_RequestApiGetListPlusOfferWithCategory:self forCategory:[NSString stringWithFormat:@"%u", checkOfferCategory]];
            break;
        }
        case ENUM_PLUS_OFFER_CATEGORY_ENTERTAINMENT: {
            [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListPlusOfferWithCategory:self forCategory:[NSString stringWithFormat:@"%u", checkOfferCategory]];
        }
        default:
            break;
    }
}

#pragma mark - Actions Segment change

- (IBAction)btSegmented:(id)sender {
       checkOfferCategory = self.segmentPlusOffers.selectedSegmentIndex;
     [self loadOffers];
   // NSLog(@"%u",checkOfferCategory );
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController{
    
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([OfferModel class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"offer_id" ascending:YES]];
        
        NSFetchedResultsController *myFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [myFetchedResultsController setDelegate:self];
        self.fetchedResultsController = myFetchedResultsController;
        
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self reloadInterface:_vcType];
}

- (void)reloadInterface:(enumOfferInterfaceType)type
{
    self.dataSource = [self.fetchedResultsController.fetchedObjects mutableCopy];

    self.listOffers = [NSMutableArray array];
    for (OfferModel *itemModel in self.dataSource)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             @"map_offer.png", @"url",
                             itemModel.discount_value.stringValue, @"discount",
                             itemModel.distanceStr, @"distance",
                             itemModel.offer_id.stringValue, @"offer_id",
                             itemModel.offer_name, @"offer_name",
                             itemModel.brand_id, @"brand_id",
                             itemModel.branch_name, @"branch_name",
                             itemModel.brand_name, @"brand_name",
                             itemModel.discount_type, @"discount_type",
                             @(itemModel.allowRedeem) , @"allow_redeem",
                             itemModel.latitude , @"latitude",
                             itemModel.longitude , @"longitude",
                             itemModel.category_id , @"category_id", nil];
        OfferTableItem *item = [[OfferTableItem alloc] initWithData:dic];
        [self.listOffers addObject:item];
    }
    
    switch (type) {
        case enumOfferInterfaceType_List: {
            _listView.dataSource = self.listOffers;
            [_listView.tableView reloadData];
            break;
        }
        case enumOfferInterfaceType_Map: {
            [_mapView reloadInterface:self.listOffers];
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
