//
//  RedeemViewController.h
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemViewController : CustomGAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pointLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
