//
//  PlusOfferListView.h
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferTableCell.h"
#import "OfferDetailViewController.h"
@protocol PlusOfferListViewDelegate <NSObject>


@end

@interface PlusOfferListView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<PlusOfferListViewDelegate> delegate;
@property (nonatomic, weak) NSMutableArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@end
