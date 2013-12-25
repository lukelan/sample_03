//
//  RedeemTableViewCell.m
//  PlusOffer
//
//  Created by Tai Truong on 12/25/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "RedeemTableViewCell.h"

#define REDEEMTABLE_CELL_HEIGHT 90.0f
#define OFFERTABLE_CELL_PADDING 5.0f
#define OFFERTABLE_CELL_MARGIN 10.0f

@implementation RedeemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // shadow view
        _shadowLayer = [CALayer layer];
        _shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _shadowLayer.shouldRasterize = YES;
        _shadowLayer.shadowOffset = CGSizeMake(0.0, 0.0);
        _shadowLayer.shadowRadius = 5.0f;
        _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _shadowLayer.shadowOpacity = 0.6f;
        _shadowLayer.frame = CGRectMake(OFFERTABLE_CELL_MARGIN + 3, OFFERTABLE_CELL_PADDING + 3, 320.0f - 2*OFFERTABLE_CELL_MARGIN - 6, REDEEMTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING - 6);
        [self.layer insertSublayer:_shadowLayer atIndex:0];
        
        // container view
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_PADDING, 320.0f - 2*OFFERTABLE_CELL_MARGIN, REDEEMTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING )];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 5.0f;
        [self addSubview:_containerView];
        
        // logo image
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 75, 75)];
        _logoImageView.layer.cornerRadius = 3.0f;
        _logoImageView.layer.masksToBounds = YES;
        [_containerView addSubview:_logoImageView];
        
        // detail image
        UIImageView *detailBg = [[UIImageView alloc] initWithFrame:CGRectMake(83, 38, 128.0f, 19.0f)];
        [detailBg setImage:[UIImage imageNamed:@"redeem_detail_bg"]];
        [_containerView addSubview:detailBg];
        
        // name label
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 18, 135, 21)];
        _nameLbl.font = [UIFont boldSystemFontOfSize:12.0f];
        [_containerView addSubview:_nameLbl];
        
        // detail Label
        _descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 38, 120.0f, 20.0f)];
        _descriptionLbl.font = [UIFont systemFontOfSize:8.0f];
        [_containerView addSubview:_descriptionLbl];
        
        // redeem button
        _redeemBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 25, 60, 30)];
        [_redeemBtn addTarget:self action:@selector(redeemBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_redeemBtn];
        [self.redeemBtn setImage:[UIImage imageNamed:@"redeem_notAllowBtn_1.png"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions
-(void)redeemBtnTouchUpInside
{
    
}

#pragma mark - Public Methods

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return REDEEMTABLE_CELL_HEIGHT;
}

-(void)prepareForReuse{
    self.logoImageView.image = nil;
    self.nameLbl.text = self.descriptionLbl.text = @"";
    [self.redeemBtn setImage:[UIImage imageNamed:@"redeem_notAllowBtn_1.png"] forState:UIControlStateNormal];
}

-(void)setObject:(id)object
{
    _object = object;
    
    RedeemTableViewItem *item = object;
    [self.logoImageView setImage:[UIImage imageNamed:item.imageUrl]];
    self.nameLbl.text = item.name;
    self.descriptionLbl.text = item.redeemDetail;
    
    if (item.type == enumRedeemItemType_allowRedeem) {
        [self.redeemBtn setImage:[UIImage imageNamed:@"redeem_allowBtn"] forState:UIControlStateNormal];
    }
    else {
        [self.redeemBtn setTitle:item.distance forState:UIControlStateNormal];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_containerView.bounds];
//    _shadowLayer.shadowPath = path.CGPath;
}
@end
