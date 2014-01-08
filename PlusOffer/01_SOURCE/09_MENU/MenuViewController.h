//
//  MenuViewController.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/7/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCell.h"
@interface MenuViewController : CustomGAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
