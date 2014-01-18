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
//@property (nonatomic, retain) UILabel *distanceLbl;
@property (nonatomic, strong) id object;
@property (nonatomic, retain) SDImageView *backgroundImage;
@property (nonatomic, retain) SDImageView *discountImage;
@property (nonatomic, retain) SDImageView *logoImage;
@property (nonatomic, strong) UIView *locationView;
@property (nonatomic, retain) UILabel *discountLbl;
@property (nonatomic, retain) UILabel *deadLine;
@property (nonatomic, retain) UILabel *titleDeadLine;
@property (nonatomic, retain) UILabel *offerBranchNameLbl;
@property (nonatomic, retain) UILabel *offerName;
@property (nonatomic, retain) UILabel *punchLbl;
@property (nonatomic, retain) UILabel *titlePunchLbl;
@property (nonatomic, retain) UILabel *distanceLbl;
@property (nonatomic, retain) UILabel *titleDistanceLbl;
@property (nonatomic, retain) UIButton *mapBtn;
@property (nonatomic, strong) SDImageView * sdImageView;
 @property (nonatomic, retain)   CALayer *shadowLayer;

+(CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;

@end
