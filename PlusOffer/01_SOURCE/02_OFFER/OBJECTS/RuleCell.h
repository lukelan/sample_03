//
//  RuleCell.h
//  PlusOffer
//
//  Created by Le Ngoc Duy on 1/6/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewDes;
-(void)setObject:(id)object;
+ (CGFloat)getHeight:(id)object;
@end
