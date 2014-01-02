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
@end
