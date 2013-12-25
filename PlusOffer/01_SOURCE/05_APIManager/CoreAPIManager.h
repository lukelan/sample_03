//
//  APIManager.h
//  MovieTicket
//
//  Created by Le Ngoc Duy on 9/25/13.
//  Copyright (c) 2012 Phuong. Nguyen Minh. All rights reserved.
//
#import "DictionaryMapping.h"
#import "ArrayMapping.h"

@protocol RKManagerDelegate <NSObject>

@optional
-(void)processResultResponseDictionaryMapping:(DictionaryMapping *)dictionary requestId:(int)request_id;
-(void)processResultResponseArrayMapping:(ArrayMapping *)array requestId:(int)request_id;
//Return array of object declare in source
-(void)processResultResponseArray:(NSArray *)array requestId:(int)request_id;
-(void)processFailedRequestId:(int)request_id;
@end

@interface CoreAPIManager : NSObject<RKManagerDelegate>
{
}
#pragma mark using for communicate with server
+(CoreAPIManager*)sharedAPIManager;
-(void)RK_RequestApiGetListPlusOfferContext:(id)context_id;
@end
