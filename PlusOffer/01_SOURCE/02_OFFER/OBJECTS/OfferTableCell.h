//
//  OfferTableCell.h
//  PlusOffer
//
//  Created by Tai Truong on 12/24/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferTableItem.h"

@interface OfferTableCell : UITableViewCell

@property (nonatomic, weak) id object;

@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) UIImageView *discountImage;
@property (nonatomic, retain) UILabel *discountLbl;
@property (nonatomic, retain) UILabel *distanceLbl;
@property (nonatomic, retain) UIButton *mapBtn;

+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;

@end
