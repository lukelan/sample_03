//
//  UIViewController+TabBarAnimation.m
//  ADN
//
//  Created by Le Ngoc Duy on 11/28/13.
//  Copyright (c) 2013 Le Ngoc Duy. All rights reserved.
//

#import "UIViewController+TabBarAnimation.h"

@implementation UIViewController (TabBarAnimation)

- (void)performShowTabBar
{
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y --;
    if (frame.origin.y == self.tabBarController.tabBar.window.frame.size.height)
    {
        frame.origin.y -= frame.size.height;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.tabBarController.tabBar.frame = frame;
            
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)performHideTabBar
{
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y += frame.size.height;
    if (frame.origin.y == self.tabBarController.tabBar.window.frame.size.height)
    {
        frame.origin.y++;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.tabBarController.tabBar.frame = frame;
        } completion:^(BOOL finished) {
        }];
    }
}


- (void)performHideNavigatorBar
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y == TITLE_BAR_HEIGHT)
    {
        frame.origin.y -= (frame.size.height + 1 + TITLE_BAR_HEIGHT) ;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.navigationController.navigationBar.frame = frame;
            
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)performShowNavigatorBar
{
    CGRect frame = self.navigationController.navigationBar.frame;
    frame.origin.y += frame.size.height + 1 + TITLE_BAR_HEIGHT;
    if (frame.origin.y == TITLE_BAR_HEIGHT)
    {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.navigationController.navigationBar.frame = frame;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)performHideTabBarIOS6:(UITabBarController *) tabbarcontroller
{
    int height =   (IS_IPHONE5 ? 568 : 480 );
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, height, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height)];
        }
    }
    
    [UIView commitAnimations];
}
- (void)performShowTabBarIOS6:(UITabBarController *) tabbarcontroller
{
    int height =   (IS_IPHONE5 ? 521  : 433 );
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, height, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height)];
        }
    }
    [UIView commitAnimations];
}
@end
