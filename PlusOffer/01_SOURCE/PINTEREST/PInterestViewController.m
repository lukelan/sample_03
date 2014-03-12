//
//  PInterestViewController.m
//  PlusOffer
//
//  Created by Trong Vu on 3/12/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "PInterestViewController.h"
#import "FlipBoardNavigationController.h"

@interface PInterestViewController ()

@end

@implementation PInterestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushImage:(UIButton *)sender {
    UIViewController * page = [self.storyboard instantiateViewControllerWithIdentifier:@"image_vc"];
    [self.flipboardNavigationController pushViewController:page];
}

- (IBAction)pushCollection:(UIButton *)sender {
    UIViewController * page = [self.storyboard instantiateViewControllerWithIdentifier:@"collection_vc"];
    [self.flipboardNavigationController pushViewController:page];
}
@end

