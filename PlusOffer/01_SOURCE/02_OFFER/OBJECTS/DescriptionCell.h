//
//  DescriptionCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/14/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DescriptionCell;
@protocol DescriptionDelegate <NSObject>

@required
-(BOOL)descriptionCell:(DescriptionCell*)descriptionCell didUpdateLayoutWithHeight:(CGFloat)newHeight;
@end
@interface DescriptionCell : UITableViewCell
{
    __weak id<DescriptionDelegate> _delegate;
}
@property (weak, nonatomic) id<DescriptionDelegate>delegate;
@property (strong, nonatomic)  UIView *containerView;
@property (strong, nonatomic) CALayer *shadowLayer;
@property (strong, nonatomic) UILabel *descriptionLbl;
@property (assign, nonatomic) float cellHeight;
-(void)setDataDescription : (id)object
;

+ (float)getHeightForCellWithData:(id)object;
@end
