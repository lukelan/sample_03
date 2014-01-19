//
//  PunchCardDetail.h
//  PlusOffer
//
//  Created by Trong Vu on 1/19/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"

@class PunchCardDetail;
@protocol PunchCardDetailDelegate <NSObject>

@required
-(void)processOpenBarcodeScannerForBrand:(BrandModel*)object;
-(void)closePunchCardDetaiView:(BrandModel*)object;

@end


@interface PunchCardDetail : UIView {
    UIView *_containerView;
    CGFloat _punchCardCellHeight;
}

@property (nonatomic, assign) BrandModel *curBrand;
@property (nonatomic, weak) id<OpenBarcodeScannerDelegate> barCodeDelegate;
@property (weak, nonatomic) id<PunchCardDetailDelegate>delegate;

@property (nonatomic, assign) int CurIndexSelected;
@property (nonatomic, retain) UIButton *btnTitle;
@property (nonatomic, retain) UIButton *btnPunch;

@property (nonatomic, retain) SDImageView *bgCardImage;
@property (nonatomic, retain) SDImageView *bgBrandLogo;
@property (nonatomic, retain) UILabel *lblDescription;
@property (nonatomic, retain) UIView *viewPunchInfo;
@property (nonatomic, retain) UIScrollView *scrollView;

- (void)setObject:(id)object;

@end
