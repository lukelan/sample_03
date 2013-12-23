//
//  PlusOfferMapView.h
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol PlusOfferMapViewDelegate <NSObject>



@end

@interface PlusOfferMapView : UIView <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, weak) id<PlusOfferMapViewDelegate> delegate;
@end
