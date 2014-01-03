//
//  OfferTableCell.m
//  PlusOffer
//
//  Created by Trongvm on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "OfferTableCell.h"

#define OFFERTABLE_CELL_HEIGHT 160.0f
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
        containerView.layer.cornerRadius = 8.0f;
        [self addSubview:containerView];
        // offer image
        _backgroundImage = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f - 2*OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_BACKGROUND_HEIGHT)];
        [containerView addSubview:_backgroundImage];
        
        // discount image
        _discountImage = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [containerView addSubview:_discountImage];
        // logo image
        _logoImage = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _logoImage.frame = CGRectMake(containerView.frame.size.width - _logoImage.frame.size.width, 0 , _logoImage.frame.size.width, _logoImage.frame.size.height);
         [containerView addSubview:_logoImage];
        // discount label
        _discountLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _discountLbl.frame = CGRectMake(0, 0 , _discountLbl.frame.size.width, _discountLbl.frame.size.height);
        _discountLbl.backgroundColor = [UIColor clearColor];
        _discountLbl.textColor = [ UIColor blueColor];
        _discountLbl.font = [UIFont systemFontOfSize:16.0f];
        _discountLbl.transform = CGAffineTransformMakeRotation (-DEGREES_TO_RADIANS(45));
        _discountLbl.textAlignment = NSTextAlignmentCenter;
            [_discountLbl setFont:[UIFont fontWithName:@"Avenir Next" size:8]];
        _discountLbl.textColor = UIColorFromRGB(0x333333);

        [_discountImage addSubview:_discountLbl];
        
        // location View
       _locationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, 40)];
        _locationView.frame = CGRectMake(0 , containerView.frame.size
                                         .height - _locationView.frame.size.height , _locationView.frame.size.width, _locationView.frame.size.height);
        _locationView.backgroundColor = [UIColor blackColor];
        _locationView.layer.opacity = 0.7f;
        
         [containerView addSubview:_locationView];
        
        // offerName label
         _offerName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220.0f, 12)];
         _offerName.backgroundColor = [UIColor clearColor];
         _offerName.textColor = [UIColor whiteColor];
        _offerName.frame = CGRectMake(10, (_locationView.frame.size.height - _offerName.frame.size.height * 2) / 2, _offerName.frame.size.width, _offerName.frame.size.height);
            [_offerName setFont:[UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:13]];
           [_locationView addSubview:_offerName];
        
        // distance Label
        _distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220.0f, 12)];
        _distanceLbl.backgroundColor = [UIColor clearColor];
        [_distanceLbl setFont:[UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:10]];
        _distanceLbl.textColor = [UIColor whiteColor];
        _distanceLbl.frame = CGRectMake(10, _offerName.frame.size.height + _offerName.frame.origin.x, _distanceLbl.frame.size.width, _distanceLbl.frame.size.height);
        [_locationView addSubview:_distanceLbl];
        
        // map button
        _mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 30, CGRectGetHeight(self.contentView.frame) - 30, 40, 40)];
        [_mapBtn addTarget:self action:@selector(mapBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        _mapBtn.frame = CGRectMake(_locationView.frame.size.width - _mapBtn.frame.size.width, containerView.frame.size.height - _locationView.frame.size.height , _mapBtn.frame.size.width, _mapBtn.frame.size.height);
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
    NSLog(@"ok");
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
    self.distanceLbl.text = item.distance;
    // discount_type
    if (item.discount_type.intValue == ENUM_DISCOUNT || item.discount_type.intValue == ENUM_VALUE)
    {
         [_discountImage setImage:[UIImage imageNamed:@"ribbon-promotion-silver.png"]];
        NSString *stringFormat = @"%";
        self.discountLbl.text = [NSString stringWithFormat:@"OFF %@%@"
                                 ,item.discount, stringFormat];
    }
    else if (item.discount_type.intValue == ENUM_GIFT)
    {
          [_discountImage setImage:[UIImage imageNamed:@"ribbon-promotion-green.png"]];
        self.discountLbl.text = [NSString stringWithFormat:@"%@ quà tặng"
                                 ,item.discount];
    }
    else if (item.discount_type.intValue == ENUM_GIFT_TICKET)
    {
        [_discountImage setImage:[UIImage imageNamed:@"ribbon-promotion-red.png"]];
        self.discountLbl.text = [NSString stringWithFormat:@"Tặng %@ vé"
                                 ,item.discount];
    }
    // brand_id
    if (item.brand_id.intValue == ENUM_MCDONALDS)
    {
        [_backgroundImage setImage:[UIImage imageNamed:@"img-loc-mcdonalds.jpg"]];
        [_logoImage setImage:[UIImage imageNamed:@"brand-logo-mcdonalds.png"]];
    }
    else if (item.brand_id.intValue == ENUM_URBAN_STATION)
    {
        [_backgroundImage setImage:[UIImage imageNamed:@"img-loc-urban-station.jpg"]];
        [_logoImage setImage:[UIImage imageNamed:@"brand-logo-urban-station.png"]];
    }
    else if (item.brand_id.intValue == ENUM_BHD)
    {
        [_backgroundImage setImage:[UIImage imageNamed:@"img-loc-bhd.jpg"]];
        [_logoImage setImage:[UIImage imageNamed:@"brand-logo-bhd.png"]];
    }
    _offerName.text = item.offer_name;
    if (item.allowRedeem.intValue == ENUM_DISTANCE)
    {
        [_mapBtn setImage:[UIImage imageNamed:@"icon-map.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_mapBtn setImage:[UIImage imageNamed:@"icon-enter.png"] forState:UIControlStateNormal];
    }
}

@end
