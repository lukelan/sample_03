//
//  DiscountCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 12/27/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet SDImageView *imageDiscount;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewDes;
-(void)setObject:(id)object;
@end
