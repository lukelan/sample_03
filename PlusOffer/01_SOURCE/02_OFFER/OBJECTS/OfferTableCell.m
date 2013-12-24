//
//  OfferTableCell.m
//  PlusOffer
//
//  Created by Tai Truong on 12/24/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "OfferTableCell.h"

#define OFFERTABLE_CELL_HEIGHT 182.0f
#define OFFERTABLE_CELL_PADDING 5.0f
#define OFFERTABLE_CELL_MARGIN 10.0f
#define OFFERTABLE_CELL_BACKGROUND_HEIGHT OFFERTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING // 134.0f (set background height = cell height for testing purpose)

@implementation OfferTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // container view
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_PADDING, 320.0f - 2*OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING )];
        containerView.layer.masksToBounds = YES;
        containerView.layer.cornerRadius = 6.0f;
        [self addSubview:containerView];
        
        
        // offer image
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f - 2*OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_BACKGROUND_HEIGHT)];
        [containerView addSubview:_backgroundImage];
        
        // discount image
        _discountImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [containerView addSubview:_discountImage];
        
        // discount label
        _discountLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _discountLbl.backgroundColor = [UIColor clearColor];
        _discountLbl.font = [UIFont systemFontOfSize:16.0f];
        [containerView addSubview:_discountLbl];
        
        // distance Label
        _distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, OFFERTABLE_CELL_BACKGROUND_HEIGHT + 15.0f, 220.0f, 25.0f)];
        _distanceLbl.backgroundColor = [UIColor clearColor];
        _distanceLbl.font = [UIFont systemFontOfSize:17.0f];
        [containerView addSubview:_distanceLbl];
        
        // map button
        _mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 30, CGRectGetHeight(self.contentView.frame) - 30, 30, 30)];
        [_mapBtn addTarget:self action:@selector(mapBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:_mapBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions
-(void)mapBtnTouchUpInside
{
    
}

#pragma mark - Public Methods

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return OFFERTABLE_CELL_HEIGHT;
}


-(void)setObject:(id)object
{
    _object = object;
    
    OfferTableItem *item = object;
    [self.backgroundImage setImage:[UIImage imageNamed:item.imageUrl]];
    self.discountLbl.text = item.discount;
    self.distanceLbl.text = item.distance;
}

@end
