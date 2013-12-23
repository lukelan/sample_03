//
//  PlusOfferListView.h
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@protocol PlusOfferListViewDelegate <NSObject>


@end

@interface PlusOfferListView : UIView <iCarouselDataSource, iCarouselDelegate>
{
    iCarousel *_carousel;
}

@property (nonatomic, weak) id<PlusOfferListViewDelegate> delegate;

@end
