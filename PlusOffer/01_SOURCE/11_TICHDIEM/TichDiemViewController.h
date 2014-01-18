//
//  TichDiemViewController.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/8/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TichDiemViewController :  CustomGAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
{
    ZBarReaderViewController *zBarReader;
    BOOL isScaning;
    BOOL isScanScreen;
    NSTimer *timer;
    UIView *_overlayView;
    
    CGFloat _punchCardCellHeight;
}
@property (nonatomic) int currentIndex;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@end
