//
//  InfoAccountCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/21/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "InfoAccountCell.h"
#import "OfferModel.h"
#import "NearByOffer.h"
#import "BrandModel.h"
#define OFFERTABLE_CELL_HEIGHT 200.0f
#define OFFERTABLE_CELL_PADDING 10.0f
#define OFFERTABLE_CELL_MARGIN 10.0f
#define LABEL_MARGIN 5.0f
#define OFFERTABLE_CELL_BACKGROUND_HEIGHT OFFERTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING
@implementation InfoAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // container view
        self.containerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 320.0f, OFFERTABLE_CELL_HEIGHT)];
        self.containerView.backgroundColor = [UIColor clearColor];
        self.containerView.layer.masksToBounds = YES;
        [self addSubview:self.containerView];
        // container view info
        self.containerViewInfo= [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 320.0f, OFFERTABLE_CELL_HEIGHT * 2/3)];
        //self.containerViewInfo.backgroundColor = [UIColor grayColor];
      //  _containerViewInfo.backgroundColor = UIColorFromRGB(0x87cefa);
        self.containerViewInfo.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerViewInfo];
        
        self.imageBgAccount = [[SDImageView alloc] initWithFrame:_containerViewInfo.frame];
        [_containerViewInfo addSubview:_imageBgAccount];
        //container view setting
        self.containerViewSetting = [[UIView alloc] initWithFrame:CGRectMake(0, _containerViewInfo.frame.origin.y + _containerViewInfo.frame.size.height, 320.0f, OFFERTABLE_CELL_HEIGHT/3)];
        self.containerViewSetting.layer.masksToBounds = YES;
        self.containerViewSetting.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerViewSetting];
        //image avatar
        self.avatarImageView = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0 , 70, 70)];
        self.avatarImageView.frame = CGRectMake(MARGIN_CELLX_GROUP * 3, (_containerViewInfo.frame.size.height - _avatarImageView.frame.size.height)/2, _avatarImageView.frame.size.width, _avatarImageView.frame.size.height);
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height /2;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.borderWidth = 0;
        self.avatarImageView.layer.borderWidth = 3.0f;
        [self.avatarImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.containerViewInfo addSubview:_avatarImageView];
        // name label
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.size.width +_avatarImageView.frame.origin.x + (MARGIN_CELLX_GROUP * 2), _avatarImageView.frame.origin.y + MARGIN_CELLX_GROUP , 200 , 25)];
        [_nameLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:20]];
        _nameLbl.textColor = UIColorFromRGB(0x111111);
        _nameLbl.backgroundColor = [UIColor clearColor];
        [self.containerViewInfo addSubview:_nameLbl];
        // nick name label
        self.nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.size.width +_avatarImageView.frame.origin.x + (MARGIN_CELLX_GROUP * 2), _nameLbl.frame.origin.y + _nameLbl.frame.size.height + 5 , 200 , 15)];
        [_nickNameLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:14]];
        _nickNameLbl.textColor = [UIColor blueColor];
        _nickNameLbl.backgroundColor = [UIColor clearColor];
        [self.containerViewInfo addSubview:_nickNameLbl];
       // Button Notification
        self.btNotification = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0 , _containerViewSetting.frame.size.width/3, _containerViewSetting.frame.size.height)];
        self.btNotification.backgroundColor = UIColorFromRGB(0xfefefe);
         [_btNotification addTarget:self action:@selector(actionNotification) forControlEvents:UIControlEventTouchUpInside];
        [self.containerViewSetting addSubview:_btNotification];
        
        self.imageBtNotification = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 25 , 25)];
        self.imageBtNotification.frame = CGRectMake((_btNotification.frame.size.width - _imageBtNotification.frame.size.width)/2, 15 , _imageBtNotification.frame.size.width , _imageBtNotification.frame.size.height);
        [_btNotification addSubview:_imageBtNotification];
        
        self.titleBtNotification = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100 ,15 )];
        self.titleBtNotification.frame = CGRectMake((_btNotification.frame.size.width - _titleBtNotification.frame.size.width)/2 , _imageBtNotification.frame.size.height + _imageBtNotification.frame.origin.y + 3 , _titleBtNotification.frame.size.width , _titleBtNotification.frame.size.height);
        self.titleBtNotification.textAlignment = UITextAlignmentCenter;
        [_titleBtNotification setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titleBtNotification.textColor = UIColorFromRGB(0x333333);
        [_btNotification addSubview:_titleBtNotification];
        
        UIView *leftBorder = [[UIView alloc]
                              initWithFrame:CGRectMake(_btNotification.frame.size.width - 1 , 0,1.0f, _containerViewSetting.frame.size.height)];
        leftBorder.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [_btNotification addSubview:leftBorder];
        
        // Button history
        self.btHistory = [[UIButton alloc] initWithFrame:CGRectMake(_btNotification.frame.size.width , 0 ,_containerViewSetting.frame.size.width/3, _containerViewSetting.frame.size.height)];
        self.btHistory.backgroundColor = UIColorFromRGB(0xfefefe);
         [_btHistory addTarget:self action:@selector(actionHistory) forControlEvents:UIControlEventTouchUpInside];
        [self.containerViewSetting addSubview:_btHistory];
        self.imageBtHistory = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 25 , 25)];
        self.imageBtHistory.frame = CGRectMake((_btHistory.frame.size.width - _imageBtHistory.frame.size.width)/2,  15 , _imageBtHistory.frame.size.width , _imageBtHistory.frame.size.height);
        [_btHistory addSubview:_imageBtHistory];
        
        self.titleBtHistory= [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100 ,15 )];
        self.titleBtHistory.frame = CGRectMake((_btHistory.frame.size.width - _titleBtHistory.frame.size.width)/2 , _imageBtHistory.frame.size.height + _imageBtHistory.frame.origin.y + 3, _titleBtHistory.frame.size.width , _titleBtHistory.frame.size.height);
        self.titleBtHistory.textAlignment = UITextAlignmentCenter;
        [_titleBtHistory setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titleBtHistory.textColor = UIColorFromRGB(0x333333);
        [_btHistory addSubview:_titleBtHistory];
        
        UIView *leftBorder1 = [[UIView alloc]
                              initWithFrame:CGRectMake(_btHistory.frame.size.width - 1 , 0,1.0f, _containerViewSetting.frame.size.height)];
        leftBorder1.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [_btHistory addSubview:leftBorder1];
        
        // Button setting
        
        self.btSetting= [[UIButton alloc] initWithFrame:CGRectMake(_btHistory.frame.size.width + _btHistory.frame.origin.x , 0 , _containerViewSetting.frame.size.width/3, _containerViewSetting.frame.size.height)];
        self.btSetting.backgroundColor = UIColorFromRGB(0xffffff);
        [_btSetting addTarget:self action:@selector(actionSetting) forControlEvents:UIControlEventTouchUpInside];
        [self.containerViewSetting addSubview:_btSetting];
        
        self.imageBtSetting = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0, 25 , 25)];
        self.imageBtSetting.frame = CGRectMake((_btSetting.frame.size.width - _imageBtSetting.frame.size.width)/2,  15 , _imageBtSetting.frame.size.width , _imageBtSetting.frame.size.height);
        [_btSetting addSubview:_imageBtSetting];
        
        self.titleBtSetting = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100 ,15 )];
        self.titleBtSetting.frame = CGRectMake((_btSetting.frame.size.width - _titleBtSetting.frame.size.width)/2 , _imageBtSetting.frame.size.height + _imageBtSetting.frame.origin.y + 3, _titleBtSetting.frame.size.width , _titleBtSetting.frame.size.height);
        self.titleBtSetting.textAlignment = UITextAlignmentCenter;
        [_titleBtSetting setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _titleBtSetting.textColor = UIColorFromRGB(0x333333);
        [_btSetting addSubview:_titleBtSetting];
        
        

        _titleBtNotification.text = @"Thông báo";
        _titleBtHistory.text = @"Yêu thích";
        _titleBtSetting.text = @"Cấu hình";
        [_imageBtNotification setImage:[UIImage imageNamed:@"alert.png"]];
        [_imageBtHistory setImage:[UIImage imageNamed:@"bookmark-big.png"]];
        [_imageBtSetting setImage:[UIImage imageNamed:@"setting.png"]];
         _nameLbl.text=  [[UIDevice currentDevice]name];
         _nickNameLbl.text= @"Duydk";
        [_avatarImageView setImage:[UIImage imageNamed:@"redeem_avatar.png"]];
        [self.imageBgAccount setImage:[UIImage imageNamed:@"bg_account.jpg"]];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)actionSetting
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiResetPunch:self forUserID:delegate.userProfile.user_id atBanchID:@"-1"];
}
- (void)processResultResponseDictionaryMapping:(DictionaryMapping *)dictionary requestId:(int)request_id
{
    if (request_id == ID_REQUEST_RESET_PUNCH)
    {
        //process data return
        id result = [dictionary.curDictionary objectForKey:@"result"];
        if ([result isKindOfClass:[NSNumber class]])
        {
            if(([result integerValue]) == 1)
            {
                // can call server get new data
                
                //Update data local
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
               NSMutableArray *getList =  [delegate fetchRecords:@"OfferModel" sortWithKey:@"offer_id" ascending:YES withPredicate:nil];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PlusOffer" message:@"Bạn đã reset punch" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                for (OfferModel *itemModel in getList)
                {
                    itemModel.user_punch =[NSNumber numberWithInt:0];
                }
                 NSMutableArray *getListBrandModel =  [delegate fetchRecords:@"BrandModel" sortWithKey:@"brand_id" ascending:YES withPredicate:nil];
                for (BrandModel *itemModel in getListBrandModel)
                {
                    itemModel.user_punch =[NSNumber numberWithInt:0];
                }
                [delegate saveContext];
            }
        }
        else
        {
            NSLog(@"error = %@", [dictionary.curDictionary objectForKey:@"error"]);
        }
    }
}

-(void)actionHistory
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PlusOffer" message:@"Tính năng này đang phát triển" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
-(void)actionNotification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PlusOffer" message:@"Tính năng này đang phát triển" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
@end
