//
//  PunchCardCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/8/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//
#define MAX_ITEM_IN_ROW 4
#define START_TAG_INDEX_PUNCH 100
#define MARGIN_SCROLL_VIEW 5
#define MAX_WIDTH_BUTTON 60
#define WIDTH_LOGO 40
#define MAX_PUNCH_INFO_ITEM_IN_ROW 12
#define WIDTH_ICON_PUNCH 8

#import "PunchCardCell.h"
#import "BrandModel.h"


@implementation PunchCardCell
static bool isExpanded = NO;
@synthesize delegate = _delegate;
@synthesize barCodeDelegate = _barCodeDelegate;

-(void)dealloc
{
    _bgBrandLogo = nil;
    _bgCardImage = nil;
    _btnTitle = nil;
    _scrollView = nil;
    _containerView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int margin = 0;
        if (IOS_VERSION >= 7.0) {
            margin = MARGIN_CELLX_GROUP;
        }
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, [[UIScreen mainScreen] bounds].size.width - 2*MARGIN_CELLX_GROUP, [[UIScreen mainScreen] bounds].size.height - TAB_BAR_HEIGHT - 2*MARGIN_CELLX_GROUP - WIDTH_LOGO - TITLE_BAR_HEIGHT)];
        _containerView.backgroundColor = [UIColor clearColor];
        [_containerView.layer setCornerRadius:MARGIN_CELLX_GROUP/2];
        [self.contentView addSubview:_containerView];
        
        //init button tile
        _btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _containerView.frame.size.width, 60)];
        [_btnTitle setBackgroundColor:[UIColor clearColor]];
        [_btnTitle addTarget:self action:@selector(showFullOrShortDes) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_btnTitle];
        
        CGRect frame = _btnTitle.frame;
        frame.origin.x = MARGIN_CELLX_GROUP/2;
        frame.size.width = WIDTH_LOGO;
        frame.size.height = WIDTH_LOGO;
        frame.origin.y = (_btnTitle.frame.size.height - frame.size.height)/2;
        _bgBrandLogo = [[SDImageView alloc] initWithFrame:frame];
        _bgBrandLogo.backgroundColor = [UIColor clearColor];
        [_btnTitle addSubview:_bgBrandLogo];
        
        //init infor punch
        UIFont *font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12];
        CGSize size = [@"ABC" sizeWithFont:font];
        _lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(_btnTitle.frame.size.width/2, _btnTitle.frame.size.height/2 - size.height, _btnTitle.frame.size.width/2 - MARGIN_CELLX_GROUP/2, size.height)];
        [_lblDescription setFont:font];
        if (IOS_VERSION >= 7.0) {
            [_lblDescription setTextAlignment:NSTextAlignmentRight];
        } else {
            [_lblDescription setTextAlignment:UITextAlignmentRight];
        }
        [_lblDescription setBackgroundColor:[UIColor clearColor]];
        [_lblDescription setTextColor:[UIColor colorWithWhite:1 alpha:0.7]];
        [_btnTitle addSubview:_lblDescription];
        //init view Punch Info
        _viewPunchInfo = [[UIView alloc] initWithFrame:CGRectMake(_lblDescription.frame.origin.x, _lblDescription.frame.origin.y + _lblDescription.frame.size.height, _lblDescription.frame.size.width, 4*WIDTH_ICON_PUNCH)];
        [_viewPunchInfo setBackgroundColor:[UIColor clearColor]];
        [_viewPunchInfo setUserInteractionEnabled:NO];
        [_btnTitle addSubview:_viewPunchInfo];
        
        // logo image
        _bgCardImage = [[SDImageView alloc] initWithFrame:CGRectMake(MARGIN_SCROLL_VIEW, _btnTitle.frame.origin.y + _btnTitle.frame.size.height, _containerView.frame.size.width - 2*MARGIN_SCROLL_VIEW, 160)];
        _bgCardImage.backgroundColor = [UIColor clearColor];
        [_bgCardImage.layer setCornerRadius:MARGIN_CELLX_GROUP/2];
        [_containerView addSubview:_bgCardImage];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN_SCROLL_VIEW, _bgCardImage.frame.origin.y + _bgCardImage.frame.size.height, _containerView.frame.size.width - 2*MARGIN_SCROLL_VIEW, _containerView.frame.size.height - (_bgCardImage.frame.origin.y + _bgCardImage.frame.size.height) - MARGIN_SCROLL_VIEW)];
        [self.scrollView setBackgroundColor:[UIColor whiteColor]];
        [_containerView addSubview:self.scrollView];
        //add line
        
        int margin_line = -MARGIN_CELLX_GROUP/2;
        if (IOS_VERSION >= 7.0) {
            margin_line = MARGIN_CELLX_GROUP/2;
        }
        _lblLine = [[UILabel alloc] initWithFrame:CGRectMake(margin_line, _btnTitle.frame.size.height - 1, self.contentView.frame.size.width - MARGIN_CELLX_GROUP, 1)];
        [_lblLine setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
        [_lblLine setHidden:YES];
        [self.contentView addSubview:_lblLine];
        
        _btnPunch = [[UIButton alloc] initWithFrame:CGRectMake(margin, _containerView.frame.origin.y + _containerView.frame.size.height + MARGIN_CELLX_GROUP, _containerView.frame.size.width, WIDTH_LOGO)];
        [_btnPunch.titleLabel setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_REGULAR size:20]];
        [_btnPunch setTitle:@"Quét mã tích điểm" forState:UIControlStateNormal];
        [_btnPunch.layer setCornerRadius:MARGIN_CELLX_GROUP/2];
        [_btnPunch addTarget:self action:@selector(processEventAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPunch];
    }
    return self;
}

