//
//  OfferTableCell.m
//  PlusOffer
//
//  Created by Trongvm on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "OfferTableCell.h"

#define OFFERTABLE_CELL_HEIGHT 100.0f
#define OFFERTABLE_CELL_PADDING 5.0f
#define OFFERTABLE_CELL_MARGIN 10.0f
#define LABEL_MARGIN 5.0f
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
    //    containerView.layer.cornerRadius = 8.0f;
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];
        _shadowLayer = [CALayer layer];
        _shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _shadowLayer.shouldRasterize = YES;
        _shadowLayer.shadowOffset = CGSizeMake(0.0, 0.0);
      //  _shadowLayer.shadowRadius = 5.0f;
        _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _shadowLayer.shadowOpacity = 0.1f;
        _shadowLayer.frame = CGRectMake(10  , OFFERTABLE_CELL_PADDING,  320.0f - 2*OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING );
        [self.layer insertSublayer:_shadowLayer atIndex:0];
        // offer image
//        _backgroundImage = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f - 2*OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_BACKGROUND_HEIGHT)];
//        [containerView addSubview:_backgroundImage];
        
        // discount image

        // logo image
        _logoImage = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        _logoImage.frame = CGRectMake(0, 0 , _logoImage.frame.size.width, containerView.frame.size.height);
         [containerView addSubview:_logoImage];
        _discountImage = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_logoImage addSubview:_discountImage];
        // discount label
        _discountLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        _discountLbl.frame = CGRectMake(0, 0 , _discountLbl.frame.size.width, _discountLbl.frame.size.height);
        _discountLbl.backgroundColor = [UIColor clearColor];
        _discountLbl.font = [UIFont systemFontOfSize:16.0f];
        _discountLbl.transform = CGAffineTransformMakeRotation (-DEGREES_TO_RADIANS(45));
        _discountLbl.textAlignment = NSTextAlignmentCenter;
            [_discountLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:8]];
       _discountLbl.textColor = UIColorFromRGB(0x333333);
       [_discountImage addSubview:_discountLbl];
        
        // location View
//       _locationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, 40)];
//        _locationView.frame = CGRectMake(0 , containerView.frame.size
//                                         .height - _locationView.frame.size.height , _locationView.frame.size.width, _locationView.frame.size.height);
//        _locationView.backgroundColor = [UIColor blackColor];
//        _locationView.layer.opacity = 0.7f;
//        
//         [containerView addSubview:_locationView];
        // offerName label
         _offerBranchNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200.0f, 16)];
        _offerBranchNameLbl.frame = CGRectMake(_logoImage.frame.size.width + MARGIN_CELLX_GROUP , MARGIN_CELLX_GROUP , _offerBranchNameLbl.frame.size.width, _offerBranchNameLbl.frame.size.height);
           [_offerBranchNameLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:15]];
           [containerView addSubview:_offerBranchNameLbl];
        _offerBranchNameLbl.textColor = UIColorFromRGB(0x111111);
       // offerContent label
        _offerName = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200.0f, 15)];
        _offerName.frame = CGRectMake(_logoImage.frame.size.width + MARGIN_CELLX_GROUP , _offerBranchNameLbl.frame.origin.y + _offerBranchNameLbl.frame.size.height + 2, _offerName.frame.size.width, _offerName.frame.size.height);
        _offerName.lineBreakMode = 2;
        [_offerName setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _offerName.textColor = UIColorFromRGB(0x777777);
        [containerView addSubview:_offerName];
        _titleDeadLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 65.0f, 15)];
        _titleDeadLine.frame = CGRectMake(_logoImage.frame.size.width + MARGIN_CELLX_GROUP , containerView.frame.size.height - LABEL_MARGIN - _titleDeadLine.frame.size.height * 2 , _titleDeadLine.frame.size.width, _titleDeadLine.frame.size.height);
        [_titleDeadLine setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titleDeadLine.textColor = UIColorFromRGB(0x777777);
        [containerView addSubview:_titleDeadLine];
        // deadLine Label
        _deadLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65.0f, 14)];
        _deadLine.backgroundColor = [UIColor clearColor];
        [_deadLine setFont:[UIFont fontWithName: FONT_ROBOTOCONDENSED_REGULAR size:12]];
        _deadLine.frame = CGRectMake(_logoImage.frame.size.width + MARGIN_CELLX_GROUP , _titleDeadLine.frame.size.height + _titleDeadLine.frame.origin.y , _deadLine.frame.size.width, _deadLine.frame.size.height);
        [containerView addSubview:_deadLine];
         // title PunchLbl label
        _titlePunchLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 65.0f, 15)];
        _titlePunchLbl.frame = CGRectMake(_titleDeadLine.frame.origin.x + _titleDeadLine.frame.size.width, containerView.frame.size.height - LABEL_MARGIN - _titleDeadLine.frame.size.height * 2 , _titlePunchLbl.frame.size.width, _titlePunchLbl.frame.size.height);
        [_titlePunchLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titlePunchLbl.text = @"Tích lũy";
        _titlePunchLbl.textColor = UIColorFromRGB(0x777777);
        [containerView addSubview:_titlePunchLbl];
        // punch label
        _punchLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65.0f, 14)];
        _punchLbl.backgroundColor = [UIColor clearColor];
        [_punchLbl setFont:[UIFont fontWithName: FONT_ROBOTOCONDENSED_REGULAR size:12]];
        _punchLbl.frame = CGRectMake(_titleDeadLine.frame.origin.x + _titleDeadLine.frame.size.width , _titlePunchLbl.frame.size.height + _titlePunchLbl.frame.origin.y , _punchLbl.frame.size.width, _punchLbl.frame.size.height);
        [containerView addSubview:_punchLbl];
        // title Distancel
        _titleDistanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 65.0f, 15)];
        _titleDistanceLbl.frame = CGRectMake(_titlePunchLbl.frame.origin.x + _titlePunchLbl.frame.size.width , containerView.frame.size.height - LABEL_MARGIN - _titleDeadLine.frame.size.height * 2 , _titleDistanceLbl.frame.size.width, _titleDistanceLbl.frame.size.height);
        [_titleDistanceLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titleDistanceLbl.text = @"Khoảng cách";
        _titleDistanceLbl.textColor = UIColorFromRGB(0x777777);
        [containerView addSubview:_titleDistanceLbl];
        //
        _distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65.0f, 14)];
        _distanceLbl.backgroundColor = [UIColor clearColor];
        [_distanceLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_REGULAR size:12]];
        _distanceLbl.frame = CGRectMake(_titlePunchLbl.frame.origin.x + _titlePunchLbl.frame.size.width , _titleDistanceLbl.frame.size.height + _titlePunchLbl.frame.origin.y, _distanceLbl.frame.size.width, _distanceLbl.frame.size.height);
        [containerView addSubview:_distanceLbl];
        // map button
        _mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 30, CGRectGetHeight(self.contentView.frame) - 30, 40, 40)];
        [_mapBtn addTarget:self action:@selector(mapBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        _mapBtn.frame = CGRectMake(_titleDistanceLbl.frame.origin.x , _titleDistanceLbl.frame.origin.y , _titleDistanceLbl.frame.size.width + _distanceLbl.frame.size.width,_titleDistanceLbl.frame.size.height + _distanceLbl.frame.size.height);
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
    OfferTableItem *item = _object;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate toMapViewController:_object withTitle:item.branch_name isHandleAction:YES];
}

