//
//  PlusOfferViewController.m
//  PlusOffer
//
//  Created by Trongvm on 12/22/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusOfferViewController.h"

@interface PlusOfferViewController ()

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
    [self loadInterface:enumOfferInterfaceType_Map];
    viewName = PLUS_VIEW_CONTROLLER;
    self.trackedViewName = viewName;
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
            
            [self.view addSubview:_listView];
            
            break;
        }
        case enumOfferInterfaceType_Map:
        {
            if (!_mapView) {
                _mapView = [[PlusOfferMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 455)];
            }
            
            if (_listView) [_listView removeFromSuperview];
            
            [self.view addSubview:_mapView];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Actions

- (IBAction)listBtnTouchUpInside:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"List"]) {
        [sender setTitle:@"Map"];
        [self loadInterface:enumOfferInterfaceType_Map];
    }
    else {
        [sender setTitle:@"List"];
        [self loadInterface:enumOfferInterfaceType_List];
    }
}
@end
