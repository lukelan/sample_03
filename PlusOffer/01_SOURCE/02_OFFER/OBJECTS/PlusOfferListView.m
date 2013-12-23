//
//  PlusOfferListView.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusOfferListView.h"

#define PLUSOFFER_CELL_WIDTH 320
#define PLUSOFFER_CELL_HEIGHT 172

@implementation PlusOfferListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 3; // for demo purpose
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)reusingView {
    int widthView = PLUSOFFER_CELL_WIDTH;
    int heightView = PLUSOFFER_CELL_HEIGHT;

    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthView, heightView)];
    
    // image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.opaque = YES;
    [view addSubview:imageView];
    
    return view;
}

#pragma mark - iCarouselDelegate

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}

@end
