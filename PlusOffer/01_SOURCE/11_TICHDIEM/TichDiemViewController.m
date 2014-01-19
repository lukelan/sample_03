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
#import "PunchCardDetail.h"

#define MAX_DETAIL_VIEW_HEIGHT 490.0f

@interface TichDiemViewController ()<NSFetchedResultsControllerDelegate, OpenBarcodeScannerDelegate, ZBarReaderDelegate, PunchCardCellDelegate, RKManagerDelegate,PunchCardDetailDelegate>
{
    // Scanner: top view
    UIView *_topView;
    UIImageView *_topLogo;
    UILabel *_topTextLbl;
    
    // Scanner: bottom view
    UIView *_bottomView;
    UIImageView *_bottomLogo;
    UILabel *_bottomTextLbl;
    UILabel *_bottomPointLbl;
    // Scanner: center view
    UILabel *_codeLbl;
    UILabel *_timeLbl;
    
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIView *detailView;
@property (nonatomic, retain) PunchCardDetail *puchCardDetailView;
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
    self.view.backgroundColor = [UIColor whiteColor];
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

#pragma mark - PunchCardCellDelegate
-(void)punchCardCell:(PunchCardCell *)punchCardCell didSelect:(BrandModel *)object
{
    NSInteger section = [self.dataSource indexOfObject:object];
    _selectedIndex = section;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    CGRect rectCell = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect r = [self.tableView convertRect:rectCell toView:self.view];
    
    CGRect detailRect = self.detailView.frame;
    detailRect.origin.y = r.origin.y;
    self.detailView.frame = detailRect;
    self.detailView.alpha = 0.5f;
    self.detailView.backgroundColor = [UIColor colorWithHex:object.brand_card_color alpha:1.0f];
    
    // Punch Kard detail
    if (!_puchCardDetailView) {
        _puchCardDetailView = [[PunchCardDetail alloc] initWithFrame:CGRectMake(-10,0,detailRect.size.width,MAX_DETAIL_VIEW_HEIGHT)];
        _puchCardDetailView.delegate = self;
        [_puchCardDetailView setObject:object];
        [_detailView addSubview:_puchCardDetailView];
    } else {
        [_puchCardDetailView setObject:object];
    }
    
    
    [self.view addSubview:self.detailView];
    
    // calculate expanded frame
    detailRect = CGRectMake(detailRect.origin.x, 20, detailRect.size.width, MAX_DETAIL_VIEW_HEIGHT);
    // hide table view
    [UIView animateWithDuration:1.0f animations:^{
        self.tableView.alpha = 0.0f;
        self.detailView.alpha = 1.0f;
        
        self.detailView.frame = detailRect;
    } completion:^(BOOL finished) {
        self.tableView.hidden = YES;
        
        // add close gesture
        UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDetailView)];
        [_detailView addGestureRecognizer:dismissGesture];
    }];
}

-(void)closeDetailView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_selectedIndex];
    CGRect rectCell = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect r = [self.tableView convertRect:rectCell toView:self.view];
    
    CGRect detailRect = self.detailView.frame;

    
    self.tableView.alpha = 0.0f;
    self.tableView.hidden = NO;
    
    // calculate expanded frame
    detailRect = CGRectMake(detailRect.origin.x, r.origin.y, detailRect.size.width, MIN_PUNCH_CELL_HEIGHT);
    // hide table view
    [UIView animateWithDuration:1.0f animations:^{
        self.tableView.alpha = 1.0f;
        self.detailView.alpha = 0.3f;
        
        self.detailView.frame = detailRect;
    } completion:^(BOOL finished) {
        [self.detailView removeFromSuperview];
        // reset selected index
        _selectedIndex = -1;
        // remove close gesture
        [self.detailView removeGestureRecognizer:[self.detailView.gestureRecognizers objectAtIndex:0]];
    }];
}

-(UIView *)detailView
{
    if (_detailView) {
        return _detailView;
    }
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, MIN_PUNCH_CELL_HEIGHT)];
    _detailView.layer.masksToBounds = YES;
    _detailView.layer.cornerRadius = 5.0f;
    _detailView.backgroundColor = [UIColor greenColor];
    
    return _detailView;
}

