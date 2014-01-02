//
//  SliderView.h
//  Slider
//
//  Created by Mathieu Bolard on 02/02/12.
//  Copyright (c) 2012 Streettours. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBSliderLabel;
@protocol MBSliderViewDelegate;

@interface MBSliderView : UIView {
    UISlider *_slider;
    MBSliderLabel *_label;
    UIImageView *_imageViewBG;
    __weak id<MBSliderViewDelegate> _delegate;
    BOOL _sliding;
}

@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) UIColor *labelColor;
@property (nonatomic, weak) id<MBSliderViewDelegate> delegate;
@property (nonatomic) BOOL enabled;

- (void) setThumbColor:(UIColor *)color;
- (void) setThumbImage:(UIImage *)image;
- (void) setBackgroundImage:(UIImage *)image;

@end

@protocol MBSliderViewDelegate <NSObject>

- (void) sliderDidSlide:(MBSliderView *)slideView;

@end



@interface MBSliderLabel : UILabel {
    NSTimer *animationTimer;
    CGFloat gradientLocations[3];
    int animationTimerCount;
    BOOL _animated;
}

@property (nonatomic, assign, getter = isAnimated) BOOL animated;

@end