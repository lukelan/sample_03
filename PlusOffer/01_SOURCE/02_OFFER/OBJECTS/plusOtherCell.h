//
//  plusOtherCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/10/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface plusOtherCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIView *bottomBorder;
@property (nonatomic, strong) SDImageView *imageLogo;
@property (nonatomic, strong) SDImageView *imageArrow;
-(void) setData :(id)data :(int)indexPath;
@end
