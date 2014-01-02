//
//  UserProfile.h
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/30/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) UIImage  *avatarImage;
@property (nonatomic, strong) NSString *zing_id;
@property (nonatomic, strong) NSString *facebook_id;
@property (nonatomic, strong) NSString *gender;
@end
