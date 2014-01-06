//
//  InfoPlusOfferCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 12/27/13.
//  Copyright (c) 2013 Trong Vu. All rights reserved.
//

#import "InfoPlusOfferCell.h"
#import "OfferDetailItem.h"
@implementation InfoPlusOfferCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)processOpenMapView:(id)sender
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(processOpenMapView)]) {
//        [_delegate processOpenMapView];
//    }
//}

-(void)setObject:(id)object
{
    if (![object isKindOfClass:[OfferDetailItem class]]) {
        return;
    }
    OfferDetailItem *item = object;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        _imageInfoPlus.frame = CGRectMake(0, 0, _imageInfoPlus.frame.size.width - MARGIN_CELLX_GROUP* 2, _imageInfoPlus.frame.size.height);
        _imageInfoPlus.layer.cornerRadius = 20.0f;
    }

    [self.imageInfoPlus setImageWithURL:[NSURL URLWithString:item.bannerUrl]];
//    [self.lblocation setText:item.branch_address];
//    [self.lbtime setText:item.hour_working];
}
@end
