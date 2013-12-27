//
//  ChooseCityViewController.h
//  MovieTicket
//
//  Created by Le Ngoc Duy on 3/4/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCityViewController : CustomGAITrackedViewController<UITableViewDataSource, UITableViewDelegate, RKManagerDelegate>
{
}
@property (nonatomic, strong) UITableView* table;
@property (nonatomic, strong) NSMutableArray* listOfCity;
@property (nonatomic, strong) Location* chosenCity;
@property (nonatomic, strong) NSString* fromView;
@end
