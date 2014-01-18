//
//  InfoPlusOfferCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 12/27/13.
//  Copyright (c) 2013 Trong Vu. All rights reserved.
//

#import "InfoPlusOfferCell.h"
#import "OfferDetailItem.h"
#define OFFERTABLE_CELL_HEIGHT 350.0f
#define OFFERTABLE_CELL_PADDING 5.0f
#define OFFERTABLE_CELL_MARGIN 10.0f
#define LABEL_MARGIN 5.0f
#define OFFERTABLE_CELL_BACKGROUND_HEIGHT OFFERTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING
@implementation InfoPlusOfferCell
{
    OfferDetailItem *item;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // container view
        
        self.containerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 320.0f, OFFERTABLE_CELL_HEIGHT)];
        self.containerView.layer.masksToBounds = YES;
        //    containerView.layer.cornerRadius = 8.0f;
        self.containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
        self.imageInfoPlus = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0 , 320.0f, 320.0f )];
        self.imageInfoPlus.backgroundColor = [UIColor clearColor];
        [self.containerView addSubview:self.imageInfoPlus];
        
        self.containerViewInfo = [[UIView alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_HEIGHT - 120 , 320.0f - 2*OFFERTABLE_CELL_MARGIN, 110)];
        self.containerViewInfo.layer.masksToBounds = YES;
        //    containerView.layer.cornerRadius = 8.0f;
        self.containerViewInfo.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.containerViewInfo];
        
        _shadowLayer = [CALayer layer];
        _shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _shadowLayer.shouldRasterize = YES;
        _shadowLayer.shadowOffset = CGSizeMake(0.0, 0.0);
        //  _shadowLayer.shadowRadius = 5.0f;
        _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _shadowLayer.shadowOpacity = 0.4f;
        _shadowLayer.frame = _containerViewInfo.frame;
        [self.layer insertSublayer:_shadowLayer atIndex:0];
        
        self.branchNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_PADDING , 250, 17)];
         [_branchNameLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:15]];
        _branchNameLbl.textColor = UIColorFromRGB(0x111111);
        [self.containerViewInfo addSubview:_branchNameLbl];
        
        self.offerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_PADDING + _branchNameLbl.frame.size.height , 250, 16)];
        [_offerNameLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:14]];
        _offerNameLbl.textColor = UIColorFromRGB(0x777777);
        [self.containerViewInfo addSubview:_offerNameLbl];
        
        _titleDeadLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60.0f, 17)];
        _titleDeadLine.frame = CGRectMake(MARGIN_CELLX_GROUP , 50 , _titleDeadLine.frame.size.width, _titleDeadLine.frame.size.height);
        [_titleDeadLine setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titleDeadLine.text = @"Kết thúc";
        _titleDeadLine.textColor = UIColorFromRGB(0x777777);
        [_containerViewInfo addSubview:_titleDeadLine];
        // deadLine Label
        _deadLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 14)];
        _deadLine.backgroundColor = [UIColor clearColor];
        [_deadLine setFont:[UIFont fontWithName: FONT_ROBOTOCONDENSED_REGULAR size:12]];
        _deadLine.frame = CGRectMake(MARGIN_CELLX_GROUP , _titleDeadLine.frame.size.height + _titleDeadLine.frame.origin.y , _deadLine.frame.size.width, _deadLine.frame.size.height);
        _deadLine.text = @"19.1";
        [_containerViewInfo addSubview:_deadLine];
        // title PunchLbl label
        _titlePunchLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60.0f, 15)];
        _titlePunchLbl.frame = CGRectMake((_containerViewInfo.frame.size.width - _titlePunchLbl.frame.size.width)/ 2 , 50 , _titlePunchLbl.frame.size.width, _titlePunchLbl.frame.size.height);
        [_titlePunchLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titlePunchLbl.text = @"Tích luỹ";
        _titlePunchLbl.textAlignment = UITextAlignmentCenter;
        _titlePunchLbl.textColor = UIColorFromRGB(0x777777);
        [_containerViewInfo addSubview:_titlePunchLbl];
        // punch label
        _punchLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 14)];
        _punchLbl.backgroundColor = [UIColor clearColor];
        [_punchLbl setFont:[UIFont fontWithName: FONT_ROBOTOCONDENSED_REGULAR size:12]];
        _punchLbl.frame = CGRectMake(_titlePunchLbl.frame.origin.x , _titlePunchLbl.frame.size.height + _titlePunchLbl.frame.origin.y , _punchLbl.frame.size.width, _punchLbl.frame.size.height);
        _punchLbl.textAlignment = UITextAlignmentCenter;
        [_containerViewInfo addSubview:_punchLbl];
        // title kind label 2
        _titleDistanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60.0f, 15)];
        _titleDistanceLbl.frame = CGRectMake(_containerViewInfo.frame.size.width - _titleDistanceLbl.frame.size.width - MARGIN_CELLX_GROUP, 50 , _titleDistanceLbl.frame.size.width, _titleDistanceLbl.frame.size.height);
        _titleDistanceLbl.textAlignment = UITextAlignmentRight;
        [_titleDistanceLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titleDistanceLbl.text = @"Khoảng cách";
        _titleDistanceLbl.textColor = UIColorFromRGB(0x777777);
        [_containerViewInfo addSubview:_titleDistanceLbl];
        // kind label 2
        _distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 14)];
        _distanceLbl.backgroundColor = [UIColor clearColor];
        [_distanceLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_REGULAR size:12]];
        _distanceLbl.frame = CGRectMake(_titleDistanceLbl.frame.origin.x , _titleDistanceLbl.frame.size.height + _titlePunchLbl.frame.origin.y, _distanceLbl.frame.size.width, _distanceLbl.frame.size.height);
        _distanceLbl.textAlignment = UITextAlignmentRight;
        [_containerViewInfo addSubview:_distanceLbl];
        
        _processPunchBackGround =  [[SDImageView alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, _containerViewInfo.frame.size.height - 28 , _containerViewInfo.frame.size.width - OFFERTABLE_CELL_MARGIN*2, 20)];
        _processPunchBackGround.image = [UIImage imageNamed:@"progress.png"];
        _processPunchBackGround.layer.cornerRadius = 3;
        [_containerViewInfo addSubview:_processPunchBackGround];
        
        _processPunch1 =  [[UILabel alloc] initWithFrame:CGRectMake(5 , 7 , _processPunchBackGround.frame.size.width - OFFERTABLE_CELL_MARGIN, 10 )];
        _processPunch1.layer.cornerRadius = 3;
        _processPunch1.backgroundColor = UIColorFromRGB(0xcccccc);
        [_processPunchBackGround addSubview:_processPunch1];
        
        _processPunch =  [[UILabel alloc] initWithFrame:CGRectMake(0 , 0 , _processPunchBackGround.frame.size.width - OFFERTABLE_CELL_MARGIN, 10 )];
        _processPunch.backgroundColor = UIColorFromRGB(0x36c40d);
        _processPunch.layer.cornerRadius = 3;
        [_processPunch1 addSubview:_processPunch];
        
        
        _btMap = [[ UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _btMap.frame = CGRectMake(_containerViewInfo.frame.size.width - _btMap.frame.size.width - OFFERTABLE_CELL_MARGIN , _branchNameLbl.frame.origin.y , _btMap.frame.size.width , _btMap.frame.size.height);
        [_btMap setImage:[UIImage imageNamed:@"nav-bar-icon-map.png"] forState:UIControlStateNormal];
        [_btMap addTarget:self action:@selector(processOpenMapView:) forControlEvents:UIControlEventTouchUpInside];
        [_containerViewInfo addSubview:_btMap];
        
        UIView *bottomBorder = [[UIView alloc]
                                initWithFrame:CGRectMake(_containerViewInfo.frame.origin.x + 3 , _containerViewInfo.frame.origin.y + _containerViewInfo.frame.size.height ,
                                                         _containerViewInfo.frame.size.width - OFFERTABLE_CELL_PADDING*2,
                                                         1.0f)];
        bottomBorder.backgroundColor = UIColorFromRGB(0xe2e2e2);
        _containerViewInfo.layer.borderWidth = 0.2;
        [_containerView addSubview:bottomBorder];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)processOpenMapView:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate toMapViewController:nil withTitle:item.brand_name isHandleAction:NO];
}

-(void)setObject:(id)object
{
    if (![object isKindOfClass:[OfferDetailItem class]]) {
       return;
    }
     item = object;
    int randomNumber = 0 + rand() % (item.max_punch.intValue - 0);
//    _processPunch.frame = CGRectMake(_processPunch.frame.origin.x , _processPunch.frame.origin.y , ((item.user_punch.intValue * 100)/item.max_punch.intValue * 2.7) , 10 );
    _processPunch.frame = CGRectMake(_processPunch.frame.origin.x , _processPunch.frame.origin.y , ((randomNumber * 100)/item.max_punch.intValue * 2.7) , 10 );
    
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
            _deadLine.textColor = UIColorFromRGB(0x777777);
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
//    _punchLbl.text = [NSString stringWithFormat:@"%@/%@",item.user_punch ,item.max_punch];
    
     _punchLbl.text = [NSString stringWithFormat:@"%d/%@",randomNumber ,item.max_punch];
    _branchNameLbl.text = item.brand_name;
    _offerNameLbl.text = item.offer_name;
    _distanceLbl.text = item.distance;
    [_imageInfoPlus setImageWithURL:[NSURL URLWithString:item.path]];
}
@end
