//
//  InfoPlusOfferCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 12/27/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPlusOfferCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbtime;
@property (strong, nonatomic) IBOutlet UILabel *lblocation;
@property (strong, nonatomic) IBOutlet SDImageView *imageInfoPlus;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenMap;
- (IBAction)processOpenMapView:(id)sender;
-(void)setObject:(id)object;

@end
