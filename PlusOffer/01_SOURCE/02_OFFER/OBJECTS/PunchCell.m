//
//  PunchCell.m
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/31/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PunchCell.h"
#import "OfferDetailItem.h"

@implementation PunchCell

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
    UIFont *font = [UIFont fontWithName:@"Avenir Next" size:8.0];
    CGSize sizeText = [@"ABC" sizeWithFont:font];
    float margin = 10;
    int tag_min_button = 100;
    UIImage *imgEmpty = [UIImage imageNamed:@"punch-empty.png"];
    UIImage *imgPunchStar = [UIImage imageNamed:@"punch-Star.png"];
    for (int i = 0; i < [item.max_punch intValue]; i++) {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:tag_min_button + i];
        UIImageView *imgView = nil;
        if ([btn isKindOfClass:[UIButton class]])
        {
            imgView = (UIImageView *)[btn viewWithTag:1];
        }
        else
        {
            btn = [[UIButton alloc] initWithFrame:CGRectMake(margin + i*(imgEmpty.size.width + margin), margin, imgEmpty.size.width, imgEmpty.size.height)];
            btn.tag = tag_min_button +i;
            [btn addTarget:self action:@selector(processPunchAction) forControlEvents:UIControlEventTouchUpInside];
            
            imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"punch-empty.png"]];
            [imgView setFrame:CGRectMake(0, 0, imgEmpty.size.width, imgEmpty.size.height)];
            [imgView setTag:1];
            UILabel *lblIcon = [[UILabel alloc] initWithFrame:CGRectMake(1, imgEmpty.size.height - sizeText.height, 12, 12)];
            [lblIcon setBackgroundColor:[UIColor greenColor]];
            [lblIcon setText:[NSString stringWithFormat:@"%d", (i + 1)]];
            [lblIcon setTextColor:[UIColor whiteColor]];
            [lblIcon setTextAlignment:NSTextAlignmentCenter];
            [lblIcon setFont:font];
            [lblIcon.layer setCornerRadius:3];
            [imgView addSubview:lblIcon];
            [btn addSubview:imgView];
            [self.scrollView addSubview:btn];
        }
        if (![imgView isKindOfClass:[UIImageView class]]) {
            continue;
        }
        
        [btn setEnabled:YES];
        if (i == (item.max_punch.intValue - 1))
        {
            [btn setEnabled:NO];
            [imgView setImage:[UIImage imageNamed:@"punch-reward"]];
        }
        if (i <= item.count_puch.intValue) {
            [btn setEnabled:NO];
            [imgView setImage:imgPunchStar];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(margin + item.max_punch.intValue *(imgEmpty.size.width + margin), imgEmpty.size.height)];
}

- (void)processPunchAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(processOpenBarcodeScanner)]) {
        [_delegate processOpenBarcodeScanner];
    }
}
@end
