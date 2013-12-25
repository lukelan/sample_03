//
//  RedeemViewController.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "RedeemViewController.h"
#import "RedeemTableViewCell.h"

@interface RedeemViewController ()
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
    }
    
    [cell setObject:[self.dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // deselecte row
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
