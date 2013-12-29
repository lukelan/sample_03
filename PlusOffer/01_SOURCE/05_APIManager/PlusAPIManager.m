//
//  PlusAPIManager.m
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusAPIManager.h"
#import "RedeemModel.h"

@implementation PlusAPIManager
#pragma mark API request with restkit
-(void)RK_RequestApiGetListPlusOfferContext:(id)context_id
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_CITY_GET_LIST,ROOT_SERVER];
    //---------------------------------//
    RKObjectMapping *location = [RKObjectMapping mappingForClass:[Location class]];
    [location addAttributeMappingsFromDictionary:@{
                                                   @"location_id" : @"location_id",
                                                   @"name" : @"location_name",
                                                   @"location_name" : @"center_name",
                                                   @"latitude" : @"latitude",
                                                   @"longitude" : @"longtitude"
                                                   }];
    RKResponseDescriptor *locationDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:location method:RKRequestMethodAny pathPattern:nil keyPath:@"result" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self RK_SendRequestAPI_Descriptor:locationDescriptor withURL:[NSURL URLWithString:[self getFullLinkAPI:url]] postData:nil keyPost:nil withContext:context_id requestId:-1];
}

-(void)RK_RequestApiGetListPlusOfferRedeem:(id)context_id forUserID:(NSString*)userID;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_REDEEM,ROOT_SERVER, userID];

    
    RKEntityMapping *ticketMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([RedeemModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    ticketMapping.identificationAttributes = @[@"redeem_id"];
    [ticketMapping addAttributeMappingsFromDictionary:@{
                                                        @"redeem_id" : @"redeem_id",
                                                        @"offer_id" : @"offer_id",
                                                        @"brand_id" : @"brand_id",
                                                        @"branch_id" : @"branch_id",
                                                        @"offer_name" : @"offer_name",
                                                        @"offer_description" : @"offer_description",
                                                        @"offer_content" : @"offer_content",
                                                        @"brand_name" : @"brand_name",
                                                        @"branch_name" : @"branch_name",
                                                        @"latitude" : @"latitude",
                                                        @"longitude" : @"longitude",
                                                        @"count_punch" : @"count_punch",
                                                        @"max_punch" : @"max_punch",
                                                        @"is_redeem" : @"is_redeem",
                                                        @"is_redeemable" : @"is_redeemable"
                                                        }];
    
    [self RK_RequestApi_EntityMapping:ticketMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}
@end