- (void)setObject:(id)object
{
    if (![object isKindOfClass:[BrandModel class]]) {
        return;
    }
    _curBrand = object;
    BrandModel *temp = object;
    if([temp.brand_card_logo isKindOfClass:[NSString class]] && temp.brand_card_logo.length > 0)
    {
        [_bgCardImage setImageWithURL:[NSURL URLWithString:temp.brand_card_image]];
    }

    NSURL *logo_url = [NSURL URLWithString:temp.brand_card_logo];
    __block SDImageView *imgView = _bgBrandLogo;
    [_bgBrandLogo setImageWithURL:logo_url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         if (![imgView isResized])
         {
             CGRect frame = imgView.frame;
             [imgView setIsResized:YES];
             if (image.size.width/2 >= frame.size.width && frame.size.width >= 2*frame.size.height)
             {
                 frame.size.width = 140;
                 [imgView setFrame:frame];
             }
         }
     }];
    [_lblDescription setText:@"Hết hạn: 13/10/2014"];
    if ([temp.brand_card_color isKindOfClass:[NSString class]])
    {
        [_containerView setBackgroundColor:[UIColor colorWithHex:temp.brand_card_color alpha:1.0]];
        [_btnPunch setBackgroundColor:[UIColor colorWithHex:temp.brand_card_color alpha:1.0]];
    }
    [_lblLine setHidden:NO];
    if (isExpanded)
    {
        [_lblLine setHidden:YES];
    }
    //add scroll View
    [self layoutPuchItem:temp];
    [self layoutPunchInfo:temp withAlignRight:YES];
}

- (void) layoutPuchItem:(BrandModel *)temp
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES]];
    int buttonWidth = MAX_WIDTH_BUTTON;
    int buttonHeight = MAX_WIDTH_BUTTON;
    int distance_Button = (300 - MAX_ITEM_IN_ROW*buttonWidth - 2*MARGIN_SCROLL_VIEW)/ (MAX_ITEM_IN_ROW + 1);
    for(int i=0;i< temp.max_punch.intValue;i++)
    {
        UIButton *btnPunch = (UIButton *)[_scrollView viewWithTag:START_TAG_INDEX_PUNCH + i];
        if (!btnPunch)
        {
            int xAdjust = distance_Button;
            int yAdjust = distance_Button;
            
            if (i < MAX_ITEM_IN_ROW)
            {
                xAdjust = distance_Button + i*(buttonWidth + distance_Button);
            }
            else
            {
                if(i%MAX_ITEM_IN_ROW != 0)
                {
                    xAdjust = distance_Button + (i%MAX_ITEM_IN_ROW)*(buttonWidth + distance_Button);
                }
                yAdjust = distance_Button + (i/MAX_ITEM_IN_ROW)*(buttonHeight + distance_Button);
            }
            btnPunch = [[UIButton alloc] init];
            [btnPunch setFrame:CGRectMake(xAdjust, yAdjust, buttonWidth, buttonHeight)];
            btnPunch.tag = START_TAG_INDEX_PUNCH + i;
            [btnPunch.layer setCornerRadius:MARGIN_CELLX_GROUP/2];
//            [btnPunch.layer setBorderWidth:MARGIN_CELLX_GROUP/3];
            btnPunch.titleLabel.font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_REGULAR size:20];
            [btnPunch addTarget:self action:@selector(processActionSelect:) forControlEvents:UIControlEventTouchUpInside];
            
            //add image bg for punch button
            SDImageView * sdImageView = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0,btnPunch.frame.size.width, btnPunch.frame.size.height)];
            sdImageView.tag = 10;
            [sdImageView.layer setCornerRadius:btnPunch.layer.cornerRadius];
            [sdImageView.layer setMasksToBounds:YES];
            [btnPunch addSubview:sdImageView];
            [_scrollView addSubview:btnPunch];
        }
        //Xanh lá: #8ed400
        //Xám: #9f9f9f

        [btnPunch setHidden:NO];
        [btnPunch setEnabled:YES];
