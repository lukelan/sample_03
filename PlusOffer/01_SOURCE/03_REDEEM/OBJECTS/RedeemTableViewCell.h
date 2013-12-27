//
//  RedeemTableViewCell.h
//  PlusOffer
//
//  Created by Trongvm on 12/25/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedeemTableViewItem.h"

@interface RedeemTableViewCell : UITableViewCell
{
    UIView *_containerView;
    CALayer *_shadowLayer;
}
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UILabel *nameLbl;
@property (nonatomic, retain) UILabel *descriptionLbl;
@property (nonatomic, retain) UIButton *redeemBtn;

@property (nonatomic, weak) id object;

+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;
@end
