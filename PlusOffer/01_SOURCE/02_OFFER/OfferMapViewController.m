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
#import "BranchModel.h"

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
    
    self.tabBarDisplayType = TAB_BAR_DISPLAY_HIDE;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.layer.opacity = 0.9f;
    [self setTitle:_brandName];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor]];
    [self setCustomBarLeftWithImage:[UIImage imageNamed:@"nav-bar-icon-back.png"] selector:nil context_id:nil];
    [self setImageCustomBarRight:[UIImage imageNamed:@"map-icon-list.png"]];
    
    // load list branchs of current brand
    [self loadListBranchs];
    
    if (!_mapView) {
        if (IOS_VERSION >= 7.0)
        {
            _mapView = [[PlusOfferMapView alloc] initWithFrame: CGRectMake(0, 0, 320, IS_IPHONE5 ? 568  : 480)];
        }
        else
        {
            _mapView = [[PlusOfferMapView alloc] initWithFrame: CGRectMake(0, 0, 320, IS_IPHONE5 ? 550 : 460 )];
        }
        _mapView.delegate = self;
    }
    [_mapView setIsRegisteredHanleTap:_isRegisterHandleTapAnotation];
    [self.view addSubview:_mapView];
    [self reloadInterface];
}

-(void)reloadInterface
{
    [_mapView reloadInterface:self.fetchedResultsController.fetchedObjects];
    [_mapView checkToDrawRoute];
}

- (NSFetchedResultsController *)fetchedResultsController{
    
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BranchModel class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"branch_id" ascending:YES]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand_id = %@", [self.object brand_id]];
        [fetchRequest setPredicate:predicate];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController setDelegate:self];
        
        NSError *error = nil;
        [_fetchedResultsController performFetch:&error];
        
        NSAssert(!error, @"Error performing fetch request: %@", error);
        NSLog(@"num = %d", _fetchedResultsController.fetchedObjects.count);
    }
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self reloadInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API
-(void)loadListBranchs
{
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListBranch:self ofBrand:[self.object brand_id]];
}
@end
