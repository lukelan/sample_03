//
//  RedeemDetailViewController.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 12/27/13.
//  Copyright (c) 2013 Trong Vu. All rights reserved.
//

#import "RedeemDetailViewController.h"
@interface RedeemDetailViewController ()

@end

@implementation RedeemDetailViewController

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
    viewName = REDEEM_DETAIL_VIEW_NAME;
    self.trackedViewName = viewName;
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    PINGREMARKETING
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
