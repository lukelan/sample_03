//
//  OfferDetailViewController.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "OfferDetailViewController.h"
#import "InfoPlusOfferCell.h"
#import "DiscountCell.h"
#import "OfferDetailModel.h"
#import "SlideCheckinCell.h"
#import "OfferDetailItem.h"
#import "PunchCell.h"
#import "OfferTableItem.h"

@interface OfferDetailViewController () <NSFetchedResultsControllerDelegate, ZBarReaderDelegate, MBSliderViewDelegate, OpenBarcodeScannerDelegate, OpenMapViewDelegate>

@property (nonatomic, retain) OfferDetailItem *dataSource;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation OfferDetailViewController

-(void)dealloc
{
    [NSFetchedResultsController deleteCacheWithName:@"offerDetail"];
    self.fetchedResultsController = nil;
    self.dataSource = nil;
    self.tableViewDetail = nil;
    zBarReader = nil;
    _overlayView = nil;
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
    
    self.tabBarController.tabBar.hidden = NO;
    
    viewName = OFFER_DETAIL_VIEW_CONTROLLER;
    self.trackedViewName = viewName;
    zBarReader = [[ZBarReaderViewController alloc] init];
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    _overlayView.backgroundColor = [UIColor clearColor];
    UIImageView *overlayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
    if (CGRectGetHeight(self.view.bounds) == 568) { // 4 inches
        overlayImage.frame = CGRectMake(0, 0, CGRectGetWidth(overlayImage.frame), CGRectGetHeight(overlayImage.frame));
    }
    else { // 3.5 inches
        overlayImage.frame = CGRectMake(0, -65, CGRectGetWidth(overlayImage.frame), CGRectGetHeight(overlayImage.frame));
    }
    [_overlayView addSubview:overlayImage];
    // cancel button
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 70, 25)];
    
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeScanner) forControlEvents:UIControlEventTouchUpInside];
    [_overlayView addSubview:cancelBtn];
    zBarReader.cameraOverlayView = _overlayView;
    
    [self setCustomBarLeftWithImage:[UIImage imageNamed:@"nav-bar-icon-back.png"] selector:nil context_id:nil];
    [self setCustomBarRightWithImage:[UIImage imageNamed:@"nav-bar-icon-map.png"] selector:@selector(processOpenMapView) context_id:self];
    
    // load default data in coredata
    [self reloadInterface];
    
    //request load from server
    [self loadOfferDetail];
}
-(void)viewDidAppear:(BOOL)animated
{
    PINGREMARKETING
}
#pragma mark - API
-(void)loadOfferDetail
{
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListPlusOfferDetail:self forOfferID:@"1"];
}

#pragma mark - NSFetchedResultsControllerDelegate

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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [NSFetchedResultsController deleteCacheWithName:@"offerDetail"];
    [self reloadInterface];
}

- (void)reloadInterface
{
//    NSLog(@"data = %@", self.fetchedResultsController.fetchedObjects);
    NSArray *temp = [self.fetchedResultsController.fetchedObjects mutableCopy];
    for (OfferDetailModel *itemModel in temp)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"http://plusoffer-dev.123phim.vn/img/temp/offer1.jpg", @"banner", [NSString stringWithFormat:@"%@", itemModel.branch_name], @"name",[NSString stringWithFormat:@"%@" ,itemModel.branch_address], @"address",[NSString stringWithFormat:@"%@" ,itemModel.branch_tel], @"tel", [NSString stringWithFormat:@"Mở cửa: %@ - %@", itemModel.hour_open, itemModel.hour_close], @"hour_working", [NSString stringWithFormat:@"%d", itemModel.offer_id.intValue], @"id", itemModel.offer_name, @"offer_name", itemModel.offer_description, @"description", @"http://plusoffer-dev.123phim.vn/img/temp/big-mac.png", @"icon", [NSString stringWithFormat:@"%d", itemModel.max_punch.intValue], @"max", [NSString stringWithFormat:@"%d", itemModel.count_punch.intValue], @"count",
            [NSString stringWithFormat:@"%d", itemModel.branch_id.intValue], @"branch_id", [NSString stringWithFormat:@"%f", itemModel.latitude.floatValue], @"latitude", [NSString stringWithFormat:@"%f", itemModel.longitude.floatValue], @"longitude",nil];
        self.dataSource = [[OfferDetailItem alloc] initWithData:dic];
        [self setTitle:itemModel.branch_name];
        break;
    }
    [self.tableViewDetail reloadData];
}

