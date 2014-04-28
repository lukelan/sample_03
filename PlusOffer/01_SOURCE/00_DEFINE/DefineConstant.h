//
//  DefineConstant.h
//  MovieTicket
//
//  Created by Le Ngoc Duy on 12/10/12.
//  Copyright (c) 2012 Phuong. Nguyen Minh. All rights reserved.
//

#ifndef MovieTicket_DefineConstant_h
#define MovieTicket_DefineConstant_h
//#define SAFE_RELEASE(p) {if (p){[p release]; p = nil;}}
// Trongvm - 29/11/2013: ARC support
#define SAFE_RELEASE(p) {}

#pragma mark -
#pragma mark define for tracking GA, maketting
#define IS_GA_ENABLE
#ifdef DEBUG
#define GA_TRACKING_ID @"UA-46861269-2"
#define LOG_APP(s...) {NSLog(@"%@",[NSString stringWithFormat:@"Plus_LOG: %@",[NSString stringWithFormat:s]]);}
#else
#define GA_TRACKING_ID @"UA-46861269-2"
#define LOG_APP(s...) ;
#endif

#define PINGREMARKETING {[GoogleConversionPing pingRemarketingWithConversionId:@"983463027" label:@"jLppCIXKgAgQ8-j51AM" screenName:viewName customParamete rs:nil];}

#pragma mark - Email key
#define UsernameKey  @"username"
#define PasswordKey  @"password"
#define HostnameKey  @"hostname"
#define FetchFullMessageKey  @"FetchFullMessageEnabled"
#define OAuthEnabledKey  @"OAuth2Enabled"

#pragma mark - FONT

#define FONT_NAME @"Helvetica"
#define FONT_BOLD_NAME @"Helvetica-Bold"
//#define FONT_ROBOTOCONDENSED_REGULAR @"UVFTypoSlabserif-Light"
//#define FONT_AVENIR_NEXT @"Avenir Next"

#define FONT_ROBOTOCONDENSED_REGULAR @"RobotoCondensed-Regular"
#define FONT_ROBOTOCONDENSED_LIGHT @"RobotoCondensed-Light"

#pragma mark define key store in NSUserDefault
//Define key store in app setting
#define KEY_STORE_MY_USER_ID @"USER_ID"
#define KEY_STORE_MY_DEVICE_TOKEN @"DEVICE_TOKEN"
#define KEY_STORE_USER_EMAIL @"EMAIL"
#define KEY_STORE_USER_PHONE @"PHONE"
#define KEY_STORE_TIMESTAMP_PUNCH @"TIMESTAMP_PUNCH"
#define KEY_STORE_PUNCH_KEY @"PUNCH_KEY"
#pragma mark -

#pragma mark -
#pragma mark define standard size for tabbar, titlebar, navigationbar ios
#define TITLE_BAR_HEIGHT 20 //[UIApplication sharedApplication].statusBarFrame.size.height)
#define NAVIGATION_BAR_HEIGHT 44
#define TAB_BAR_HEIGHT 44
#define MARGIN_CELLX_GROUP 10
#pragma mark -

//Define for keyboard rect
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

#pragma mark -
#pragma mark - View name track ga
#define ACCOUNT_VIEW_NAME @"UIAccount"
#define REDEEM_VIEW_NAME @"UIRedeem"
#define REDEEM_DETAIL_VIEW_NAME @"UIRedeemDetailViewController"
#define PLUS_VIEW_CONTROLLER @"UIPlusViewController"
#define OFFER_DETAIL_VIEW_CONTROLLER @"UIOfferDetailViewController"
#define CHOOSE_CITY_VIEW_NAME @"UIChooseLocation"
#define VERSION_NOTIFICATION_VIEW_NAME @"UIVersionNotification"
#pragma mark -

typedef enum
{
    TAB_PLUS = 0,
    TAB_REDEEM,
    TAB_ACCOUNT,
    TAB_ORTHER
}ENUM_TAB_INDEX;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef enum{
    UpdateLocationTypeForce = 0,
    UpdateLocationTypeAuto
} UpdateLocationType;


#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0) //rotate
#define kSqliteFileName @"PlusOfferModel"
#define BUNDLE_PATH ([[NSBundle mainBundle] bundlePath])
#define CACHE_IMAGE_PATH ([NSString stringWithFormat:@"%@/images/",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]])
#endif

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define CHECK_IOS (IOS_VERSION >= 7.0 ? TITLE_BAR_HEIGHT : 0 )
#define MAXIMUM_SCALEABLE_RADIUS_METERS                                     5000000
#define MINIMUM_DISTANCE_ALLOW_USER_REDEEM                                  100.0f // in 100 meters

//Xanh lá: #8ed400
//Xám: #9f9f9f
//Background: #e4eef0
//Text đậm: #333333
//Text nhạt: #666666
#define APP_ITUNES_LINK @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=615186197"

// Define Notification
#define NOTIFICATION_NAME_PLUSOFFER_GPS_USER_LOCATION_DID_RECEIVE @"NOTIFICATION_NAME_PLUSOFFER_GPS_USER_LOCATION_DID_RECEIVE"
#define NOTIFICATION_NAME_APP_BECOME_ACTICE @"NOTIFICATION_NAME_APP_BECOME_ACTICE"
#define NOTIFICATION_NAME_BRAND_DID_LOAD_RECEIVE @"NOTIFICATION_NAME_BRAND_DID_LOAD_RECEIVE"
#define NOTIFICATION_BOOKMARK_ACTIVE @"NOTIFICATION_BOOKMARK_ACTIVE"
#define NOTIFICATION_INFO_USER_PUNCH @"NOTIFICATION_INFO_USER_PUNCH"
