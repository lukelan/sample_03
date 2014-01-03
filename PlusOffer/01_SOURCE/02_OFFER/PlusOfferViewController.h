//
//  PlusOfferViewController.h
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlusOfferListView.h"
#import "PlusOfferMapView.h"

typedef enum
{
    enumOfferInterfaceType_List = 0,
    enumOfferInterfaceType_Map,
    enumOfferInterfaceType_Num
}enumOfferInterfaceType;

typedef enum
{
    ENUM_PLUS_OFFER_CATEGORY_GETLIST = 0,
    ENUM_PLUS_OFFER_CATEGORY_CUISINE,
    ENUM_PLUS_OFFER_CATEGORY_ENTERTAINMENT,
}ENUM_PLUS_OFFER_CATEGORY_TYPE;

@interface PlusOfferViewController : CustomGAITrackedViewController <PlusOfferListViewDelegate, PlusOfferMapViewDelegate>
{
    // List view
    PlusOfferListView *_listView;
    // Mapview
    PlusOfferMapView *_mapView;
    // Last state
    enumOfferInterfaceType _vcType;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *viewTypeBtn;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentPlusOffers;
@property BOOL checkListOrMap;
- (IBAction)btSegmented:(id)sender;

- (IBAction)listBtnTouchUpInside:(UIBarButtonItem *)sender;
@end
