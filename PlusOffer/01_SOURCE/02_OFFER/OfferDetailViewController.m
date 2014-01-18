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
#import "RuleCell.h"
#import "MBSliderView.h"
#import "OfferDetailItem.h"
#import "PunchCell.h"
#import "OfferTableItem.h"
#import "OfferMapViewController.h"
#import "MenuViewController.h"
#import "plusOtherCell.h"
#import "titleCell.h"
#import "DescriptionCell.h"
@interface OfferDetailViewController () <NSFetchedResultsControllerDelegate, ZBarReaderDelegate, MBSliderViewDelegate, OpenBarcodeScannerDelegate, OpenMapViewDelegate, RKManagerDelegate, DescriptionDelegate>

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
    self.tabBarDisplayType = TAB_BAR_DISPLAY_HIDE;
    
    _arrayMenu = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.layer.opacity = 1.0f;
    if(IOS_VERSION < 7.0)
    {
          [self performHideTabBarIOS6:self.tabBarController];
    }
    
    [self.tableViewDetail setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    [self.tableViewDetail setSeparatorColor:[UIColor clearColor]];
    _tableViewDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableViewDetail setSeparatorColor:[UIColor clearColor]];
    _tableViewDetail.frame = CGRectMake(_tableViewDetail.frame.origin.x, _tableViewDetail.frame.origin.y, _tableViewDetail.frame.size.width, self.view.frame.size.height);
    [self.tableViewDetail setBackgroundView:nil];
    self.viewBottom.frame = CGRectMake(_viewBottom.frame.origin.x, self.view.frame.size.height - _viewBottom.frame.size.height - NAVIGATION_BAR_HEIGHT - CHECK_IOS, _viewBottom.frame.size.width, _viewBottom.frame.size.height);    self.viewBottom.layer.opacity = 0.9;
    
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
    [self setCustomBarRightWithImage:[UIImage imageNamed:@"nav-bar-icon-share.png"] selector:@selector(selectMap) context_id:self];
    

    // load default data in coredata
    [self reloadInterface];
    
    //request load from server
    [self loadOfferDetail];
}
-(void)viewDidAppear:(BOOL)animated
{
    //PINGREMARKETING
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.layer.opacity = 1.0f;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // Navigation button was pressed. Do some stuff
        [self.navigationController popViewControllerAnimated:NO];
    }
    [super viewWillDisappear:animated];
}
#pragma mark - API
-(void)loadOfferDetail
{
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListPlusOfferDetail:self forOfferID:self.offer_id];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController{
    
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([OfferDetailModel class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"offer_id" ascending:YES]];        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"offer_id=%d", self.offer_id.intValue];
        [fetchRequest setPredicate:predicate];
        
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
   // NSLog(@"data = %@", self.fetchedResultsController.fetchedObjects);
    NSArray *temp = [self.fetchedResultsController.fetchedObjects mutableCopy];
    for (OfferDetailModel *itemModel in temp)
    {
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setValue:itemModel.branch_name forKey:@"name"];
        [dic setValue:[NSString stringWithFormat:@"%@" ,itemModel.branch_address] forKey:@"address"];
        [dic setValue:[NSString stringWithFormat:@"%@" ,itemModel.branch_tel] forKey:@"tel"];
        [dic setValue:[NSString stringWithFormat:@"Mở cửa: %@ - %@", itemModel.hour_open, itemModel.hour_close] forKey:@"hour_working"];
        [dic setValue:[NSString stringWithFormat:@"%d", itemModel.offer_id.intValue] forKey:@"id"];
        [dic setValue:itemModel.offer_name forKey:@"offer_name"];
        [dic setValue:itemModel.offer_description forKey:@"description"];
        [dic setValue:[NSString stringWithFormat:@"%d", itemModel.max_punch.intValue] forKey:@"max"];
        [dic setValue:[NSString stringWithFormat:@"%d", itemModel.branch_id.intValue] forKey:@"branch_id"];
        [dic setValue:[NSString stringWithFormat:@"%f", itemModel.latitude.floatValue] forKey:@"latitude"];
        [dic setValue:[NSString stringWithFormat:@"%f", itemModel.longitude.floatValue] forKey:@"longitude"];
        [dic setValue:itemModel.offer_date_end forKey:@"offer_date_end"];
        [dic setValue:itemModel.user_punch forKey:@"user_punch"];
        [dic setValue:itemModel.size1 forKey:@"size1"];
        [dic setValue:itemModel.size2 forKey:@"size2"];
        [dic setValue:itemModel.offer_content forKey:@"content"];
        [dic setValue:itemModel.path forKey:@"path"];
        [dic setValue:itemModel.menu forKey:@"menu"];
        [dic setValue:_detailDistance forKey:@"distance"];
        [dic setValue:_brandName forKey:@"brand_name"];
        self.dataSource = [[OfferDetailItem alloc] initWithData:dic];
        [self setTitle:itemModel.brand_name];
        [self setBrand_id:itemModel.brand_id.stringValue];
        break;
    }
    [self.tableViewDetail reloadData];
}

