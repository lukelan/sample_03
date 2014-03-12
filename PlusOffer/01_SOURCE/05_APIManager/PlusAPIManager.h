//
//  PlusAPIManager.h
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreAPIManager.h"

@interface PlusAPIManager : CoreAPIManager
-(void)RK_RequestApiGetListPlusOfferContext:(id)context_id;
-(void)RK_RequestApiGetListPlusOfferRedeem:(id)context_id forUserID:(NSString*)userID;
-(void)RK_RequestApiGetListPlusOffer:(id)context_id forUserID:(NSString*)userID;
-(void)RK_RequestApiGetListPlusOfferDetail:(id)context_id forOfferID:(NSString*)offerID forUserID:(NSString*)userID;
-(void)RK_RequestApiGetListPlusOfferWithCategory:(id)context_id forCategory:(NSString*)categoryID forUserID:(NSString*)userID;
-(void)RK_RequestApiGetDirectionContext:(id)context_id from:(CLLocationCoordinate2D)source to:(CLLocationCoordinate2D)destination;
-(void)RK_RequestApiCheckinContext:(id)context_id forUserID:(NSString*)userID atBanchID:(NSString *)branch_id withCoordinate:(CLLocationCoordinate2D)destination;
-(void)RK_RequestApiCheckAppVersion:(NSString *) currentVersion responseContext: (id)context_id;
-(NSDictionary*)parseToGetVersionInfo: (NSDictionary *) dicObject;
- (void)RK_RequestAPIGetListBrandContext:(id)context_id;
-(void)RK_RequestPostUIID:(NSString *)udid andDeviceToken:(NSString *)device_token context:context_id;
-(void)RK_RequestApiGetListItemMenu:(id)context_id forBrand_id:(NSString*)brand_id;
- (void)RK_RequestPunchUser:(NSString *)userId atBrand:(NSString *)brand_id withCode:(NSString *)punch_code numberOfPunch:(NSNumber *)punch_count context:(id)context;
-(void)RK_RequestApiGetListFavorite:(id)context_id forUserID:(NSString*)userId;
-(void)RK_RequestApiAddFavorite:(id)context_id forUserID:(NSString*)userId forOfferID:(NSString*)offer_id;
-(void)RK_RequestApiRemoveFavorite:(id)context_id forUserID:(NSString*)userId forOfferID:(NSString*)offer_id;
-(void)RK_RequestApiResetPunch:(id)context_id forUserID:(NSString*)userID atBanchID:(NSString *)branch_id;
// branch
-(void)RK_RequestApiGetListBranch:(id)context_id ofBrand:(NSString*)brand_id;
@end