#pragma mark - Public Methods

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return OFFERTABLE_CELL_HEIGHT;
}


-(void)setObject:(id)object
{
  //  _object = object;
    OfferTableItem *item = object;
    _distanceLbl.text = item.distance;
    _punchLbl.text = [NSString stringWithFormat:@"%d/%d", item.user_punch.intValue, item.max_punch.integerValue];
    [_logoImage setImageWithURL:[NSURL URLWithString:item.size2]];
    _offerName.text = item.offer_name;
    _offerBranchNameLbl.text = item.brand_name;
    
    _deadLine.textColor = UIColorFromRGB(0x111111);
    // Process Date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:item.offer_date_end];
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:currDate
                                                 toDate:date
                                                options:0];
    if (components.day < 1)
    {
        _titleDeadLine.text = @"Còn lại";
        _deadLine.textColor = [UIColor redColor];
        _deadLine.text = [NSString stringWithFormat:@"%dh %dm",components.hour,components.minute];
        if (components.hour < 0 && components.minute < 0)
        {
            _titleDeadLine.text = @"Còn lại";
            _deadLine.textColor = UIColorFromRGB(0x333333);
            _deadLine.text = @"Đã hết hạn";
        }
    }
    else if (components.day >= 1)
    {
        _titleDeadLine.text = @"Còn lại";
        _deadLine.text = [NSString stringWithFormat:@"%d ngày",components.day];
        
    }
    else
    {
        _titleDeadLine.text = @"Còn lại";
        _deadLine.text = @"N/A";
        
    }
    // Process distance
    if (item.distance.intValue > 200000)
    {
         self.distanceLbl.text = @"N/A";
    }
    
    // discount_type
//    if (item.discount_type.intValue == ENUM_DISCOUNT || item.discount_type.intValue == ENUM_VALUE)
//    {
//         [_discountImage setImage:[UIImage imageNamed:@"ribbon-promotion-silver.png"]];
//        NSString *stringFormat = @"%";
//        self.discountLbl.text = [NSString stringWithFormat:@"OFF %@%@"
//                                 ,item.discount, stringFormat];
//    }
//    else if (item.discount_type.intValue == ENUM_GIFT)
//    {
//          [_discountImage setImage:[UIImage imageNamed:@"ribbon-promotion-green.png"]];
//        self.discountLbl.text = [NSString stringWithFormat:@"%@ quà tặng"
//                                 ,item.discount];
//    }
//    else if (item.discount_type.intValue == ENUM_GIFT_TICKET)
//    {
//        [_discountImage setImage:[UIImage imageNamed:@"ribbon-promotion-red.png"]];
//        self.discountLbl.text = [NSString stringWithFormat:@"Tặng %@ vé"
//                                 ,item.discount];
//    }
    // brand_id
    
//    if (item.brand_id.intValue == ENUM_MCDONALDS)
//    {
//        [_backgroundImage setImage:[UIImage imageNamed:@"img-loc-mcdonalds.jpg"]];
//        [_logoImage setImage:[UIImage imageNamed:@"brand-logo-mcdonalds.png"]];
//    }
//    else if (item.brand_id.intValue == ENUM_URBAN_STATION)
//    {
//        [_backgroundImage setImage:[UIImage imageNamed:@"img-loc-urban-station.jpg"]];
//        [_logoImage setImage:[UIImage imageNamed:@"brand-logo-urban-station.png"]];
//    }
//    else if (item.brand_id.intValue == ENUM_BHD)
//    {
//        [_backgroundImage setImage:[UIImage imageNamed:@"img-loc-bhd.jpg"]];
//        [_logoImage setImage:[UIImage imageNamed:@"brand-logo-bhd.png"]];
//    }
//    _offerBranchNameLbl.text = item.offer_name;
//    if (item.allowRedeem.intValue == ENUM_DISTANCE)
//    {
//        [_mapBtn setImage:[UIImage imageNamed:@"icon-map.png"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_mapBtn setImage:[UIImage imageNamed:@"icon-enter.png"] forState:UIControlStateNormal];
//    }
}

@end
