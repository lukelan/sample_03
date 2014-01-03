//
//  PlusOfferListView.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusOfferListView.h"

#define PLUSOFFER_CELL_WIDTH 320
#define PLUSOFFER_CELL_HEIGHT 172

@implementation PlusOfferListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setSeparatorColor:[UIColor clearColor]];
        [self.tableView setBackgroundView:nil];
        
        _tableView.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:238.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OfferTableCell tableView:tableView rowHeightForObject:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [[OfferTableCell class] description];
    OfferTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OfferTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setObject:[self.dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // deselecte row
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OfferDetailViewController *offerDetailViewController = [[appDelegate getCurrentViewController].storyboard instantiateViewControllerWithIdentifier:@"OfferDetailViewController"];
    [offerDetailViewController setHidesBottomBarWhenPushed:NO];
    NSLog(@"%@",[self.dataSource objectAtIndex:indexPath.row]);
    [[appDelegate getCurrentViewController].navigationController pushViewController:offerDetailViewController animated:YES];
    
    
}

@end
