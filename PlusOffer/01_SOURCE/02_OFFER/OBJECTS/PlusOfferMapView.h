//
//  PlusOfferMapView.h
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol PlusOfferMapViewDelegate <NSObject>



@end

@interface PlusOfferMapView : UIView <MKMapViewDelegate, RKManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *btnUserLocation;

@property (nonatomic, weak) id<PlusOfferMapViewDelegate> delegate;
@property (nonatomic, weak) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIView *infoView;

- (IBAction)showUserLocation:(id)sender;
-(void)reloadInterface:(NSMutableArray*)listOffers;
@end
