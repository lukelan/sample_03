//
//  OfferDetailViewController.h
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlusOfferMapView.h"

typedef enum
{
    enumInfoPlusOfferCell = 0,
    enumDiscountCell,
    enumSlideCheckinCell,
    enumPuchCollectCell,
    enumOtherCell
}enumCellOfferDetail;

typedef enum
{
    enumOfferDetailInterfaceType_List = 0,
    enumOfferDetailInterfaceType_Map,
    enumOfferDetailInterfaceType_Num
}enumOfferDetailInterfaceType;

@interface OfferDetailViewController : CustomGAITrackedViewController <PlusOfferMapViewDelegate>
{
    ZBarReaderViewController *zBarReader;
    BOOL isScaning;
    BOOL isScanScreen;
    NSTimer *timer;
    UIView *_overlayView;
    
    PlusOfferMapView *_mapView;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewDetail;

@end
