//
//  MenuCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/7/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "MenuCell.h"
#import "MenuItem.h"
@implementation MenuCell

#define REDEEMTABLE_CELL_HEIGHT 80.0f
#define OFFERTABLE_CELL_PADDING 5.0f
#define OFFERTABLE_CELL_MARGIN 10.0f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // container view
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, REDEEMTABLE_CELL_HEIGHT )];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.masksToBounds = YES;
        [self addSubview:_containerView];
        // logo image
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_CELLX_GROUP, 2, 75, 75)];
        [_logoImageView setImage:[UIImage imageNamed:@"redeem_logo_1.png"]];
        [_containerView addSubview:_logoImageView];
        
        _imageDiscount = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _imageDiscount.layer.masksToBounds = YES;
        [_imageDiscount setImage:[UIImage imageNamed:@"ribbon-promotion-red.png"]];
        [_logoImageView addSubview:_imageDiscount];
        
        _discountLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _discountLbl.frame = CGRectMake(0, 0 ,  _discountLbl.frame.size.width, _discountLbl.frame.size.height);
        _discountLbl.backgroundColor = [UIColor clearColor];
        _discountLbl.font = [UIFont systemFontOfSize:16.0f];
        _discountLbl.transform = CGAffineTransformMakeRotation (-DEGREES_TO_RADIANS(45));
        _discountLbl.textAlignment = NSTextAlignmentCenter;
        [_discountLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:6]];
        _discountLbl.textColor = UIColorFromRGB(0x333333);
        
        [_imageDiscount addSubview:_discountLbl];
        // detail image
        //        UIImageView *detailBg = [[UIImageView alloc] initWithFrame:CGRectMake(83, 38, 128.0f, 19.0f)];
        //        [detailBg setImage:[UIImage imageNamed:@"redeem_detail_bg"]];
        //        [_containerView addSubview:detailBg];
        
        // name label
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(_logoImageView.frame.origin.x + _logoImageView.frame.size.width + 10, 10 , 160, 17)];
        _nameLbl.font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:14];
        _nameLbl.textColor = UIColorFromRGB(0x333333);
        [_containerView addSubview:_nameLbl];
        
        // detail Label
        _descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(_nameLbl.frame.origin.x , _nameLbl.frame.size.height + 10, 160.0f, 50)];
        _descriptionLbl.textColor = UIColorFromRGB(0x666666);
        _descriptionLbl.font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:12];
        //        CGSize size = [_descriptionLbl.text sizeWithFont:[UIFont fontWithName:FONT_UVFTYPOSLABSERIF size:15]];
        //        CGRect f = _descriptionLbl.frame;
        //        f.size.height = ceil(size.width/f.size.width)*size.height;
        //        _descriptionLbl.frame = f;
        _descriptionLbl.lineBreakMode = NSLineBreakByWordWrapping;
        _descriptionLbl.numberOfLines = 0;
        [_containerView addSubview:_descriptionLbl];
        
        // redeem button
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(_descriptionLbl.frame.size.width + _descriptionLbl.frame.origin.x , 0, 40, 20)];
        _priceLbl.frame =  CGRectMake(_descriptionLbl.frame.size.width + _descriptionLbl.frame.origin.x + 10 , (REDEEMTABLE_CELL_HEIGHT - _priceLbl.frame.size.height)/ 2, _priceLbl.frame.size.width, _priceLbl.frame.size.height);
        _priceLbl.textAlignment = UITextAlignmentCenter;
        _priceLbl.textColor = UIColorFromRGB(0x8ed400);
        _priceLbl.font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:16];
        
        [_containerView addSubview:_priceLbl];
    }
    return self;
}

-(void)setObject:(id)object
{
    MenuItem * item = object;
    _nameLbl.text = item.item_name;
    _priceLbl.text = [NSString stringWithFormat:@"%dK",item.item_price.intValue/1000];
    _descriptionLbl.text = item.item_description;
    [_logoImageView setImageWithURL:[NSURL URLWithString:item.item_image]];
    _imageDiscount.hidden = true;
    _discountLbl.hidden = true;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
