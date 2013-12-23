//
//  CustomUIResponder.h
//  123Phim
//
//  Created by phuonnm on 5/29/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//
typedef NS_ENUM(NSInteger, LoadingType)
{
    LOADING_TYPE_FULLSCREEN = 1,
    LOADING_TYPE_WITHOUT_NAVIGATOR,
    LOADING_TYPE_WITHOUT_TABBAR,
    LOADING_TYPE_WITHOUT_NAVIGATOR_AND_TABBAR
};

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface CustomUIResponder : UIResponder <UIApplicationDelegate>
{
    LoadingView * _loadingView;
}

@property (nonatomic,strong) UITabBarController *tabBarController;

- (void)showLoadingViewWithType: (NSInteger) type viewOnTop: (UIView*) view;
- (void)hideLoadingViewForViewOnTop: (UIView*) view;
@end
