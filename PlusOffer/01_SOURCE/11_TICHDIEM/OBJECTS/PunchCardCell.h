//
//  PunchCardCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/8/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//
#define MIN_PUNCH_CELL_HEIGHT 60

#import <UIKit/UIKit.h>
#import "BrandModel.h"

@class PunchCardCell;
@protocol PunchCardCellDelegate <NSObject>

@required
-(BOOL)punchCardCell:(PunchCardCell*)punchCardCell didUpdateLayoutWithHeight:(CGFloat)newHeight curIndex:(int) curIndexSelected;
@end

@interface PunchCardCell : UITableViewCell
{
    UIView *_containerView;
    CGFloat _punchCardCellHeight;
//    BOOL isExpanded;
    __weak id<OpenBarcodeScannerDelegate> _barCodeDelegate;
    __weak id<PunchCardCellDelegate> _delegate;
}
@property (nonatomic, assign) BrandModel *curBrand;
@property (nonatomic, weak) id<OpenBarcodeScannerDelegate> barCodeDelegate;
@property (weak, nonatomic) id<PunchCardCellDelegate>delegate;

@property (nonatomic, assign) int CurIndexSelected;
@property (nonatomic, retain) UIButton *btnTitle;
@property (nonatomic, retain) UIButton *btnPunch;

@property (nonatomic, retain) SDImageView *bgCardImage;
@property (nonatomic, retain) SDImageView *bgBrandLogo;
@property (nonatomic, retain) UILabel *lblDescription;
@property (nonatomic, retain) UIView *viewPunchInfo;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *lblLine;

- (void)showFullOrShortDes;
- (void)setObject:(id)object;
+ (BOOL)isExpanded;
@end
