//
//  PlusOfferViewController.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusOfferViewController.h"
#import "OfferTableItem.h"

@interface PlusOfferViewController ()
@property (nonatomic, retain) NSMutableArray *listOffers;
@end

@implementation PlusOfferViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    viewName = PLUS_VIEW_CONTROLLER;
    self.trackedViewName = viewName;
    
    // just for testing purpose
    self.listOffers = [NSMutableArray array];
    NSArray *images = @[@"offer_list_1.png", @"offer_list_2.png", @"offer_list_1.png"];
    for (NSString *imageURL in images)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:imageURL, @"url", @"", @"discount", @"", @"distance", nil];
        OfferTableItem *item = [[OfferTableItem alloc] initWithData:dic];
        [self.listOffers addObject:item];
    }
    
    [self loadInterface:enumOfferInterfaceType_List];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface
-(void)loadInterface:(enumOfferInterfaceType)type
{
    switch (type) {
        case enumOfferInterfaceType_List:
        {
            if (!_listView) {
                _listView = [[PlusOfferListView alloc] initWithFrame:CGRectMake(0, 65, 320, 455)];
            }
            
            if (_mapView) [_mapView removeFromSuperview];
            
            [self.viewTypeBtn setTitle:@"Map"];
            _listView.dataSource = self.listOffers;
            [self.view addSubview:_listView];
            
            break;
        }
        case enumOfferInterfaceType_Map:
        {
            if (!_mapView) {
                _mapView = [[PlusOfferMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 455)];
            }
            
            if (_listView) [_listView removeFromSuperview];
            
            [self.viewTypeBtn setTitle:@"List"];
            _mapView.dataSource = self.listOffers;
            [self.view addSubview:_mapView];
            [_mapView reloadInterface];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Actions

- (IBAction)listBtnTouchUpInside:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Map"]) {
        
        [self loadInterface:enumOfferInterfaceType_Map];
    }
    else {
        [self loadInterface:enumOfferInterfaceType_List];
    }
}
@end
