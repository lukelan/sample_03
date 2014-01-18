//
//  DescriptionCell.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/14/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "DescriptionCell.h"
#import "OfferDetailItem.h"
#define OFFERTABLE_CELL_HEIGHT 80.0f
#define OFFERTABLE_CELL_PADDING 5.0f
#define OFFERTABLE_CELL_MARGIN 10.0f
#define LABEL_MARGIN 5.0f
#define OFFERTABLE_CELL_BACKGROUND_HEIGHT OFFERTABLE_CELL_HEIGHT - 2*OFFERTABLE_CELL_PADDING
@implementation DescriptionCell

{
OfferDetailItem *item;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // container view
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, 0, 320.0f - 2*OFFERTABLE_CELL_MARGIN, 0)];
        _containerView.layer.masksToBounds = YES;
        //    containerView.layer.cornerRadius = 8.0f;
        _containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containerView];
        _shadowLayer = [CALayer layer];
        _shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _shadowLayer.shouldRasterize = YES;
        _shadowLayer.shadowOffset = CGSizeMake(0.0, 0.0);
        //  _shadowLayer.shadowRadius = 5.0f;
        _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _shadowLayer.shadowOpacity = 0.1f;
        _shadowLayer.frame = _containerView.frame;
        [self.layer insertSublayer:_shadowLayer atIndex:0];
        self.descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(OFFERTABLE_CELL_MARGIN, 8, _containerView.frame.size.width - 2*OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_HEIGHT)];
        [_descriptionLbl setFont:[UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:13]];
        _descriptionLbl.textColor = UIColorFromRGB(0x777777);
        _descriptionLbl.lineBreakMode = UILineBreakModeWordWrap;
        _descriptionLbl.numberOfLines = 0;
        [_containerView addSubview:_descriptionLbl];
        _cellHeight = self.containerView.frame.size.height;
    }
    return self;
}

-(void)setDataDescription : (id)object
{
    item = object;
    _descriptionLbl.text =  item.offer_description;
    CGRect currentFrame = _descriptionLbl.frame;
    CGSize max = CGSizeMake(_descriptionLbl.frame.size.width, 500);
    CGSize expected = [item.offer_description sizeWithFont:_descriptionLbl.font constrainedToSize:max lineBreakMode:_descriptionLbl.lineBreakMode];
    currentFrame.size.height = expected.height;
    _descriptionLbl.frame = currentFrame;
    _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, currentFrame.size.height + _descriptionLbl.frame.origin.x * 2);
    _shadowLayer.frame = _containerView.frame;
    _cellHeight = currentFrame.size.height + _descriptionLbl.frame.origin.x * 2;
    [self.delegate descriptionCell:self didUpdateLayoutWithHeight:currentFrame.size.height + _descriptionLbl.frame.origin.x * 2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (float)getHeightForCellWithData:(id)object {
 
    OfferDetailItem *item = object;
    
    CGRect containViewFrame = CGRectMake(OFFERTABLE_CELL_MARGIN, 0, 320.0f - 2*OFFERTABLE_CELL_MARGIN, 0);
    
    CGRect descriptionFrame = CGRectMake(OFFERTABLE_CELL_MARGIN, 8, containViewFrame.size.width - 2*OFFERTABLE_CELL_MARGIN, OFFERTABLE_CELL_HEIGHT);
    
    CGSize max = CGSizeMake(descriptionFrame.size.width, 500);
    
    UIFont *descriptionFont = [UIFont fontWithName:FONT_ROBOTOCONDENSED_LIGHT size:13];
    
    CGSize expected = [item.offer_description sizeWithFont:descriptionFont constrainedToSize:max lineBreakMode:UILineBreakModeWordWrap];
    
    descriptionFrame.size.height = expected.height;
    
    return (descriptionFrame.size.height + descriptionFrame.origin.x * 2);
}

@end
