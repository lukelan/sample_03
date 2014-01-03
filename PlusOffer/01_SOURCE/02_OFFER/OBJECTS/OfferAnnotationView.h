//
//  OfferAnnotationView.h
//  PlusOffer
//
//  Created by Tai Truong on 1/2/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef enum {
    OfferAnnotationViewState_Normal,
    OfferAnnotationViewState_Expanded,
    OfferAnnotationViewState_Animating,
    OfferAnnotationViewState_Num
} OfferAnnotationViewState;

@protocol OfferAnnotationViewProtocol <NSObject>

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView;
- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView;

@end

@interface OfferAnnotationView : MKAnnotationView <OfferAnnotationViewProtocol>
{
    CAShapeLayer *_strokeAndShadowLayer;
    OfferAnnotationViewState _state;
}
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, retain) SDImageView *discountImage;
@property (nonatomic, retain) UILabel *discountLbl;
@property (nonatomic, strong) UIView *expandedView;
@property (nonatomic, strong) UIImageView *normalView;

@end
