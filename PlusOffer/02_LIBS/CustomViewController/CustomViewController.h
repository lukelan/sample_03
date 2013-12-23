//
//  CustomViewController.h
//  123Phim
//
//  Created by phuonnm on 5/28/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarDisplayType.h"

@interface CustomViewController : UIViewController <UITableViewDelegate>
{
    CGPoint _presentOffset;
    NSInteger _loadingScreenType;
    BOOL _autoShowHideTabBar;
    NSString* viewName;
    BOOL _skipUpdateTabBar;
    BOOL _tabBarHiden;
}

@property (nonatomic, assign) TabBarDisplayType tabBarDisplayType;

-(void)hideLoadingView;
-(void)showLoadingScreenWithType:(NSInteger)type;
-(void)showDynamicViewWithProperties: (NSDictionary *)properties;

@end
