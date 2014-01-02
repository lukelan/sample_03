//
//  DiscountCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 12/27/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
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
    OfferDetailItem *item = object;
    
    [self.imageDiscount setImageWithURL:[NSURL URLWithString:item.iconURL]];//setImage:[UIImage imageNamed:@"redeem_logo_1.png"]
    self.lbTitle.text = item.offer_name;
    
    NSArray *arrDes = [item.offer_description componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    if (![arrDes isKindOfClass:[NSArray class]]) {
        return;
    }
    UIFont *font = [UIFont fontWithName:@"Avenir Next" size:10.0];
    CGSize sizeText = [@"ABC" sizeWithFont:font];
    for (int i = 0; i < arrDes.count; i++) {
        UILabel *lblIcon = [[UILabel alloc] initWithFrame:CGRectMake(1, (sizeText.height - 6)/2 + i * sizeText.height, 6, 6)];
        [lblIcon setBackgroundColor:[UIColor greenColor]];
        [lblIcon.layer setCornerRadius:3];
        UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(6 + lblIcon.frame.size.width, i * sizeText.height, self.scrollViewDes.frame.size.width - 6 + lblIcon.frame.size.width - 1, sizeText.height)];
        [lblText setFont:font];
        [lblText setText:[arrDes objectAtIndex:i]];
        [lblText setTextColor:UIColorFromRGB(0x9f9f9f)];
        
        [self.scrollViewDes addSubview:lblIcon];
        [self.scrollViewDes addSubview:lblText];
    }
    [self.scrollViewDes setContentSize:CGSizeMake(self.scrollViewDes.frame.size.width, sizeText.height*arrDes.count)];
}
@end
