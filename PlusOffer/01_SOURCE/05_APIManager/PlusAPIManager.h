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
-(void)RK_RequestApiGetListPlusOffer:(id)context_id;
-(void)RK_RequestApiGetListPlusOfferDetail:(id)context_id forOfferID:(NSString*)offerID;
-(void)RK_RequestApiGetListPlusOfferWithCategory:(id)context_id forCategory:(NSString*)categoryID;
-(void)RK_RequestApiGetDirectionContext:(id)context_id from:(CLLocationCoordinate2D)source to:(CLLocationCoordinate2D)destination;
-(void)RK_RequestApiCheckinContext:(id)context_id forUserID:(NSString*)userID atBanchID:(NSString *)branch_id withCoordinate:(CLLocationCoordinate2D)destination;
-(void)RK_RequestApiCheckAppVersion:(NSString *) currentVersion responseContext: (id)context_id;
-(NSDictionary*)parseToGetVersionInfo: (NSDictionary *) dicObject;
@end
