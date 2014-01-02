//
//  OfferTableCell.h
//  PlusOffer
//
//  Created by Trongvm on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferTableItem.h"

@interface OfferTableCell : UITableViewCell

@property (nonatomic, weak) id object;
@property (nonatomic, retain) SDImageView *backgroundImage;
@property (nonatomic, retain) SDImageView *discountImage;
@property (nonatomic, retain) SDImageView *logoImage;
@property (nonatomic, strong) UIView *locationView;
@property (nonatomic, retain) UILabel *discountLbl;
@property (nonatomic, retain) UILabel *distanceLbl;
@property (nonatomic, retain) UILabel *offerName;
@property (nonatomic, retain) UIButton *mapBtn;
@property (nonatomic, strong) SDImageView * sdImageView;
+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;

@end
