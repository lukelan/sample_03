//
//  PlusOfferMapView.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusOfferMapView.h"
#import "OfferTableItem.h"
#import "GradientPolylineView.h"
#import "OfferAnnotationView.h"

@implementation PlusOfferMapView
{
    OfferTableItem *_selectedOfferItem;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:[self.class description] owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
        
        // setup map view
        self.mapView.delegate = self;
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
        if (IS_IPHONE5) {
        } else {
            [_btnUserLocation setFrame:CGRectMake(_btnUserLocation.frame.origin.x, _btnUserLocation.frame.origin.y - 90, _btnUserLocation.frame.size.height, _btnUserLocation.frame.size.width)];
        }
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
- (IBAction)showUserLocation:(id)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

-(void)reloadInterface:(NSMutableArray*)listOffers
{
    _dataSource = listOffers;
    
    // remove current current anotations
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[OfferTableItem class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    if ([self.dataSource count] == 0) {
        return;
    }
    
    // add new anotations
    [self.mapView addAnnotations:self.dataSource];
    
    // zoom to visual region
    MKCoordinateRegion region = [self createZoomRegionFromCentralPointAndRadius :self.dataSource];
    
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
    [_mapView reloadInputViews];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[OfferTableItem class]]) {
        NSString *identifier = [[OfferAnnotationView class] description];
        OfferAnnotationView *annotationView = (OfferAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[OfferAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        annotationView.annotation = annotation;
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        NSLog(@"annotation = %@", [[annotation class] description]);
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view conformsToProtocol:@protocol(OfferAnnotationViewProtocol)]) {
        _selectedOfferItem = (OfferTableItem*)view.annotation;
        [((NSObject<OfferAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view conformsToProtocol:@protocol(OfferAnnotationViewProtocol)]) {
        _selectedOfferItem = nil;
        [((NSObject<OfferAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay {
    GradientPolylineView *overlayView = [[GradientPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth = 5;
    return overlayView;
}

#pragma mark - Utilities

- (MKCoordinateRegion)createZoomRegionFromCentralPointAndRadius:(NSMutableArray*) categoryArray {
    
    Location *userLocation = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) userPosition];
    CLLocation *currentLocation = [[CLLocation alloc]
                                initWithLatitude:userLocation.latitude
                                longitude:userLocation.longtitude];;
    CLLocationDistance radiusMeters = MAXIMUM_SCALEABLE_RADIUS_METERS;
    CLLocation *nearestlocation = nil;
    
    for (OfferTableItem *item in categoryArray)
    {
        CLLocation *marklocation = [[CLLocation alloc] initWithLatitude:item.location.latitude longitude:item.location.longitude];
        CLLocationDistance temp = [marklocation distanceFromLocation:currentLocation];
        // find nearest item
        if (!nearestlocation || temp < radiusMeters) {
            radiusMeters = temp;
            nearestlocation = marklocation;
        }
    }
    
    // Update central point
    CLLocationCoordinate2D centralPoint;
    
    // If current location not found -> return the radius default 1km.
    if (currentLocation.coordinate.latitude == 0 && currentLocation.coordinate.longitude  == 0) {
        centralPoint.latitude   = nearestlocation.coordinate.latitude;
        centralPoint.longitude  = nearestlocation.coordinate.longitude;
        radiusMeters = 1000;
    } else {
        centralPoint.latitude    = currentLocation.coordinate.latitude;
        centralPoint.longitude   = currentLocation.coordinate.longitude ;
    }
    
    if (radiusMeters <= 0 || radiusMeters > MAXIMUM_SCALEABLE_RADIUS_METERS) {
        // Default for radius is 1km
        radiusMeters = 1000;
    }

    return MKCoordinateRegionMakeWithDistance(centralPoint, radiusMeters * 2, radiusMeters *2 );
    
}
@end
