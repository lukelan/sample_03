//
//  PlusAPIManager.m
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusAPIManager.h"
#import "RedeemModel.h"
#import "OfferModel.h"
#import "OfferDetailModel.h"

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
-(void)RK_RequestApiGetListPlusOffer:(id)context_id;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_OFFER,ROOT_SERVER];
    
    
    RKEntityMapping *ticketMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([OfferModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    ticketMapping.identificationAttributes = @[@"offer_id"];
    [ticketMapping addAttributeMappingsFromDictionary:@{
                                                        @"offer_id" : @"offer_id",
                                                        @"brand_id" : @"brand_id",
                                                        @"branch_id" : @"branch_id",
                                                        @"offer_name" : @"offer_name",
                                                        @"latitude" : @"latitude",
                                                        @"longitude" : @"longitude",
                                                        @"count_punch" : @"count_punch",
                                                        @"category_id" : @"category_id",
                                                        @"discount_type" : @"discount_type",
                                                        @"discount_value" : @"discount_value",
                                                        @"date_add" : @"date_add"
                                                        }];
    
    [self RK_RequestApi_EntityMapping:ticketMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}
-(void)RK_RequestApiGetListPlusOfferWithCategory:(id)context_id forCategory:(NSString*)categoryID;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_OFFER_WITH_CATEGORY,ROOT_SERVER,categoryID];
    
    RKEntityMapping *ticketMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([OfferModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    ticketMapping.identificationAttributes = @[@"offer_id"];
    [ticketMapping addAttributeMappingsFromDictionary:@{
                                                        @"offer_id" : @"offer_id",
                                                        @"brand_id" : @"brand_id",
                                                        @"branch_id" : @"branch_id",
                                                        @"offer_name" : @"offer_name",
                                                        @"latitude" : @"latitude",
                                                        @"longitude" : @"longitude",
                                                        @"count_punch" : @"count_punch",
                                                        @"category_id" : @"category_id",
                                                        @"discount_type" : @"discount_type",
                                                        @"discount_value" : @"discount_value",
                                                        @"date_add" : @"date_add"
                                                        }];
    
    [self RK_RequestApi_EntityMapping:ticketMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}

-(void)RK_RequestApiGetListPlusOfferDetail:(id)context_id forOfferID:(NSString*)offerID;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_OFFER_DETAIL,ROOT_SERVER,offerID];
    
    
    RKEntityMapping *ticketMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([OfferDetailModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    ticketMapping.identificationAttributes = @[@"offer_id"];
    [ticketMapping addAttributeMappingsFromDictionary:@{
                                                        @"offer_id" : @"offer_id",
                                                        @"offer_name" :@"offer_name",
                                                        @"brand_id" : @"brand_id",
                                                        @"branch_id" : @"branch_id",
                                                        @"category_id" : @"category_id",
                                                        @"offer_description" : @"offer_description",
                                                        @"offer_content" : @"offer_content",
                                                        @"discount_type" : @"discount_type",
                                                        @"discount_type_name" : @"discount_type_name",
                                                        @"discount_value" : @"discount_value",
                                                        @"date_add" : @"date_add",
                                                        @"branch_name" : @"branch_name",
                                                        @"branch_address" : @"branch_address",
                                                        @"branch_tel" : @"branch_tel",
                                                        @"hour_open" : @"hour_open",
                                                        @"hour_close" : @"hour_close",
                                                        @"latitude" : @"latitude",
                                                        @"longitude" : @"longitude",
                                                        @"max_punch": @"max_punch",
                                                        @"count_punch": @"count_punch"
                                                        }];
    
    [self RK_RequestApi_EntityMapping:ticketMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}

@end
