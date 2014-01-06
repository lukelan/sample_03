//
//  OfferMapViewController.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/6/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlusOfferListView.h"
#import "PlusOfferMapView.h"
@interface OfferMapViewController : CustomGAITrackedViewController <PlusOfferListViewDelegate, PlusOfferMapViewDelegate>
{
PlusOfferMapView *_mapView;
}
@property (nonatomic, strong) NSString *brandName;
@end
