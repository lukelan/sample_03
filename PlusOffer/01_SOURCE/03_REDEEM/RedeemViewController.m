//
//  RedeemViewController.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "RedeemViewController.h"
#import "RedeemTableViewCell.h"
#import "ZBarReaderViewController.h"

@interface RedeemViewController () <ZBarReaderDelegate, RedeemTableViewCellDelegate>
{
    ZBarReaderViewController *zBarReader;
    BOOL isScaning;
    BOOL isScanScreen;
    NSTimer *timer;
    UIView *_overlayView;
}
@property (nonatomic, retain) NSMutableArray *dataSource;
@end

@implementation RedeemViewController

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
    [self initInterface];
	// Do any additional setup after loading the view.
    viewName = REDEEM_VIEW_NAME;
    self.trackedViewName = viewName;
    
    [self initDataForTesting];
    
    // barcode scanner
    zBarReader = [[ZBarReaderViewController alloc] init];
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    _overlayView.backgroundColor = [UIColor clearColor];
    UIImageView *overlayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
    [_overlayView addSubview:overlayImage];
    // cancel button
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 70, 25)];
//    [cancelBtn sett]
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeScanner) forControlEvents:UIControlEventTouchUpInside];
    [_overlayView addSubview:cancelBtn];
    zBarReader.cameraOverlayView = _overlayView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// for tesing purpose
-(void)initDataForTesting
{
    self.dataSource = [NSMutableArray array];
    
    // 1
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"McDonald", @"name",
                         @"01 Big Mac miễn phí cho bạn", @"detail",
                         @"0", @"distance",
                         @"redeem_logo_1", @"imageUrl",
                         nil];
    RedeemTableViewItem *item = [[RedeemTableViewItem alloc] initWithData:dic andType:enumRedeemItemType_allowRedeem];
    [self.dataSource addObject:item];
    
    // 2
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Urban Station", @"name",
                         @"01 Mocha Latte miễn phí", @"detail",
                         @"2.8km", @"distance",
                         @"redeem_logo_2", @"imageUrl",
                         nil];
    item = [[RedeemTableViewItem alloc] initWithData:dic andType:enumRedeemItemType_notAllow];
    [self.dataSource addObject:item];
    
    // 3
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Urban Station", @"name",
                         @"Giảm 20% các loại bánh", @"detail",
                         @"3.6km", @"distance",
                         @"redeem_logo_3", @"imageUrl",
                         nil];
    item = [[RedeemTableViewItem alloc] initWithData:dic andType:enumRedeemItemType_notAllow];
    [self.dataSource addObject:item];
    
    // 4
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"BHD Cineplex", @"name",
                         @"01 vé xem phim 2D miến phí", @"detail",
                         @"4.5km", @"distance",
                         @"redeem_logo_4", @"imageUrl",
                         nil];
    item = [[RedeemTableViewItem alloc] initWithData:dic andType:enumRedeemItemType_notAllow];
    [self.dataSource addObject:item];
    
    // reload table
    [self.tableView reloadData];
}

- (void)loadBarCodeReader
{
    zBarReader.showsZBarControls = NO;
    zBarReader.readerDelegate = self;

    zBarReader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
//    zBarReader.cameraOverlayView = scanOverlay;
    ZBarImageScanner *scanner = zBarReader.scanner;
    // TODO: (optional) additional reader configuration here
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

#pragma mark - Interfaces
-(void)initInterface
{
    self.tableView.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:238.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RedeemTableViewCell tableView:tableView rowHeightForObject:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [[RedeemTableViewCell class] description];
    RedeemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[RedeemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    
    [cell setObject:[self.dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - RedeemTableViewCellDelegate
-(void)redeemTableCell:(RedeemTableViewCell *)cell redeemOffer:(id)object
{
    [self loadBarCodeReader];
}
@end
