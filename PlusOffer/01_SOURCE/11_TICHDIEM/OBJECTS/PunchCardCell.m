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
#import "PunchCardDetail.h"

@implementation PunchCardCell
static bool isExpanded = NO;
@synthesize delegate = _delegate;
@synthesize barCodeDelegate = _barCodeDelegate;

-(void)dealloc
{
    _bgBrandLogo = nil;
    _bgCardImage = nil;
    _btnTitle = nil;
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
        //[_btnPunch setBackgroundColor:[UIColor colorWithHex:temp.brand_card_color alpha:1.0]];
    }
    [_lblLine setHidden:NO];
    if (isExpanded)
    {
        [_lblLine setHidden:YES];
    }
    
    [self layoutPunchInfo:temp withAlignRight:YES];
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

- (void)showFullOrShortDes
{
    PunchCardDetail *detailView = [[PunchCardDetail alloc] initWithFrame:self.contentView.frame];
    //detailView.delegate = self.delegate;
    [detailView setObject:_curBrand];
    [self.contentView addSubview:detailView];
    
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
