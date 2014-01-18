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
    enumDescription,
    enumOtherCell
}enumCellOfferDetail;

typedef enum
{
    enumOfferDetailInterfaceType_List = 0,
    enumOfferDetailInterfaceType_Map,
    enumOfferDetailInterfaceType_Num
}enumOfferDetailInterfaceType;

@interface OfferDetailViewController : CustomGAITrackedViewController <PlusOfferMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    ZBarReaderViewController *zBarReader;
    BOOL isScaning;
    BOOL isScanScreen;
    NSTimer *timer;
    UIView *_overlayView;
    
    PlusOfferMapView *_mapView;
    BOOL isShowingMap;
}

@property (nonatomic, retain) NSString *offer_id;
@property (nonatomic, retain) NSString *detailDistance;
@property (nonatomic, retain) NSString *brandName;
@property (nonatomic, retain) NSString *brand_id;
@property (nonatomic, strong) NSMutableArray *arrayMenu;
@property (nonatomic) float heightDescription;
@property (nonatomic) BOOL checkHeightDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnPunch;
- (IBAction)processActionPunch:(id)sender;
- (IBAction)processActionAdd:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableViewDetail;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@end
