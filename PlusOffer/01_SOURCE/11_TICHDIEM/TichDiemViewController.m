//
//  TichDiemViewController.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/8/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//
#define MIN_CELL_CARD 71
#import "TichDiemViewController.h"
int indexrow;
@interface TichDiemViewController ()

@end

@implementation TichDiemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
PunchCardCell *cell;
NSIndexPath *pathCurrent;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _tableView = [[UITableView alloc]  initWithFrame: CGRectMake(0, TITLE_BAR_HEIGHT, 320, self.view.frame.size.height - TAB_BAR_HEIGHT - CHECK_IOS )  style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    _tableView.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:238.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [self.view addSubview:_tableView];
    
	// Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     CGFloat ret = 0;
    if (_punchCardCellHeight < MIN_CELL_CARD)
    {
        ret = MIN_CELL_CARD;
    }
    else if (indexPath.row == _currentIndex)
    {
        ret = _punchCardCellHeight;
    
    }
    return ret;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [[PunchCardCell class] description];
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[PunchCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
           }
    [cell setDelegate:self];
    cell.rowCurrent = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell mapBtnTouchUpInside];
    
}
-(BOOL)punchCardCell:(PunchCardCell*)punchCardCell didUpdateLayoutWithHeight:(CGFloat)newHeight :(int) rowCurrent;
{
    _punchCardCellHeight = newHeight;
    _currentIndex = rowCurrent;
    self.tableView.contentOffset = CGPointMake(0, 0);

    [self reloadRow];
    return YES;
}
- (void)reloadRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
   [self.tableView endUpdates];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