#pragma mark -
#pragma mark TableViewDataSource delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return enumOtherCell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == enumInfoPlusOfferCell)
    {
        NSString *cellID = [[InfoPlusOfferCell class] description];
        InfoPlusOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[InfoPlusOfferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (![cell delegate]) {
            [cell setDelegate:self];
        }
        [cell setObject:self.dataSource];
        return cell;
    }
    else if (indexPath.section == enumDiscountCell)
    {
        NSString *cellID = [[DiscountCell class] description];
        DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[DiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell setObject:self.dataSource];
        return cell;
    }
    else if (indexPath.section == enumSlideCheckinCell)
    {
        NSString *cellID = @"cellCheckin";
        SlideCheckinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[SlideCheckinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cell setDelegate:self];
            [cell loadContent];
        }
        return cell;
    } else if (indexPath.section == enumPuchCollectCell)
    {
        NSString *cellID = [[PunchCell class] description];
        PunchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[PunchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (!cell.delegate) {
            [cell setDelegate:self];
        }
        [cell setObject:self.dataSource];
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

#pragma mark -
#pragma mark TableViewDelegate method
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == enumInfoPlusOfferCell)
    {
        return 229;
    }
    else if (indexPath.section == enumDiscountCell)
    {
        return 83;
    }
    else if (indexPath.section == enumSlideCheckinCell)
    {
        return 50;
    }
    else if (indexPath.section == enumPuchCollectCell)
    {
        return 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == enumInfoPlusOfferCell) {
        return 1.0f;
    }
    return MARGIN_CELLX_GROUP/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == enumPuchCollectCell) {
        return MARGIN_CELLX_GROUP;
    }
    return MARGIN_CELLX_GROUP/2;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ZBarSDK method
- (void)loadBarCodeReader
{
    zBarReader.showsZBarControls = NO;
    zBarReader.readerDelegate = self;
    
    zBarReader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    ZBarImageScanner *scanner = zBarReader.scanner;
    // (optional) additional reader configuration here
    //            readerController.scanCrop = _scanZoneImage.frame;
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self.navigationController presentViewController:zBarReader animated:NO completion:nil];
    isScanScreen = YES;
    
    // start timer to check scan time out
    timer = [NSTimer scheduledTimerWithTimeInterval:10
                                             target:self
                                           selector: @selector(scanTimeOut)
                                           userInfo:nil
                                            repeats:NO];
    
    
    isScaning = YES;
    
    
}

-(void)closeScanner
{
    isScaning =  NO;
    [zBarReader dismissViewControllerAnimated:NO completion:nil];
    
    [timer invalidate];
    timer = nil;
}

- (void)scanTimeOut
{
    if (isScaning) {
        [self closeScanner];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time out" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    [self closeScanner];
    NSLog(@"data = %@", symbol.data);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Code" message:symbol.data delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

#pragma mark -
#pragma mark MBSliderViewDelegate method
-(void)sliderDidSlide:(MBSliderView *)slideView
{
    //open barcode scanner
    [self loadBarCodeReader];
}

#pragma mark -
#pragma mark OpenBarcodeSannerDelegate
- (void)processOpenBarcodeScanner
{
    [self loadBarCodeReader];
}

#pragma mark - Interface
-(void)loadInterface:(enumOfferDetailInterfaceType)type
{
    switch (type) {
        case enumOfferDetailInterfaceType_List:
        {
            if (!_tableViewDetail) {
                _tableViewDetail = [[UITableView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - TITLE_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT)];
            }
            
            if (_mapView) {
                [_mapView removeFromSuperview];
            }
            [_tableViewDetail setDataSource:self];
            [_tableViewDetail setDelegate:self];

            isShowingMap = NO;
            self.tabBarController.tabBar.hidden = NO;
            [self setImageCustomBarRight:[UIImage imageNamed:@"nav-bar-icon-map.png"]];
            [self.view addSubview:_tableViewDetail];
            break;
        }
        case enumOfferDetailInterfaceType_Map:
        {
            //-------Get object to display on map view------//
            OfferTableItem *item = nil;
            NSArray *temp = [self.fetchedResultsController.fetchedObjects mutableCopy];
            for (OfferDetailModel *itemModel in temp)
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"http://plusoffer-dev.123phim.vn/img/temp/offer1.jpg", @"url",  [NSString stringWithFormat:@"%d", itemModel.offer_id.intValue], @"offer_id",
                    itemModel.offer_name, @"offer_name",
                    [NSString stringWithFormat:@"%d", itemModel.branch_id.intValue], @"branch_id",
                    itemModel.discount_type.stringValue, @"discount_type",
                    itemModel.latitude.stringValue, @"latitude",
                    itemModel.longitude.stringValue, @"longitude",
                    itemModel.category_id.stringValue, @"category_id",nil];
                item = [[OfferTableItem alloc] initWithData:dic];
            }
            if (![item isKindOfClass:[OfferTableItem class]]) {
                return;
            }
            //---------------------------------------------//

            [self setImageCustomBarRight:[UIImage imageNamed:@"map-icon-list.png"]];
            if (!_mapView) {
                _mapView = [[PlusOfferMapView alloc] initWithFrame: CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
                _mapView.delegate = self;
            }
            
            if (_tableViewDetail) {
                [_tableViewDetail removeFromSuperview];
            }
            isShowingMap = YES;
            self.tabBarController.tabBar.hidden = YES;
            [self.view addSubview:_mapView];
            [_mapView reloadInterface:[NSMutableArray arrayWithObject:item]];
            [_mapView drawRouteToItemIndex:0];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark OpenMapViewDelegate method
- (void)processOpenMapView
{
    if (isShowingMap)
    {
        [self loadInterface:enumOfferDetailInterfaceType_List];
    }
    else
    {
        [self loadInterface:enumOfferDetailInterfaceType_Map];
    }
}
@end
