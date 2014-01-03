//
//  PlusOfferMapView.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusOfferMapView.h"
#import "OfferTableItem.h"
#import "OfferAnnotationView.h"
#import "Routes.h"

@implementation PlusOfferMapView
{
    OfferTableItem *_selectedOfferItem;
    MKPolyline *_polyLine;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:[self.class description] owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
        
        // setup map view
        self.mapView.delegate = self;
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
//        if (IS_IPHONE5) {
//        } else {
//            [_btnUserLocation setFrame:CGRectMake(_btnUserLocation.frame.origin.x, _btnUserLocation.frame.origin.y - 90, _btnUserLocation.frame.size.height, _btnUserLocation.frame.size.width)];
//        }
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
    
    // if there is only one item in list, draw route to that item
    if (self.dataSource.count == 1) {
        if (_selectedOfferItem) {
            OfferTableItem *item = self.dataSource[0];
            [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetDirectionContext:self from:self.mapView.userLocation.coordinate to:item.coordinate];
        }
    }
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
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 5.0;
    return polylineView;
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

#pragma mark RKManageDelegate
-(void)processResultResponseArray:(NSArray *)array requestId:(int)request_id;
{
    if (request_id == ID_REQUEST_DIRECTION) {
        // get first route
        if (array.count > 0) {
            Routes *routes = array[0];
            NSString *allPolylines = [routes.overview_polyline objectForKey:@"points"];
            NSMutableArray *_path = [self decodePolyLine:allPolylines];
            NSInteger numberOfSteps = _path.count;
            CLLocationCoordinate2D coordinates[numberOfSteps];
            for (NSInteger index = 0; index < numberOfSteps; index++) {
                CLLocation *location = [_path objectAtIndex:index];
                CLLocationCoordinate2D coordinate = location.coordinate;
                
                coordinates[index] = coordinate;
            }
            
            // remove current poly line of map if any
            [self.mapView removeOverlay:_polyLine];
            // create new poly line
            _polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
            // add new poly line to map
            [self.mapView addOverlay:_polyLine];
        }
    }
    
}

// decode route
- (NSMutableArray *)decodePolyLine:(NSString *)encodedStr
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    
    while (index < len)
    {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        [array addObject:location];
    }
    
    return array;
}
@end
