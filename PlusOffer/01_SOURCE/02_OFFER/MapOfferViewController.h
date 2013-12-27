//
//  MapOfferViewController.h
//  PlusOffer
//
//  Created by Trong Vu on 12/26/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JCGridMenuController.h"


@interface MapOfferViewController : CustomGAITrackedViewController <JCGridMenuControllerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapOfferView;
@property (nonatomic, strong) JCGridMenuController *gmDemo;

- (id)init;
- (void)open;
- (void)close;

@end
