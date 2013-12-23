//
//  CustomViewController.m
//  123Phim
//
//  Created by phuonnm on 5/28/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import "CustomViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomUIResponder.h"
#import "CustomViewControllerDefines.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

@synthesize tabBarDisplayType = _tabBarDisplayType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _skipUpdateTabBar = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *array = self.navigationController.viewControllers;
    if (array.count > 1)
    {
        UIViewController *last = [array lastObject];
        if (last == self)
        {
//            [self setCustomBarLeftWithImage:nil selector:nil context_id:nil];
        }
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentView = viewName;
    if (_loadingScreenType != 0)
    {
        //        show loading screen
        if (_loadingScreenType < 0)
        {
            _loadingScreenType = -_loadingScreenType;
        }
        [self showLoadingView];
    }
    else
    {
        //        hide loading screen
        [self hideLoadingView];
    }
    //        processing tab bar
    if (_tabBarDisplayType == TAB_BAR_DISPLAY_HIDE)
    {
        [self performHideTabBar];
    }
    else
    {
        [self performShowTabBar];
    }
    
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //        processing tab bar
    if (_tabBarDisplayType == TAB_BAR_DISPLAY_HIDE)
    {
        [self performHideTabBar];
    }
    else
    {
        [self performShowTabBar];
    }
}

-(void) showLoadingView
{
    CustomUIResponder *app = (CustomUIResponder *)[[UIApplication sharedApplication] delegate];
    [app showLoadingViewWithType:_loadingScreenType viewOnTop:self.view];
}

-(void) hideLoadingView
{
    _loadingScreenType = 0;
    CustomUIResponder *app = (CustomUIResponder *)[[UIApplication sharedApplication] delegate];
    [app hideLoadingViewForViewOnTop:self.view];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_loadingScreenType > 0)
    {
        //        hide loading screen
        NSInteger tmp = -_loadingScreenType;
        [self hideLoadingView];
        _loadingScreenType = tmp;
    }
    [super viewWillDisappear:animated];
}

-(void)showLoadingScreenWithType:(NSInteger)type
{
    if (_loadingScreenType == type)
    {
        return;
    }
    
    _loadingScreenType = type;
    
    if (_loadingScreenType)
    {
        [self showLoadingView];
    }
    else
    {
        [self hideLoadingView];
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_tabBarDisplayType != TAB_BAR_DISPLAY_AUTO)
    {
        return;
    }
    CGSize contentSize = scrollView.contentSize;
    if (contentSize.height < scrollView.frame.size.height * SIZE_RATE_TO_AUTO_SHOW_OR_HIDE_TAB_BAR)
    {
        _autoShowHideTabBar = NO;
        [self performHideTabBar];
        return;
    }
    _autoShowHideTabBar = YES;
    _presentOffset = scrollView.contentOffset;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _skipUpdateTabBar = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_autoShowHideTabBar || _skipUpdateTabBar)
    {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    if (offset.y - _presentOffset.y < 0)
    {
        [self performShowTabBar];
    }
    else
    {
        [self performHideTabBar];
    }
    _presentOffset = scrollView.contentOffset;
    _skipUpdateTabBar = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_autoShowHideTabBar)
    {
        return;
    }
    _skipUpdateTabBar = NO;
    _presentOffset = scrollView.contentOffset;
}

-(void)setTabBarDisplayType:(TabBarDisplayType)hideTabBarDisplayType
{
    _tabBarDisplayType = hideTabBarDisplayType;
    if (hideTabBarDisplayType == TAB_BAR_DISPLAY_AUTO)
    {
        _autoShowHideTabBar = NO;
    }
}

@end
