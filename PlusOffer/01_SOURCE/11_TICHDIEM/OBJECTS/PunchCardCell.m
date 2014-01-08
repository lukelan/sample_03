//
//  PunchCardCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/8/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//
#define MIN_CELL_CARD 75
#import "PunchCardCell.h"

@implementation PunchCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 500 )];
        _containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_containerView];
        // logo image
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 500 )];
        [_bgImageView setImage:[UIImage imageNamed:@"PunchCard.png"]];
        _bgImageView.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:_bgImageView];
        _btScroll = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 30, 30 )];
        [_btScroll addTarget:self action:@selector(mapBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_btScroll setImage:[UIImage imageNamed:@"icon-map.png"] forState:UIControlStateNormal];
        [_containerView addSubview:_btScroll];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
int test = 0;
- (void)showFullOrShortDes
{
    CGFloat h = 500;
    if (test == 0)
    {
        [self.delegate punchCardCell:self didUpdateLayoutWithHeight:h :_rowCurrent];
        test = 1;
        return;
    }
    else if  (test == 1)
    {
        [self.delegate punchCardCell:self didUpdateLayoutWithHeight:70 :_rowCurrent];
        test = 0;
    }
    
}
-(void)mapBtnTouchUpInside
{
    [self showFullOrShortDes];
}
@end
