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
    #define MAPP_KEY @"MAPP_1@3Phim1@3"
    #define ROOT_FBSERVICE @"http://mapp-dev.123phim.vn/fbservice/"
    #define SERVER_SET_DEVICETOKEN @"http://mapp-dev.123phim.vn/auth?method=Device.save"
#else
    #define BASE_URL_SERVER @"https://mapp.123phim.vn/"
    #define MAPP_KEY @"MAPP_1@3Phim_IOS_920"
    #define ROOT_FBSERVICE @"https://mapp.123phim.vn/fbservice/"
    #define SERVER_SET_DEVICETOKEN @"https://mapp.123phim.vn/auth?method=Device.save"
#endif

#pragma mark
#pragma mark get city, check version
#define API_REQUEST_CITY_GET_LIST @"%@method=Location.getList"
#define API_REQUEST_APP_GET_NEW_VERSION @"%@auth?method=App.getNewsVersion&version=%@"

#pragma mark
#pragma mark function Offer
#define API_REQUEST_GET_LIST_OFFER @"%@method=Offer.getList"
#define API_REQUEST_GET_LIST_OFFER_WITH_CATEGORY @"%@method=Offer.getList&category_id=%@"
#define API_REQUEST_GET_LIST_OFFER_DETAIL @"%@method=Offer.getDetail&offer_id=%@"

#pragma mark
#pragma mark function Redeem
#define API_REQUEST_GET_LIST_REDEEM @"%@method=User.getListRedeem&user_id=%@"

#pragma mark
#pragma mark function user
#define API_REQUEST_USER_POST_LOGIN @"%@method=User.checkLogin"
#define API_REQUEST_USER_POST_UPDATE_RECEIVED_NOTIFICATION @"%@method=User.setNotification"
#define API_REQUEST_USER_GET_FB_FRIEND_LIST @"%@friends/?facebook_id=%@&access_token=%@"
#define API_REQUEST_USER_POST_LOCATION_TRACKING @"%@method=User.addLocationHistory"
#define API_REQUEST_USER_CHECKIN @"%@method=User.checkin&user_id=%@&branch_id=%@&latitude=%f&longitude=%f"

#pragma mark
#pragma mark text
#define API_REQUEST_TEXT_GET_WITH_VERSION @"%@method=Errorcode.getList&version=%@"

#pragma mark
#pragma mark log
#define API_REQUEST_LOG_POST_WRITING @"%@method=Logs.write&%@"

#define REQUEST_URL_GOOGLE_DIRECTION_API @"http://maps.googleapis.com/maps/api/directions/json"

typedef enum
{
    ID_REQUEST_PLUS_OFFER = 0,
    ID_REQUEST_REDEEM,
    ID_REQUEST_ACCOUNT,
    ID_REQUEST_DIRECTION,
    ID_REQUEST_CHECK_VERSION,
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
