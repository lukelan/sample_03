//
//  titleCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/13/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//
#define OFFERTABLE_CELL_HEIGHT 50.0f
#define OFFERTABLE_CELL_PADDING 10.0f
#define OFFERTABLE_CELL_MARGIN 10.0f
#define LABEL_MARGIN 5.0f
#define OFFERTABLE_CELL_BACKGROUND_HEIGHT OFFERTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING
#import "titleCell.h"

@implementation titleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, 0 , 320.0f - 2*OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_HEIGHT)];
        //containerView.layer.masksToBounds = YES;
        //    containerView.layer.cornerRadius = 8.0f;
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_PADDING , 18 , 250, 15)];
        [_titleLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_REGULAR size:15]];
        _titleLbl.textColor = UIColorFromRGB(0x111111);
        [containerView addSubview:_titleLbl];
        _bottomBorder = [[UIView alloc]
                         initWithFrame:CGRectMake(OFFERTABLE_CELL_PADDING,containerView.frame.size.height - 1,
                                                  containerView.frame.size.width - OFFERTABLE_CELL_PADDING*2,
                                                  1.0f)];
        
        _bottomBorder.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [containerView addSubview:_bottomBorder];
        _imageArrow =  [[SDImageView alloc] initWithFrame:CGRectMake(0 , 0 , 8, 15)];
        _imageArrow.frame = CGRectMake(containerView.frame.size.width - OFFERTABLE_CELL_MARGIN - _imageArrow.frame.size.width, (containerView.frame.size.height - _imageArrow.frame.size.height)/2 , _imageArrow.frame.size.width, _imageArrow.frame.size.height);
        [_imageArrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [containerView addSubview:_imageArrow];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
