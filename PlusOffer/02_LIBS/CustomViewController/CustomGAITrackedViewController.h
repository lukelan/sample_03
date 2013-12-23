//
//  CustomGAITrackedViewController.h
//  123Phim
//
//  Created by phuonnm on 5/28/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "TabBarDisplayType.h"

@interface CustomGAITrackedViewController : GAITrackedViewController <UITableViewDelegate>
{
    CGPoint _presentOffset;
    NSInteger _loadingScreenType;
    BOOL _autoShowHideTabBar;
    NSString* viewName;
    BOOL _skipUpdateTabBar;
    BOOL _tabBarHiden;
}
@property (nonatomic, assign) BOOL isSkipWarning;
@property (nonatomic, assign) TabBarDisplayType tabBarDisplayType;
@property (nonatomic, strong) NSString* viewName;
@property (nonatomic, strong) UIButton *btnNote;

-(void)hideLoadingView;
-(void)showLoadingScreenWithType:(NSInteger)type;
@end