#pragma mark -
#pragma mark TableViewDataSource delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section == enumInfoPlusOfferCell)
    {
        return 1;
    }
    else if (section == enumDescription)
    {
        return 1;
    }
    else if (section == enumOtherCell)
    {
        _arrayMenu = self.dataSource.menu;
        if  ([_arrayMenu count] == 0)
        {
            return 0;
        }
        return  [_arrayMenu count] + 1;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == enumInfoPlusOfferCell)
    {
        NSString *cellID = [[InfoPlusOfferCell class] description];
        InfoPlusOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[InfoPlusOfferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (![cell delegate]) {
            [cell setDelegate:self];
        }
        [cell setObject:self.dataSource];
        return cell;
    }
    else if (indexPath.section == enumDescription)
    {
        NSString *cellID = [[DescriptionCell class] description];
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[DescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setDataDescription:self.dataSource];
        return cell;
    }
    else if (indexPath.section == enumOtherCell)
    {
        NSString *cellID = [[plusOtherCell class] description];
        plusOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[plusOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
        }
        if (indexPath.row == 0)
        {
            NSString *cellID = [[titleCell class] description];
            titleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[titleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.titleLbl.text = [NSString stringWithFormat:@"Xem tất cả menu của %@", self.title ];
            
            return cell;
        }
        
        _arrayMenu = self.dataSource.menu;
        if ([_arrayMenu count] > 0)
        {
            [cell setData:self.dataSource :indexPath.row - 1];
        }
        if (indexPath.row == [_arrayMenu count])
        {
            cell.bottomBorder.hidden = true;
        }
        return cell;
    }
    return nil;
}
#pragma mark -
#pragma mark TableViewDelegate method
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == enumInfoPlusOfferCell)
    {
        return 340.0f;
    }
    else if (indexPath.section == enumDescription)
    {
        return [DescriptionCell getHeightForCellWithData:self.dataSource];
    }
    else if (indexPath.section == enumOtherCell)
    {
        if (indexPath.row == 0)
        {
            return 50;
        }
        return 70;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate toMenuViewController :_brand_id];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == enumInfoPlusOfferCell) {
        return 0.01f;
    }
    return MARGIN_CELLX_GROUP/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 60;
    }
    return 0;
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
//    NSLog(@"data = %@", symbol.data);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Code" message:symbol.data delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
    [(PlusAPIManager *)[PlusAPIManager sharedAPIManager] RK_RequestPunchUser:@"1" atBrand:self.brand_id withCode:symbol.data numberOfPunch:[NSNumber numberWithInt:1] context:self];
}

#pragma mark -
#pragma mark MBSliderViewDelegate method
-(void)sliderDidSlide:(MBSliderView *)slideView
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //open barcode scanner
    CLLocationCoordinate2D coordinate = self.dataSource.location;
    if (CLLocationCoordinate2DIsValid(delegate.userPosition.positionCoodinate2D))
    {
        coordinate = delegate.userPosition.positionCoodinate2D;
    }
    [(PlusAPIManager *)[PlusAPIManager sharedAPIManager] RK_RequestApiCheckinContext:nil forUserID:delegate.userProfile.user_id atBanchID:self.dataSource.branch_id withCoordinate:coordinate];
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
//            self.tabBarController.tabBar.hidden = NO;
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
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"http://plusoffer-dev.123phim.vn/img/temp/offer1.jpg", @"url",  [NSString stringWithFormat:@"%d", itemModel.offer_id.intValue], @"offer_id",
//                    itemModel.offer_name, @"offer_name",
//                    [NSString stringWithFormat:@"%d", itemModel.branch_id.intValue], @"branch_id",
//                    itemModel.discount_type.stringValue, @"discount_type",
//                    itemModel.latitude.stringValue, @"latitude",
//                    itemModel.longitude.stringValue, @"longitude",
//                    itemModel.category_id.stringValue, @"category_id",nil];
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:[NSString stringWithFormat:@"%d", itemModel.offer_id.intValue] forKey:@"offer_id"];
                [dic setValue:[NSString stringWithFormat:@"%d", itemModel.branch_id.intValue] forKey:@"branch_id"];
                [dic setValue:itemModel.offer_name forKey:@"offer_name"];
                [dic setValue:itemModel.discount_type.stringValue forKey:@"discount_type"];
                [dic setValue:itemModel.latitude.stringValue forKey:@"latitude"];
                [dic setValue:itemModel.longitude.stringValue forKey:@"longitude"];
                [dic setValue:itemModel.category_id.stringValue forKey:@"category_id"];
                [dic setValue:itemModel.size2 forKey:@"size2"];
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
//            self.tabBarController.tabBar.hidden = YES;
            _mapView.isRegisteredHanleTap = NO;
            [self.view addSubview:_mapView];
            [_mapView reloadInterface:[NSMutableArray arrayWithObject:item]];
            [_mapView drawRouteToItemIndex:0];
            break;
        }
            
        default:
            break;
    }
}

