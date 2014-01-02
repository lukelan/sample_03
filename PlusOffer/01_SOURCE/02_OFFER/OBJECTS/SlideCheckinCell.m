//
//  SlideCheckinCell.m
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/31/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "SlideCheckinCell.h"


@implementation SlideCheckinCell
@synthesize viewSlider = _viewSlider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadContent
{
    if (!_viewSlider) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGRect frame = self.contentView.frame;
        frame.origin.y = 3;
        frame.origin.x = 1;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            frame.size.width = self.frame.size.width - 2*MARGIN_CELLX_GROUP - 2*frame.origin.x;
        }
        _viewSlider = [[MBSliderView alloc] initWithFrame:frame];
        [_viewSlider setBackgroundColor:[UIColor clearColor]];
        if (_delegate) {
            [_viewSlider setDelegate:_delegate];
        }
        [_viewSlider setText:@"Slide to Check-in"];
        [_viewSlider setLabelColor:[UIColor blackColor]];
        [_viewSlider setThumbImage:[UIImage imageNamed:@"slide-to-check-in.png"]];
//        [_viewSlider setThumbColor:[UIColor colorWithRed:28.0/255.0 green:190.0/255.0 blue:28.0/255.0 alpha:1.0]];
        [self.contentView addSubview:_viewSlider];
    }
}
@end
