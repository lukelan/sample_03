//
//  plusOtherCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/10/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//
#define OFFERTABLE_CELL_HEIGHT 70.0f
#define OFFERTABLE_CELL_PADDING 10.0f
#define OFFERTABLE_CELL_MARGIN 10.0f
#define LABEL_MARGIN 5.0f
#define OFFERTABLE_CELL_BACKGROUND_HEIGHT OFFERTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING // 134.0f (set background height = cell height for testing purpose)

#import "plusOtherCell.h"
#import "OfferDetailItem.h"
@implementation plusOtherCell

{
    OfferDetailItem *item;
}
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
        _imageLogo = [[SDImageView alloc]
                     initWithFrame:CGRectMake(OFFERTABLE_CELL_PADDING, 5 ,
                                              60.0f,
                                              60.0f)];

        [containerView addSubview:_imageLogo];
        _bottomBorder = [[UIView alloc]
                         initWithFrame:CGRectMake(OFFERTABLE_CELL_PADDING,containerView.frame.size.height - 1,
                                                  containerView.frame.size.width - OFFERTABLE_CELL_PADDING*2,
                                                  1.0f)];
    
        _bottomBorder.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [containerView addSubview:_bottomBorder];
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_PADDING + _imageLogo.frame.size.height + _imageLogo.frame.origin.x , 18 , 200, 15)];
        [containerView addSubview:_titleLbl];
        [_titleLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:14]];
        _titleLbl.textColor = UIColorFromRGB(0x111111);
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(_titleLbl.frame.origin.x, _titleLbl.frame.size.height + _titleLbl.frame.origin.y + 3 , 200, 17)];
        [_contentLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12]];
        _contentLbl.textColor = UIColorFromRGB(0x333333);
        [containerView addSubview:_contentLbl];
        _imageArrow =  [[SDImageView alloc] initWithFrame:CGRectMake(0 , 0 , 8, 15)];
        _imageArrow.frame = CGRectMake(containerView.frame.size.width - OFFERTABLE_CELL_MARGIN - _imageArrow.frame.size.width, (containerView.frame.size.height - _imageArrow.frame.size.height)/2 , _imageArrow.frame.size.width, _imageArrow.frame.size.height);
        [_imageArrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [containerView addSubview:_imageArrow];
        //_imageLogo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image1.png"]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setData :(id)data :(int)indexPath
{
    if (![data isKindOfClass:[OfferDetailItem class]]) {
        return;
    }
    item = data;
    NSDictionary *dic = [item.menu objectAtIndex:indexPath];
    _contentLbl.text  = [dic objectForKey:@"item_description"];
//    NSString *itemid  = [dic objectForKey:@"item_id"];
    _titleLbl.text  = [dic objectForKey:@"item_name"];
    [_imageLogo setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"item_image"]]];


}

@end
