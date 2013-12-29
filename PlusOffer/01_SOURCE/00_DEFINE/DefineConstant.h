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
#define GA_TRACKING_ID @"UA-39785275-1"
#define LOG_APP(s...) {NSLog(@"%@",[NSString stringWithFormat:@"Plus_LOG: %@",[NSString stringWithFormat:s]]);}
#else
#define GA_TRACKING_ID @"UA-39785275-1"
#define LOG_APP(s...) ;
#endif
#define PINGREMARKETING {[GoogleConversionPing pingRemarketingWithConversionId:@"983463027" label:@"jLppCIXKgAgQ8-j51AM" screenName:viewName customParameters:nil];}
#pragma mark -

#define FONT_NAME @"Helvetica"
#define FONT_BOLD_NAME @"Helvetica-Bold"

#pragma mark -
#pragma mark define key store in NSUserDefault
//Define key store in app setting
#define KEY_STORE_MY_USER_ID @"USER_ID"
#define KEY_STORE_MY_DEVICE_TOKEN @"DEVICE_TOKEN"
#define KEY_STORE_USER_EMAIL @"EMAIL"
#define KEY_STORE_USER_PHONE @"PHONE"
#pragma mark -

#pragma mark -
#pragma mark define standard size for tabbar, titlebar, navigationbar ios
#define TITLE_BAR_HEIGHT 20 //[UIApplication sharedApplication].statusBarFrame.size.height)
#define NAVIGATION_BAR_HEIGHT 44
#define TAB_BAR_HEIGHT 44
#pragma mark -

//Define for keyboard rect
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

#pragma mark -
#pragma mark - View name track ga
#define ACCOUNT_VIEW_NAME @"UIAccount"
#define REDEEM_VIEW_NAME @"UIRedeem"
#define PLUS_VIEW_CONTROLLER @"UIPlusViewController"
#define OFFER_DETAIL_VIEW_CONTROLLER @"UIOfferDetailViewController"
#define CHOOSE_CITY_VIEW_NAME @"UIChooseLocation"
#pragma mark -

typedef enum
{
    TAB_PLUS = 0,
    TAB_REDEEM,
    TAB_ACCOUNT,
    TAB_ORTHER
}ENUM_TAB_INDEX;

typedef enum{
    UpdateLocationTypeForce = 0,
    UpdateLocationTypeAuto
} UpdateLocationType;


#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0) //rotate
#define kSqliteFileName @"CoreDataPlus"
#define BUNDLE_PATH ([[NSBundle mainBundle] bundlePath])
#define CACHE_IMAGE_PATH ([NSString stringWithFormat:@"%@/images/",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]])
#endif


#define MAXIMUM_SCALEABLE_RADIUS_METERS                                     5000000

