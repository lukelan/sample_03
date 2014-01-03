//
//  OfferAnnotationView.h
//  PlusOffer
//
//  Created by Tai Truong on 1/2/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface OfferAnnotationView : MKAnnotationView
{
    CAShapeLayer *_shapeLayer;
    CAShapeLayer *_strokeAndShadowLayer;
}
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end
