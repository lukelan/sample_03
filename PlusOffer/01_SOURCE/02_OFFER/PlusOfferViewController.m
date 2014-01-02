//
//  PlusOfferViewController.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusOfferViewController.h"
#import "OfferTableItem.h"
#import "OfferModel.h"

@interface PlusOfferViewController () <NSFetchedResultsControllerDelegate>
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
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [a1 addTarget:self action:@selector(selectMap:) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"nav-bar-icon-map.png"] forState:UIControlStateNormal];
    UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithCustomView:a1];
    _viewTypeBtn = random;
    [self.viewTypeBtn setTitle:@"Map"];
    self.navigationItem.rightBarButtonItem = random;
    
    // init fetched result controller
    [self fetchedResultsController];
    
    viewName = PLUS_VIEW_CONTROLLER;
    self.trackedViewName = viewName;
    
    // just for testing purpose
    self.listOffers = [NSMutableArray array];
    _vcType = enumOfferInterfaceType_List;
    [self loadInterface:_vcType];
    [self reloadInterface:_vcType];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PINGREMARKETING
    [self loadOffers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Interface
-(void)loadInterface:(enumOfferInterfaceType)type
{
    _vcType = type;
    switch (type) {
        case enumOfferInterfaceType_List:
        {
            if (!_listView) {
                if (IS_IPHONE5) {
                    _listView = [[PlusOfferListView alloc] initWithFrame:CGRectMake(0, 65, 320, 455)];
                } else {
                    _listView = [[PlusOfferListView alloc] initWithFrame:CGRectMake(0, 65, 320, 380)];
                }
            }
            if (_mapView) [_mapView removeFromSuperview];

            [self.viewTypeBtn setTitle:@"Map"];

//              [_viewTypeBtn setImage:[UIImage imageNamed:@"nav-bar-icon-map.png"]];
           // [_viewTypeBtn setTintColor:UIColorFromRGB(0x2ed072)];
            
            self.tabBarController.tabBar.hidden = NO;
            
            _listView.dataSource = self.listOffers;
            [self.view addSubview:_listView];
            [self reloadInterface:type];
            break;
        }
        case enumOfferInterfaceType_Map:
        {
            if (!_mapView) {
                _mapView = [[PlusOfferMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 505)];
                _mapView.delegate = self;
            }
            if (_listView) [_listView removeFromSuperview];
            
            [self.viewTypeBtn setTitle:@"List"];
            [_viewTypeBtn setImage:[UIImage imageNamed:@"nav-bar-icon-map.png"]];
            [_viewTypeBtn setTintColor:UIColorFromRGB(0x2ed072)];
            
            [self.view addSubview:_mapView];
            
            self.tabBarController.tabBar.hidden = YES;
//            self.navigationController.navigationBarHidden = YES;
//            [UIView animateWithDuration:1.0f animations:^{
//                self.tabBarController.tabBar.hidden = YES;
//            }];
            
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
    if (sender.selected) {
        
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

#pragma mark - Actions

- (IBAction)btSegmented:(id)sender {
       checkOfferCategory = self.segmentPlusOffers.selectedSegmentIndex;
     [self loadOffers];
   // NSLog(@"%u",checkOfferCategory );
}

- (IBAction)listBtnTouchUpInside:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Map"]) {
        
        [self loadInterface:enumOfferInterfaceType_Map];
    }
    else {
        [self loadInterface:enumOfferInterfaceType_List];
    }
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
        
//        NSLog(@"%@",[NSString stringWithFormat:@"%hhd",  itemModel.allowRedeem ]);
//        NSLog(@"%f - %f", [itemModel.latitude floatValue], [itemModel.longitude floatValue]);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             @"map_offer.png", @"url",
                             itemModel.discount_value.stringValue, @"discount",
                             itemModel.distanceStr, @"distance",
                             itemModel.offer_id.stringValue, @"offer_id",
                             itemModel.offer_name, @"offer_name",
                             itemModel.brand_id, @"brand_id",
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


@end
