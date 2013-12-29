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
#import "PlusAPIManager.h"
#import "RedeemModel.h"

@interface RedeemViewController () <ZBarReaderDelegate, RedeemTableViewCellDelegate, NSFetchedResultsControllerDelegate>
{
    ZBarReaderViewController *zBarReader;
    BOOL isScaning;
    BOOL isScanScreen;
    NSTimer *timer;
    UIView *_overlayView;
}
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
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
    
    // barcode scanner
    
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
    
    // init fetched result controller
    [self fetchedResultsController];
    
    // load default data
    self.dataSource = [self.fetchedResultsController.fetchedObjects mutableCopy];
    [self.tableView reloadData];
    
    // load list redeem item
    [self loadRedeemOffers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API
-(void)loadRedeemOffers
{
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListPlusOfferRedeem:self forUserID:@"1"];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController{
    
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([RedeemModel class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"redeem_id" ascending:YES]];
        
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
    [self reloadInterface];
}

- (void)reloadInterface
{
    NSLog(@"data = %@", self.fetchedResultsController.fetchedObjects);
    self.dataSource = [self.fetchedResultsController.fetchedObjects mutableCopy];
    [self.tableView reloadData];
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
