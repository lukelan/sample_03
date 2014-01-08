//
//  PunchCardCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/8/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PunchCardCell;
@protocol PunchCardCellDelegate <NSObject>

@required
-(BOOL)punchCardCell:(PunchCardCell*)punchCardCell didUpdateLayoutWithHeight:(CGFloat)newHeight :(int) rowCurrent;
@end

@interface PunchCardCell : UITableViewCell
{
        UIView *_containerView;
        CGFloat _punchCardCellHeight;
    __weak id<PunchCardCellDelegate> _delegate;
    
}
- (void)showFullOrShortDes;
-(void)mapBtnTouchUpInside;
@property (nonatomic) int rowCurrent;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIButton *btScroll;
@property (weak, nonatomic) id<PunchCardCellDelegate>delegate;
@end
