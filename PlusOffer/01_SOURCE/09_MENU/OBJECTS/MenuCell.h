//
//  MenuCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/7/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
{
    UIView *_containerView;
}
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UIImageView *imageDiscount;
@property (nonatomic, retain) UILabel *nameLbl;
@property (nonatomic, retain) UILabel *discountLbl;
@property (nonatomic, retain) UILabel *descriptionLbl;
@property (nonatomic, retain) UILabel *priceLbl;
-(void)setObject:(id)object;


@end
