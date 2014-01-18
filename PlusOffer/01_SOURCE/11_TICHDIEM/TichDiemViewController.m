		//
//  TichDiemViewController.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/8/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//
#import "TichDiemViewController.h"
#import "BrandModel.h"
#import "PunchCardCell.h"

@interface TichDiemViewController ()<NSFetchedResultsControllerDelegate, OpenBarcodeScannerDelegate, ZBarReaderDelegate, PunchCardCellDelegate, RKManagerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TichDiemViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize dataSource = _dataSource;

#pragma mark
#pragma mark fetchResultsControllerDelegate
- (NSFetchedResultsController *)fetchedResultsController{
    
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BrandModel class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order_id" ascending:YES]];
        
        NSFetchedResultsController *myFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:@"brand"];
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
    [self reloadData];
}

- (void)reloadData
{
    [NSFetchedResultsController deleteCacheWithName:@"brand"];
    self.dataSource = [NSMutableArray arrayWithArray:[[self fetchedResultsController] fetchedObjects]];
    [_tableView reloadData];
}

#pragma mark -
- (void)dealloc
{
    [NSFetchedResultsController deleteCacheWithName:@"brand"];
    _fetchedResultsController = nil;
    _dataSource = nil;
    _tableView = nil;
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
    [self initBarcode];
    
    _tableView = [[UITableView alloc]  initWithFrame: CGRectMake(0, 0, 320, self.view.frame.size.height)  style:UITableViewStyleGrouped];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    [self.view addSubview:_tableView];
    [self reloadData];
    [((PlusAPIManager *)[PlusAPIManager sharedAPIManager]) RK_RequestAPIGetListBrandContext:nil];
	// Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    //    [self.navigationController setNavigationBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark -
#pragma mark TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIFont *font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12];
        CGSize size = [@"ABC" sizeWithFont:font];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 4*size.height)];
        UILabel *lblTitle = [[UILabel alloc] init];
        [lblTitle setFrame:CGRectMake(0, size.height, view.frame.size.width, 2*size.height)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setTextColor:UIColorFromRGB(0x666666)];
        if (IOS_VERSION >= 7.0) {
            [lblTitle setTextAlignment:NSTextAlignmentCenter];
            [lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
        } else {
            [lblTitle setTextAlignment:UITextAlignmentCenter];
            [lblTitle setLineBreakMode:UILineBreakModeWordWrap];
        }
        [lblTitle setFont:font];
        [lblTitle setNumberOfLines:2];
        [lblTitle setText:@"Hệ thống tích luỹ điểm Plus Ofer là sự thay thế hoàn hảo cho các thẻ tích điểm vật lý mà bạn phải mang theo"];
        [view addSubview:lblTitle];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     CGFloat ret = MIN_PUNCH_CELL_HEIGHT;
    if (indexPath.section == _currentIndex && _punchCardCellHeight > 0)
    {
        ret = _punchCardCellHeight;
    }
    return ret;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [[PunchCardCell class] description];
    PunchCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[PunchCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setClipsToBounds:YES];
        [cell setDelegate:self];
        [cell setBarCodeDelegate:self];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [cell setCurIndexSelected:indexPath.section];
    [cell setObject:[self.dataSource objectAtIndex:indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIFont *font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12];
        CGSize size = [@"ABC" sizeWithFont:font];
        return (4*size.height);
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([PunchCardCell isExpanded]) {
        if (_currentIndex > 0 && section == _currentIndex - 1)
        {
            if (_currentIndex - 1 >= 0 || _currentIndex + 1 < self.dataSource.count) {
                return 2*MARGIN_CELLX_GROUP;
            }
        }
    }
    if (section == (self.dataSource.count - 1))
    {
        return MARGIN_CELLX_GROUP + TAB_BAR_HEIGHT;
    }
    return MARGIN_CELLX_GROUP;
}
#pragma mark - UITableViewDelegate
-(BOOL)punchCardCell:(PunchCardCell*)punchCardCell didUpdateLayoutWithHeight:(CGFloat)newHeight curIndex:(int)curIndexSelected
{
    BOOL is_scroll_Default = NO;
    if (_punchCardCellHeight > newHeight)
    {
        is_scroll_Default = YES;
    }
    _punchCardCellHeight = newHeight;
    _currentIndex = curIndexSelected;

    CGFloat offset_statusBar_y = ([UIApplication sharedApplication].statusBarHidden ? 0 : -TITLE_BAR_HEIGHT);
    [UIView animateWithDuration:0.1 animations:^{
        if (is_scroll_Default) {
            self.tableView.contentOffset = CGPointMake(0,0);
        } else {
            UIFont *font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12];
            CGSize size = [@"ABC" sizeWithFont:font];
            CGFloat offset_y = [self tableView:self.tableView heightForHeaderInSection:0];
            if (curIndexSelected > 0)
            {
                offset_y += MARGIN_CELLX_GROUP;
                for (int i = 0; i < curIndexSelected; i++) {
                    offset_y += MARGIN_CELLX_GROUP + [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]] + 1;
                }
                self.tableView.contentOffset = CGPointMake(0, offset_y + offset_statusBar_y);
            }
            else
            {
                self.tableView.contentOffset = CGPointMake(0, 4*size.height + offset_statusBar_y);
            }
        }
    } completion:^(BOOL finished) {
        [self reloadRow];
    }];
    [self.tableView setScrollEnabled:is_scroll_Default];
    return YES;
}

- (void)reloadRow
{
    //Duyln rem here to prevent create new cell although it exists
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_currentIndex];
//    [self.tableView beginUpdates];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:_currentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ZBarSDK method
- (void)initBarcode
{
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
}

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

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    [self closeScanner];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *brand_id = [NSString stringWithFormat:@"%d",[(BrandModel *)[self.dataSource objectAtIndex:_currentIndex] brand_id].intValue];
    [(PlusAPIManager *)[PlusAPIManager sharedAPIManager] RK_RequestPunchUser:@"1" atBrand:brand_id withCode:symbol.data numberOfPunch:[NSNumber numberWithInt:delegate.punch_item_count] context:self];
}

#pragma mark -
#pragma mark OpenBarcodeSannerDelegate
- (void)processOpenBarcodeScanner
{
    [self loadBarCodeReader];
}

#pragma mark
#pragma mark RKManageDelegate method
- (void)processResultResponseDictionaryMapping:(DictionaryMapping *)dictionary requestId:(int)request_id
{
    if (request_id == ID_REQUEST_USER_PUNCH) {
        //process data return
//        NSLog(@"----dictionary = %@", dictionary.curDictionary);
        id result = [dictionary.curDictionary objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            //punch result
            id user_punch = [result objectForKey:@"user_punch"];
            BrandModel *temp = [self.dataSource objectAtIndex:_currentIndex];
            [temp setUser_punch:[NSNumber numberWithInt:[user_punch integerValue]]];
        } else {
            NSLog(@"error = %@", [dictionary.curDictionary objectForKey:@"error"]);
        }
    }
}
@end
