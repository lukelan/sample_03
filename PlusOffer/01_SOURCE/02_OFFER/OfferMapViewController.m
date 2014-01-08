//
//  OfferMapViewController.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/6/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "OfferMapViewController.h"
#import "OfferDetailModel.h"
#import "OfferDetailItem.h"
#import "OfferTableItem.h"

@interface OfferMapViewController () <NSFetchedResultsControllerDelegate, ZBarReaderDelegate>


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation OfferMapViewController

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
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.layer.opacity = 0.9f;
    [self setTitle:_brandName];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor]];
    [self setCustomBarLeftWithImage:[UIImage imageNamed:@"nav-bar-icon-back.png"] selector:nil context_id:nil];
    OfferTableItem *item = nil;
    if (_object == nil)
    {
    NSArray *temp = [self.fetchedResultsController.fetchedObjects mutableCopy];
    for (OfferDetailModel *itemModel in temp)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"http://plusoffer-dev.123phim.vn/img/temp/offer1.jpg", @"url",  [NSString stringWithFormat:@"%d", itemModel.offer_id.intValue], @"offer_id",
                             itemModel.offer_name, @"offer_name",
                             [NSString stringWithFormat:@"%d", itemModel.branch_id.intValue], @"branch_id",
                             itemModel.discount_type.stringValue, @"discount_type",
                             itemModel.latitude.stringValue, @"latitude",
                             itemModel.longitude.stringValue, @"longitude",
                             itemModel.category_id.stringValue, @"category_id",nil];        item = [[OfferTableItem alloc] initWithData:dic];
    }
    if (![item isKindOfClass:[OfferTableItem class]]) {
        return;
    }
    }
    else
    {
        item = _object;
    }
    //---------------------------------------------//
    
    [self setImageCustomBarRight:[UIImage imageNamed:@"map-icon-list.png"]];
    if (!_mapView) {
        if IS_IOS7{
            _mapView = [[PlusOfferMapView alloc] initWithFrame: CGRectMake(0, 0, 320, IS_IPHONE5 ? 568  : 480)];
        }
        else
        {
            _mapView = [[PlusOfferMapView alloc] initWithFrame: CGRectMake(0, 0, 320, IS_IPHONE5 ? 550 : 460 )];
        }
        _mapView.delegate = self;
    }
    [_mapView setIsRegisteredHanleTap:_isRegisterHandleTapAnotation];
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:_mapView];
    [_mapView reloadInterface:[NSMutableArray arrayWithObject:item]];
    [_mapView checkToDrawRoute];    
}

- (NSFetchedResultsController *)fetchedResultsController{
    
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([OfferDetailModel class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"offer_id" ascending:YES]];
        
        NSFetchedResultsController *myFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:@"offerDetail"];
        [myFetchedResultsController setDelegate:self];
        self.fetchedResultsController = myFetchedResultsController;
        
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