#pragma mark - PunchCardDetailDelegate
-(void)closePunchCardDetaiView:(BrandModel*)object {
    [self closeDetailView];
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

#define RADIAN(angle) (angle / 180.0f * M_PI)
#pragma mark -
#pragma mark ZBarSDK method
- (void)initBarcode
{
    zBarReader = [[ZBarReaderViewController alloc] init];
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    _overlayView.backgroundColor = [UIColor clearColor];
    UIImageView *overlayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
    CGFloat deltaY = 0.0f;
    if (CGRectGetHeight(self.view.bounds) == 568) { // 4 inches
        overlayImage.frame = CGRectMake(0, 0, CGRectGetWidth(overlayImage.frame), CGRectGetHeight(overlayImage.frame));
    }
    else { // 3.5 inches
        deltaY = -65.0f;
        overlayImage.frame = CGRectMake(0, -65, CGRectGetWidth(overlayImage.frame), CGRectGetHeight(overlayImage.frame));
    }
    [_overlayView addSubview:overlayImage];
    
    // ----------------
    // --- top view ---
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 64)];
    [self setMaskTo:_topView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    _topView.transform = CGAffineTransformMakeRotation(RADIAN(180.0f));
    [_overlayView addSubview:_topView];
    
    // logo
    _topLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    [_topView addSubview:_topLogo];
    
    // text
    _topTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 230, 60)];
    _topTextLbl.textAlignment = NSTextAlignmentCenter;
    _topTextLbl.font = [UIFont systemFontOfSize:15.0f];
    _topTextLbl.numberOfLines = 3;
    _topTextLbl.textColor = [UIColor whiteColor];
    [_topView addSubview:_topTextLbl];
    
    // cancel button
    UIButton *topCancelBtn = [[UIButton alloc] initWithFrame:_topView.bounds];
    [topCancelBtn addTarget:self action:@selector(closeScanner) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:topCancelBtn];
    
    // ----------------
    // --- bottom view ---
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, _overlayView.bounds.size.height - 64, 300, 64)];
    [self setMaskTo:_bottomView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    [_overlayView addSubview:_bottomView];
    
    // logo
    _bottomLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    [_bottomView addSubview:_bottomLogo];
    
    // text
    _bottomTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 190, 40)];
    _bottomTextLbl.textAlignment = NSTextAlignmentCenter;
    _bottomTextLbl.font = [UIFont systemFontOfSize:15.0f];
    _bottomTextLbl.numberOfLines = 2;
    _bottomTextLbl.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_bottomTextLbl];
    
    // point number
    _bottomPointLbl = [[UILabel alloc] initWithFrame:CGRectMake(260, 10, 40, 40)];
    _bottomPointLbl.textColor = [UIColor yellowColor];
    _bottomPointLbl.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    [_bottomView addSubview:_bottomPointLbl];
    
    // cancel button
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:_bottomView.bounds];
    [cancelBtn addTarget:self action:@selector(closeScanner) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cancelBtn];
    
    // ----------------
    // --- center view ---
    // code label
    _codeLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 250 + deltaY, 240, 70)];
    _codeLbl.textAlignment = NSTextAlignmentCenter;
    [_codeLbl setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:80]];
    _codeLbl.textColor = [UIColor blackColor];
    [_overlayView addSubview:_codeLbl];
    
    // time label
    _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 330 + deltaY, 240, 40)];
    _timeLbl.textAlignment = NSTextAlignmentCenter;
    [_timeLbl setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50]];
    _timeLbl.textColor = [UIColor lightGrayColor];
    [_overlayView addSubview:_timeLbl];
    
    
    
    zBarReader.cameraOverlayView = _overlayView;
}

-(void)updateScannerTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    _timeLbl.text = [formatter stringFromDate:[NSDate date]];
}

-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    CGRect rect = view.bounds;
    CGFloat radius = 7.0;
    
    CGMutablePathRef path = CGPathCreateMutable();
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1);
    
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1);
	CGPathCloseSubpath(path);
    
    //    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:path];
    
    view.layer.mask = shape;
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
    [self performSelector:@selector(scanTimeOut) withObject:nil afterDelay:60];
    
    // start timer to show time
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector: @selector(updateScannerTime)
                                           userInfo:nil
                                            repeats:YES];
    
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
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Không nhận dạng được mã, thử lại lần nữa." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
- (void)processOpenBarcodeScannerForBrand:(BrandModel *)object
{
    // config scanner info
    _topView.backgroundColor = _bottomView.backgroundColor = [UIColor colorWithHex:object.brand_card_color alpha:1.0f];
    [_topLogo setImageWithURL:[NSURL URLWithString:object.brand_card_logo]];
    [_topTextLbl setText:[NSString stringWithFormat:@"Trình mã này cho nhân viên %@ để nhận điểm tích luỹ cho đơn hàng", object.brand_name]];
    [_bottomLogo setImageWithURL:[NSURL URLWithString:object.brand_card_logo]];
    [_bottomTextLbl setText:@"Khách hàng nhận được 3 điểm tích luỹ cho đơn hàng"];
    [_bottomPointLbl setText:@"3"];
    [_codeLbl setText:@"09451"];
    
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
