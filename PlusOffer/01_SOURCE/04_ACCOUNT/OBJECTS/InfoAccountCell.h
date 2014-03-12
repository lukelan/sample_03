//
//  InfoAccountCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/21/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoAccountCell : UITableViewCell
@property (strong, nonatomic)  UIView *containerView;
@property (strong, nonatomic)  UIView *containerViewSetting;
@property (strong, nonatomic)  UIView *containerViewInfo;
@property (strong, nonatomic)  SDImageView *imageBgAccount;
@property (strong, nonatomic)  SDImageView *avatarImageView;
@property (strong, nonatomic)  UILabel *nameLbl;
@property (strong, nonatomic)  UILabel *nickNameLbl;
@property (strong, nonatomic)  UILabel *titleBtNotification;
@property (strong, nonatomic)  SDImageView *imageBtNotification;
@property (strong, nonatomic)  UIButton *btNotification;
@property (strong, nonatomic)  UILabel *titleBtHistory;
@property (strong, nonatomic)  SDImageView *imageBtHistory;
@property (strong, nonatomic)  UIButton *btHistory;
@property (strong, nonatomic)  UILabel *titleBtSetting;
@property (strong, nonatomic)  SDImageView *imageBtSetting;
@property (strong, nonatomic)  UIButton *btSetting;
@end
