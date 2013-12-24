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

@interface PlusOfferViewController : CustomGAITrackedViewController <PlusOfferListViewDelegate, PlusOfferMapViewDelegate>
{
    // List view
    PlusOfferListView *_listView;
    // Mapview
    PlusOfferMapView *_mapView;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewTypeBtn;

- (IBAction)listBtnTouchUpInside:(UIBarButtonItem *)sender;
@end
