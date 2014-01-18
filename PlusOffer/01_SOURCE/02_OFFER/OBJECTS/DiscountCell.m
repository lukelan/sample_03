//
//  DiscountCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 12/27/13.
//  Copyright (c) 2013 Trong Vu. All rights reserved.
//

#import "DiscountCell.h"
#import "OfferDetailItem.h"

@implementation DiscountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGFloat)getHeight:(id)object
{
    CGFloat height = 47;
    UIFont *font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:10.0];
    CGSize sizeText = [@"ABC" sizeWithFont:font];
    
    if (![object isKindOfClass:[OfferDetailItem class]]) {
        return height;
    }
    OfferDetailItem *item = object;
    NSArray *arrDes = [item.offer_description componentsSeparatedByString:@"\n"];
    if (![arrDes isKindOfClass:[NSArray class]]) {
        return height;
    }
    return (height + (sizeText.height * arrDes.count));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setObject:(id)object
{
    if (![object isKindOfClass:[OfferDetailItem class]]) {
        return;
    }
    [self.lbTitle setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_REGULAR size:15]];
    OfferDetailItem *item = object;
    
//    [self.imageDiscount setImageWithURL:[NSURL URLWithString:item.iconURL]];//setImage:[UIImage imageNamed:@"redeem_logo_1.png"]
    self.lbTitle.text = item.offer_name;
    
    NSArray *arrDes = [item.offer_description componentsSeparatedByString:@"\n"];
    if (![arrDes isKindOfClass:[NSArray class]]) {
        return;
    }
    UIFont *font = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:10.0];
    CGSize sizeText = [@"ABC" sizeWithFont:font];
    CGRect frame = self.scrollViewDes.frame;
    frame.size.height = sizeText.height * arrDes.count;
    [self.scrollViewDes setFrame:frame];
    
    int tag_min = 100;
    for (int i = 0; i < arrDes.count; i++)
    {
        UILabel *lblText = (UILabel *)[self.scrollViewDes viewWithTag:tag_min+i];
        if (![lblText isKindOfClass:[UILabel class]])
        {
            UILabel *lblIcon = [[UILabel alloc] initWithFrame:CGRectMake(1, (sizeText.height - 6)/2 + i * sizeText.height, 6, 6)];
            [lblIcon setBackgroundColor:[UIColor greenColor]];
            [lblIcon.layer setCornerRadius:3];
            lblText = [[UILabel alloc] initWithFrame:CGRectMake(6 + lblIcon.frame.size.width, i * sizeText.height, self.scrollViewDes.frame.size.width - 6 + lblIcon.frame.size.width - 1, sizeText.height)];
            [lblText setFont:font];
            [lblText setTextColor:UIColorFromRGB(0x666666)];
            [lblText setTag:tag_min + i];
            [self.scrollViewDes addSubview:lblIcon];
            [self.scrollViewDes addSubview:lblText];
            lblText.backgroundColor = [UIColor clearColor];
        }
        [lblText setText:[arrDes objectAtIndex:i]];
    }
//    [self.scrollViewDes setContentSize:CGSizeMake(self.scrollViewDes.frame.size.width, sizeText.height*arrDes.count)];
}
@end
