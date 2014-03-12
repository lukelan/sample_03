//
//  APIDefines.h
//  MovieTicket
//
//  Created by Phuong. Nguyen Minh on 12/7/12.
//  Copyright (c) 2012 Phuong. Nguyen Minh. All rights reserved.
//

#ifndef MovieTicket_APIDefines_h
#define MovieTicket_APIDefines_h

#define API_LINK
#define GOOGLE_API_LINK
#define FACEBOOK_API_LINK


#pragma mark
#pragma mark server config
#define ROOT_SERVER ([NSString stringWithFormat:@"%@%@",BASE_URL_SERVER,MSERVICE_API])
#define IS_TEST 0//Khi build len app store nho xoa key nay
#define MSERVICE_API @"?"
#ifdef DEBUG
    #define BASE_URL_SERVER @"http://plusoffer-api-dev.123phim.vn/"
    #define MAPP_KEY @"P1u50ff3R-dev"
#else
    #define BASE_URL_SERVER @"https://plusoffer-api.123phim.vn/"
    #define MAPP_KEY @"P1u50ff3R2014@0.0"
#endif

#define API_REQUEST_SET_DEVICETOKEN @"%@method=Device.setToken"
#pragma mark
#pragma mark get city, check version
#define API_REQUEST_CITY_GET_LIST @"%@method=Location.getList"
#define API_REQUEST_APP_GET_NEW_VERSION @"%@auth?method=App.getNewsVersion&version=%@"

#pragma mark
#pragma mark function Offer
#define API_REQUEST_GET_LIST_OFFER @"%@method=Offer.getList&user_id=%@"
//#define API_REQUEST_GET_LIST_OFFER @"%@method=Offer.getList"
#define API_REQUEST_GET_LIST_OFFER_WITH_CATEGORY @"%@method=Offer.getList&category_id=%@&user_id=%@"
#define API_REQUEST_GET_LIST_OFFER_DETAIL @"%@method=Offer.getDetail&offer_id=%@&user_id=%@"

#pragma mark menu item
#define API_REQUEST_GET_LIST_MENU_WITH_BRAND @"%@method=Menu.getListItem&brand_id=%@"
#pragma mark
#pragma mark function Redeem
#define API_REQUEST_GET_LIST_REDEEM @"%@method=User.getListRedeem&user_id=%@"

#pragma mark -
#pragma mark get brand info
#define API_REQUEST_GET_LIST_BRAND @"%@method=Brand.getListCard&user_id=%@"
#define API_REQUEST_GET_LIST_BRANCH @"%@method=Branch.getList"

#pragma mark
#pragma mark function user
#define API_REQUEST_USER_PUNCH @"%@method=User.punch"//user_id, offer_id,punch_code
#define API_REQUEST_USER_POST_LOGIN @"%@method=User.checkLogin"
#define API_REQUEST_USER_POST_UPDATE_RECEIVED_NOTIFICATION @"%@method=User.setNotification"
#define API_REQUEST_USER_GET_FB_FRIEND_LIST @"%@friends/?facebook_id=%@&access_token=%@"
#define API_REQUEST_USER_POST_LOCATION_TRACKING @"%@method=User.addLocationHistory"
#define API_REQUEST_USER_CHECKIN @"%@method=User.checkin&user_id=%@&branch_id=%@&latitude=%f&longitude=%f"
#define API_REQUEST_RESET_PUNCH @"%@method=User.resetPunch&user_id=%@&brand_id=%@"

#pragma mark
#pragma mark text
#define API_REQUEST_TEXT_GET_WITH_VERSION @"%@method=Errorcode.getList&version=%@"

#pragma mark
#pragma mark log
#define API_REQUEST_LOG_POST_WRITING @"%@method=Logs.write&%@"

#define REQUEST_URL_GOOGLE_DIRECTION_API @"http://maps.googleapis.com/maps/api/directions/json"
#pragma mark
#pragma mark Favorite
#define API_REQUEST_GET_LIST_FAVORITE @"%@method=Offer.getListBookmark&user_id=%@"
#define API_REQUEST_ADD_FAVORITE @"%@method=Offer.addBookmark"
#define API_REQUEST_REMOVE_FAVORITE @"%@method=Offer.removeBookmark"

typedef enum
{
    ID_REQUEST_PLUS_OFFER = 0,
    ID_REQUEST_REDEEM,
    ID_REQUEST_ACCOUNT,
    ID_REQUEST_DIRECTION,
    ID_REQUEST_CHECK_VERSION,
    ID_REQUEST_LIST_BRAND,
    ID_POST_UDID_DEVICE_TOKEN,
    ID_REQUEST_STORE_USER_LOCATION,
    ID_REQUEST_USER_PUNCH,
    ID_REQUEST_ADD_FAVORITE,
    ID_REQUEST_REMOVE_FAVORITE,
    ID_REQUEST_RESET_PUNCH,
    ID_REQUEST_OTHER
}ENUM_ID_REQUEST_TYPE;

///////////////////////////////////////////////////////////////////////////
//////////////////////////       API LINKS       //////////////////////////
///////////////////////////////////////////////////////////////////////////
#pragma mark - API Links
#define STRING_REQUEST_URL_POST_LOG                                 [NSString stringWithFormat:@"%@method=Logs.write&", ROOT_SERVER]
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

#endif
