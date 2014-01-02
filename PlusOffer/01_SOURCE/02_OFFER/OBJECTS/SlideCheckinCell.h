//
//  SlideCheckinCell.h
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/31/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSliderView.h"

@interface SlideCheckinCell : UITableViewCell
{
    __weak id<MBSliderViewDelegate> _delegate;
}
@property (nonatomic, weak) id<MBSliderViewDelegate> delegate;
@property (nonatomic, retain) MBSliderView *viewSlider;
- (void)loadContent;
@end