-(BOOL)descriptionCell:(DescriptionCell*)descriptionCell didUpdateLayoutWithHeight:(CGFloat)newHeight
{
    _heightDescription = newHeight;
    [self.tableViewDetail reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
    return YES;
}
- (void)selectMap
{
    //-------Get object to display on map view------//
//    OfferTableItem *item = nil;
//    NSArray *temp = [self.fetchedResultsController.fetchedObjects mutableCopy];
//    for (OfferDetailModel *itemModel in temp)
//    {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"http://plusoffer-dev.123phim.vn/img/temp/offer1.jpg", @"url",  [NSString stringWithFormat:@"%d", itemModel.offer_id.intValue], @"offer_id",
//                             itemModel.offer_name, @"offer_name",
//                             [NSString stringWithFormat:@"%d", itemModel.branch_id.intValue], @"branch_id",
//                             itemModel.discount_type.stringValue, @"discount_type",
//                             itemModel.latitude.stringValue, @"latitude",
//                             itemModel.longitude.stringValue, @"longitude",
//                             itemModel.category_id.stringValue, @"category_id",nil];
//        item = [[OfferTableItem alloc] initWithData:dic];
//    }
//    if (![item isKindOfClass:[OfferTableItem class]]) {
//        return;
//    }
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate toMapViewController:item withTitle:self.title isHandleAction:NO];
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

#pragma mark
#pragma mark RKManageDelegate method
- (void)processResultResponseDictionaryMapping:(DictionaryMapping *)dictionary requestId:(int)request_id
{
    if (request_id == ID_REQUEST_USER_PUNCH) {
        //process data return
        id result = [dictionary.curDictionary objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            //punch result
            id user_punch = [result objectForKey:@"user_punch"];
            [self.dataSource setUser_punch:[NSString stringWithFormat:@"%d", [user_punch integerValue]]];
            NSArray *temp = [self.fetchedResultsController fetchedObjects];
            if ([temp isKindOfClass:[NSArray class]]) {
                OfferDetailModel *detailModel = [temp objectAtIndex:0];
                [detailModel setUser_punch:[NSNumber numberWithInt:[user_punch integerValue]]];
            }
        } else {
            NSLog(@"error = %@", [dictionary.curDictionary objectForKey:@"error"]);
        }
    }
    if (request_id == ID_REQUEST_FAVORITE) {
        //process data return
        id result = [dictionary.curDictionary objectForKey:@"result"];
        NSLog(@"%@",[result class]);
        if ([result isKindOfClass:[NSNumber class]])
        {
        
            if(([result integerValue]) == 1)
            {
                [self.dataSource setIs_like:[NSString stringWithFormat:@"%d", [result integerValue]]];
                NSLog(@"Đã like");
                _btnAdd.titleLabel.text = @"Đã yêu thích";
            }
            else if (([result integerValue]) == 0)
            {
                NSLog(@"%@",self.dataSource);
                [self.dataSource setIs_like:[NSString stringWithFormat:@"%d", [result integerValue]]];
                NSLog(@"Dislike");
            }
        }
        else
        {
            NSLog(@"error = %@", [dictionary.curDictionary objectForKey:@"error"]);
        }
    }
}
- (IBAction)processActionPunch:(id)sender
{
    [self loadBarCodeReader];
}

- (IBAction)processActionAdd:(id)sender {
    if (self.dataSource.is_like.integerValue == 0 || self.dataSource.is_like == nil)
    {
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager]
     RK_RequestApiAddFavorite:self forUserID:@"1" forOfferID:_offer_id];
    }
    else if (self.dataSource.is_like.integerValue == 1)
    {
        [(PlusAPIManager*)[PlusAPIManager sharedAPIManager]
         RK_RequestApiRemoveFavorite:self forUserID:@"1" forOfferID:_offer_id];
    }
}
@end
