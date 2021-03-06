//
//  FaceBookHandler.h
//  123Phim
//
//  Created by phuonnm on 3/6/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//
#define LOGIN_FB_BY_WEB //active function like fanpage only active login by web

#define NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_BEGIN_LOGIN @"NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_BEGIN_LOGIN"
#define NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOGIN @"NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOGIN"
#define NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOGIN_FAIL @"NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOGIN_FAIL"
#define NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_BEGIN_GET_INFO @"NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_BEGIN_GET_INFO"
#define NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOAD_SUCCESFUL @"NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOAD_SUCCESFUL"
#define NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOAD_FAIL @"NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOAD_FAIL"
#define NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOAD_AVATAR @"NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_LOAD_AVATAR"
#define NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_DID_LOGOUT @"NOTIFICATION_NAME_FACEBOOK_ACCOUNT_INFO_DID_DID_LOGOUT"

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookHandler : NSObject

+ (id)shareMySingleton;
- (BOOL)initFacebookSession;
- (void)loginFacebook:(id)context selector:(SEL)selector;
- (void)loginFacebookWithResponseContext:(id)context selector:(SEL)selector;
- (void)loginFacebookWithResponseContext:(id)context selector:(SEL)selector switchUser:(BOOL)switchUser getUserInfo: (BOOL) getUserInfo;
- (void)getFacebookAccountInfoWithResponseContext:(id)context selector:(SEL)selector;
-(void)logout;
@end