//        [btnPunch setTitleColor:UIColorFromRGB(0x9f9f9f) forState:UIControlStateNormal];
//        [btnPunch setTitle:[NSString stringWithFormat:@"%d", (i+1)] forState:UIControlStateNormal];
        SDImageView *sdImageView = (SDImageView *)[btnPunch viewWithTag:10];
        BOOL isValid = NO;
        if ([sdImageView isKindOfClass:[SDImageView class]]) {
            isValid = YES;
        }
        if(i < temp.user_punch.intValue)
        {
            [btnPunch setEnabled:NO];
//            [btnPunch setTitleColor:UIColorFromRGB(0x8ed400) forState:UIControlStateNormal];
            if (isValid) {
                [sdImageView setImageWithURL:[NSURL URLWithString:temp.punch_image_active]];
            }
        }
        else
        {
            if (isValid) {
                [sdImageView setImageWithURL:[NSURL URLWithString:temp.punch_image]];
            }
        }
//        [btnPunch.layer setBorderColor:btnPunch.titleLabel.textColor.CGColor];
        if (![temp.list_prize isKindOfClass:[NSArray class]]) {
            continue;
        }
        
        for (int j = 0; j < [temp.list_prize count]; j++) {
            NSDictionary *dic = [temp.list_prize objectAtIndex:j];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                id indexValue = [dic objectForKey:@"prize_punch"];
                id linkImage = [dic objectForKey:@"prize_image"];
                if ([indexValue isKindOfClass:[NSString class]] && [linkImage isKindOfClass:[NSString class]])
                {
                    if ([indexValue intValue] == i)
                    {
                        SDImageView *sdImageView = (SDImageView *)[btnPunch viewWithTag:10];
                        if (![sdImageView isKindOfClass:[SDImageView class]]) {
                            if (sdImageView) {
                                [sdImageView removeFromSuperview];
                            }
                            sdImageView = [[SDImageView alloc] initWithFrame:CGRectMake(0, 0,btnPunch.frame.size.width, btnPunch.frame.size.height)];
                            sdImageView.tag = 10;
                            [sdImageView.layer setCornerRadius:btnPunch.layer.cornerRadius];
                            [sdImageView.layer setMasksToBounds:YES];
                        }
                        [sdImageView setImageWithURL:[NSURL URLWithString:linkImage]];
                        [btnPunch addSubview:sdImageView];
                    }
                }
            }
        }
    }
    int nguyen = temp.max_punch.intValue%MAX_ITEM_IN_ROW;
    int numOfRow = (temp.max_punch.intValue/MAX_ITEM_IN_ROW) + (nguyen > 0 ? 1:0);
    [self.scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, distance_Button + numOfRow *(buttonHeight + distance_Button))];
}

