//
//  VersionNotificationViewController.m
//  123Phim
//
//  Created by phuonnm on 4/8/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import "VersionNotificationViewController.h"

@interface VersionNotificationViewController ()

@end

@implementation VersionNotificationViewController
@synthesize canSkip = _canSkip;
@synthesize dismissWhenSkip = _dismissWhenSkip;
@synthesize imageLink = _imageLink;

-(void)dealloc
{
    _imageView = nil;
    _queue = nil;
    _imageLink = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _canSkip = YES;
        _dismissWhenSkip = NO;
        viewName = VERSION_NOTIFICATION_VIEW_NAME;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    UIButton* btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnUpdate.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width / 2, 40);
    [btnUpdate addTarget:self action:@selector(handleUpdateVersion) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(0, 0, 320, 420);
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _queue=[NSOperationQueue new];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImageInBackground) object:nil];
    [_queue addOperation:operation];

    [self.view addSubview:_imageView];
    if (_canSkip)
    {
        [btnUpdate setBackgroundImage:[UIImage imageNamed:@"update_button.png"] forState:UIControlStateNormal];
        UIButton *btnClose = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        UIImage *closeImage = [UIImage imageNamed:@"close.png"];
        [btnClose setBackgroundImage:closeImage forState:UIControlStateNormal];
        frame = CGRectZero;
        frame.size = closeImage.size;
        frame.origin.x = self.view.frame.size.width - frame.size.width - 5;
        frame.origin.y = 5;
        [btnClose addTarget:self action:@selector(startApp:) forControlEvents:UIControlEventTouchUpInside];
        btnClose.frame = frame;
        [self.view addSubview:btnClose];
        UIButton *btnSkip = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
        UIImage *skipImage = [UIImage imageNamed:@"skip.png"];
        [btnSkip setBackgroundImage:skipImage forState:UIControlStateNormal];
        frame = btnUpdate.frame;
        frame.origin.x = frame.size.width;
        [btnSkip addTarget:self action:@selector(startApp:) forControlEvents:UIControlEventTouchUpInside];
        btnSkip.frame = frame;
        [self.view addSubview:btnSkip];
    }
    else
    {
        [btnUpdate setBackgroundImage:[UIImage imageNamed:@"update_force_button.png"] forState:UIControlStateNormal];
        frame = btnUpdate.frame;
        frame.size.width = self.view.frame.size.width;
        btnUpdate.frame = frame;
    }
    [self.view addSubview:btnUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Duydph - 04/12/2013 - Add Remarketing Code
//    PINGREMARKETING
}
- (void)handleUpdateVersion
{
    NSURL *url = [NSURL URLWithString:APP_ITUNES_LINK];
    [[UIApplication sharedApplication] openURL:url];
}

-(void) startApp: (id) object
{

    if (_dismissWhenSkip)
    {
        [self dismissViewControllerAnimated:YES completion:^{
    }];
        
    }
    else
    {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app handleUserAccount];
    }
}

-(void)loadImageInBackground
{
    NSURL *url = [NSURL URLWithString:_imageLink];
    NSData *imgData=[[NSData alloc]initWithContentsOfURL:url];
    
    //    callback to set poster image
    UIImage *image = [UIImage imageWithData:imgData];
    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}

-(void)setImage:(UIImage*) image
{
    _imageView.image = image;
}
@end