- (void)layoutPunchInfo:(BrandModel *)item withAlignRight:(BOOL)isRight
{
    [self.viewPunchInfo.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat margin = WIDTH_ICON_PUNCH/2;
    //find index to draw align right
    int index = -1;
    int max_row = item.max_punch.intValue/MAX_PUNCH_INFO_ITEM_IN_ROW;
    int roundValue = item.max_punch.intValue%MAX_PUNCH_INFO_ITEM_IN_ROW;
    if (isRight)
    {
        if (roundValue != 0) {
            index = max_row * MAX_PUNCH_INFO_ITEM_IN_ROW;
            if (index < 0) {
                index = 0;
            }
        }
    }
    
    for (int i = 0; i < [item.max_punch intValue]; i++)
    {
        UILabel *lblIcon = (UILabel *)[self.viewPunchInfo viewWithTag:START_TAG_INDEX_PUNCH + i];
        if (![lblIcon isKindOfClass:[UILabel class]])
        {
            int xAdjust = margin;
            int yAdjust = margin;
            
            if (i < MAX_PUNCH_INFO_ITEM_IN_ROW)
            {
                xAdjust = margin + i*(WIDTH_ICON_PUNCH + margin);
                if (i >= index && index != -1) {
                    xAdjust = (MAX_PUNCH_INFO_ITEM_IN_ROW - roundValue + i)*(WIDTH_ICON_PUNCH + margin) + margin;
                }
            }
            else
            {
                if(i%MAX_PUNCH_INFO_ITEM_IN_ROW != 0)
                {
                    xAdjust = margin + (i%MAX_PUNCH_INFO_ITEM_IN_ROW)*(WIDTH_ICON_PUNCH + margin);
                }
                if (i >= index && index != -1) {
                    xAdjust = (MAX_PUNCH_INFO_ITEM_IN_ROW - roundValue + i%MAX_PUNCH_INFO_ITEM_IN_ROW)*(WIDTH_ICON_PUNCH + margin) + margin;
                }
                
                yAdjust = margin + (i/MAX_PUNCH_INFO_ITEM_IN_ROW)*(WIDTH_ICON_PUNCH + margin);
            }
            
            lblIcon = [[UILabel alloc] initWithFrame:CGRectMake(xAdjust, yAdjust, WIDTH_ICON_PUNCH, WIDTH_ICON_PUNCH)];
            lblIcon.tag = START_TAG_INDEX_PUNCH +i;
            [lblIcon.layer setCornerRadius:WIDTH_ICON_PUNCH/2];
            [_viewPunchInfo addSubview:lblIcon];
        }
        [lblIcon setBackgroundColor:[UIColor colorWithHex:item.punch_color alpha:1.0]];
        if (i < item.user_punch.intValue)
        {
            [lblIcon setBackgroundColor:[UIColor colorWithHex:item.punch_color_active alpha:1.0]];
        }
        [lblIcon setHidden:NO];
    }
}

+ (BOOL)isExpanded
{
    return isExpanded;
}

#pragma mark -
#pragma mark process action
- (void)processActionSelect:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        SDImageView *sdImageView = (SDImageView *)[sender viewWithTag:10];
        if ([sdImageView isKindOfClass:[SDImageView class]])
        {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSURL *url = [NSURL URLWithString:_curBrand.punch_image_select];
            if ([[sdImageView curURL] isEqual:url]) {
                delegate.punch_item_count--;
                url = [NSURL URLWithString:_curBrand.punch_image];
            } else {
                delegate.punch_item_count++;
            }
            [sdImageView setImageWithURL:url];
        }
    }
    
}

- (void)processEventAction
{
    if (!self.barCodeDelegate || ![self.barCodeDelegate respondsToSelector:@selector(processOpenBarcodeScanner)])
    {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.punch_item_count > 0) {
        [self.barCodeDelegate processOpenBarcodeScanner];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Plus Offer" message:@"Bạn phải chọn số lượng để punch trước." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showFullOrShortDes
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(punchCardCell:didUpdateLayoutWithHeight:curIndex:)])
    {
        return;
    }
    isExpanded = !isExpanded;
    [_lblLine setHidden:!_lblLine.hidden];
    if (isExpanded)
    {
        [self.delegate punchCardCell:self didUpdateLayoutWithHeight:([[UIScreen mainScreen] bounds].size.height - TAB_BAR_HEIGHT - MARGIN_CELLX_GROUP  - TITLE_BAR_HEIGHT )curIndex:_CurIndexSelected];
    }
    else
    {
        [self.delegate punchCardCell:self didUpdateLayoutWithHeight:MIN_PUNCH_CELL_HEIGHT curIndex:_CurIndexSelected];
    }
}
@end
