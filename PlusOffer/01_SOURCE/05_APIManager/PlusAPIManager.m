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
#import "BrandModel.h"
#import "Routes.h"
#import "MenuModel.h"
#import "BranchModel.h"

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

-(void)RK_RequestApiGetDirectionContext :(id)context_id from:(CLLocationCoordinate2D)source to:(CLLocationCoordinate2D)destination
{
    NSString *url = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f&sensor=true",REQUEST_URL_GOOGLE_DIRECTION_API, source.latitude, source.longitude, destination.latitude, destination.longitude];
    //---------------------------------//
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Routes class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                   @"overview_polyline" : @"overview_polyline"
                                                   }];
    RKResponseDescriptor *locationDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"routes" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self RK_SendRequestAPI_Descriptor:locationDescriptor withURL:[NSURL URLWithString:url] postData:nil keyPost:nil withContext:context_id requestId:ID_REQUEST_DIRECTION];
}

-(void)RK_RequestApiGetListPlusOfferRedeem:(id)context_id forUserID:(NSString*)userID;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_REDEEM,ROOT_SERVER, userID];
    
    RKEntityMapping *redeemMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([RedeemModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    redeemMapping.identificationAttributes = @[@"redeem_id"];
    [redeemMapping addAttributeMappingsFromDictionary:@{
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
                                                        @"user_punch" : @"user_punch",
                                                        @"max_punch" : @"max_punch",
                                                        @"is_redeem" : @"is_redeem",
                                                        @"is_redeemable" : @"is_redeemable"
                                                        }];

    [redeemMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"@metadata.mapping.collectionIndex" toKeyPath:@"order_id"]];
    [self RK_RequestApi_EntityMapping:redeemMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}
-(void)RK_RequestApiGetListPlusOffer:(id)context_id;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_OFFER,ROOT_SERVER];
    
    
    RKEntityMapping *offerMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([OfferModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    offerMapping.identificationAttributes = @[@"offer_id"];
    [offerMapping addAttributeMappingsFromDictionary:@{
                                                        @"offer_id" : @"offer_id",
                                                        @"brand_id" : @"brand_id",
                                                        @"branch_id" : @"branch_id",
                                                        @"offer_name" : @"offer_name",
                                                        @"latitude" : @"latitude",
                                                        @"longitude" : @"longitude",     
                                                        @"branch_name" : @"branch_name",
                                                        @"brand_name" : @"brand_name",
                                                        @"category_id" : @"category_id",
                                                        @"discount_type" : @"discount_type",
                                                        @"discount_value" : @"discount_value",
                                                        @"date_add" : @"date_add",
                                                         @"offer_date_end" : @"offer_date_end",
                                                         @"max_punch" : @"max_punch",
                                                        @"size1" : @"size1",
                                                        @"size2" : @"size2",
                                                        @"is_like" : @"is_like"
                                                        }];
    [offerMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"@metadata.mapping.collectionIndex" toKeyPath:@"order_id"]];
    [self RK_RequestApi_EntityMapping:offerMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}

-(void)RK_RequestApiGetListBranch:(id)context_id ofBrand:(NSString *)brand_id
{
    NSString *url = [NSString stringWithFormat:API_REQUEST_GET_LIST_BRANCH,ROOT_SERVER];
    if (brand_id) {
        url = [NSString stringWithFormat:@"%@&brand_id=%@", url, brand_id];
    }
    
    RKEntityMapping *objectMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([BranchModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    objectMapping.identificationAttributes = @[@"branch_id"];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"branch_id"       : @"branch_id",
                                                        @"branch_name"     : @"branch_name",
                                                        @"branch_name_slug": @"branch_name_slug",
                                                        @"branch_address"  : @"branch_address",
                                                        @"branch_tel"      : @"branch_tel",
                                                        @"brand_id"        : @"brand_id",
                                                        @"location_id"     : @"location_id",
                                                        @"latitude"        : @"latitude",
                                                        @"longitude"       : @"longitude",
                                                        @"hour_open"       : @"hour_open",       
                                                        @"hour_close"      : @"hour_close",      
                                                        @"number"          : @"number",          
                                                        @"is_active"       : @"is_active",       
                                                        @"date_add"        : @"date_add",        
                                                        @"date_update"     : @"date_update",     
                                                        @"size1"           : @"size1",           
                                                        @"size2"           : @"size2",           
                                                        @"size3"           : @"size3"
                                                       }];
//    [objectMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"@metadata.mapping.collectionIndex" toKeyPath:@"branch_id"]];
    [self RK_RequestApi_EntityMapping:objectMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}

-(void)RK_RequestApiGetListPlusOfferWithCategory:(id)context_id forCategory:(NSString*)categoryID;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_OFFER_WITH_CATEGORY,ROOT_SERVER,categoryID];
    
    RKEntityMapping *offerMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([OfferModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    offerMapping.identificationAttributes = @[@"offer_id"];
    [offerMapping addAttributeMappingsFromDictionary:@{
                                                        @"offer_id" : @"offer_id",
                                                        @"brand_id" : @"brand_id",
                                                        @"branch_id" : @"branch_id",
                                                        @"offer_name" : @"offer_name",
                                                        @"latitude" : @"latitude",
                                                        @"longitude" : @"longitude",
                                                        @"brand_name" : @"brand_name",
                                                        @"branch_name" : @"branch_name",
                                                        @"user_punch" : @"user_punch",
                                                        @"category_id" : @"category_id",
                                                        @"discount_type" : @"discount_type",
                                                        @"discount_value" : @"discount_value",
                                                        @"date_add" : @"date_add",
                                                        @"offer_date_end" : @"offer_date_end",
                                                        @"max_punch" : @"max_punch",
                                                        @"size1" : @"size1",
                                                        @"size2" : @"size2",
                                                        @"is_like" : @"is_like"
                                                        }];
    [offerMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"@metadata.mapping.collectionIndex" toKeyPath:@"order_id"]];
    [self RK_RequestApi_EntityMapping:offerMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}

-(void)RK_RequestApiGetListPlusOfferDetail:(id)context_id forOfferID:(NSString*)offerID;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_OFFER_DETAIL,ROOT_SERVER,offerID];
    
    
    RKEntityMapping *offerDetailMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([OfferDetailModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    offerDetailMapping.identificationAttributes = @[@"offer_id"];
    [offerDetailMapping addAttributeMappingsFromDictionary:@{
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
                                                        @"user_punch": @"user_punch",
                                                        @"offer_date_end" : @"offer_date_end",
                                                        @"size1" : @"size1",
                                                        @"size2" : @"size2",
                                                        @"user_punch" : @"user_punch",
                                                        @"path" : @"path",
                                                        @"menu" : @"menu",
                                                        @"brand_name" : @"brand_name"
                                                        }];
    [self RK_RequestApi_EntityMapping:offerDetailMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}

-(void)RK_RequestApiGetListItemMenu:(id)context_id forBrand_id:(NSString*)brand_id;
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_GET_LIST_MENU_WITH_BRAND,ROOT_SERVER,brand_id];
    
    RKEntityMapping *menuMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([MenuModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    menuMapping.identificationAttributes = @[@"item_id"];
    [menuMapping addAttributeMappingsFromDictionary:@{
                                                        @"item_id" : @"item_id",
                                                        @"item_name" :@"item_name",
                                                        @"item_price" : @"item_price",
                                                        @"item_description" : @"item_description",
                                                        @"item_image" : @"item_image",
                                                        @"offer_description" : @"offer_description",
                                                        @"brand_id" : @"brand_id",
                                                        }];
    [menuMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"@metadata.mapping.collectionIndex" toKeyPath:@"order_id"]];
    [self RK_RequestApi_EntityMapping:menuMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}
-(void)RK_RequestApiCheckinContext:(id)context_id forUserID:(NSString*)userID atBanchID:(NSString *)branch_id withCoordinate:(CLLocationCoordinate2D)destination
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_USER_CHECKIN,ROOT_SERVER, userID,branch_id, destination.latitude, destination.longitude];
    [self RK_RequestDictionaryMappingResponseWithURL:url postData:nil keyPath:nil withContext:context_id requestId:-1];
}

#pragma mark check version to update
-(void)RK_RequestApiCheckAppVersion:(NSString *) currentVersion responseContext: (id)context_id
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_APP_GET_NEW_VERSION,BASE_URL_SERVER,currentVersion];
    [self RK_RequestDictionaryMappingResponseWithURL:url postData:nil keyPath:nil withContext:context_id requestId:ID_REQUEST_CHECK_VERSION];
}

-(NSDictionary*)parseToGetVersionInfo: (NSDictionary *) dicObject
{
    NSNumber *status = [dicObject objectForKey:@"status"];
    if (!status.intValue)
    {
        return nil;
    }
    dicObject = [dicObject objectForKey:@"result"];
    if ([dicObject isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    return dicObject;
}

#pragma mark -
#pragma mark get Brand info
- (void)RK_RequestAPIGetListBrandContext:(id)context_id
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;    
    NSString *url = [NSString stringWithFormat:API_REQUEST_GET_LIST_BRAND, ROOT_SERVER, [delegate isUserLoggedIn] ? delegate.userProfile.user_id:@"1"];
    //-------------------------------//
    RKEntityMapping *brandMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([BrandModel class]) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    brandMapping.identificationAttributes = @[ @"brand_id" ];
    [brandMapping addAttributeMappingsFromArray:@[@"brand_id",@"brand_card_image",@"brand_card_logo", @"brand_card_color",@"list_prize", @"max_punch", @"user_punch", @"punch_color_active", @"punch_color", @"punch_image", @"punch_image_active", @"punch_image_select", @"date_end"]];
    [brandMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"@metadata.mapping.collectionIndex" toKeyPath:@"order_id"]];
    //-------------------------------//
    [self RK_RequestApi_EntityMapping:brandMapping pathURL:[self getFullLinkAPI:url] postData:nil keyPath:@"result"];
}

#pragma mark post udid and device token
-(void)RK_RequestPostUIID:(NSString *)udid andDeviceToken:(NSString *)device_token context:context_id
{
    NSDictionary *temp  = [NSDictionary dictionaryWithObjectsAndKeys:
                           udid, @"udid",
                           device_token, @"device_token",
                           nil];
    RKObjectMapping *dicMapping = [RKObjectMapping mappingForClass:[DictionaryMapping class]];
    [dicMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"curDictionary"]];
    RKResponseDescriptor *objDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dicMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"result" statusCodes:nil];
    
    [self RK_SendRequestGetAPI_Descriptor:objDescriptor withURL:[self getFullLinkAPI:API_REQUEST_SET_DEVICETOKEN] parameters:temp withContext:nil requestId:ID_POST_UDID_DEVICE_TOKEN];
}

#pragma mark
#pragma mark user request punch
- (void)RK_RequestPunchUser:(NSString *)userId atBrand:(NSString *)brand_id withCode:(NSString *)punch_code numberOfPunch:(NSNumber *)punch_count context:(id)context;
{
    NSString* urlString = [NSString stringWithFormat:API_REQUEST_USER_PUNCH, ROOT_SERVER];
    NSDictionary* temp = [NSDictionary dictionaryWithObjectsAndKeys:
                          userId, @"user_id",
                          brand_id, @"brand_id",
                          punch_code, @"punch_code",
                          punch_count, @"punch_count",
                          nil];
    [self RK_RequestDictionaryMappingResponseWithURL:urlString postData:temp keyPath:nil withContext:context requestId:ID_REQUEST_USER_PUNCH];
    
}
#pragma mark offer favorite
-(void)RK_RequestApiAddFavorite:(id)context_id forUserID:(NSString*)userId forOfferID:(NSString*)offer_id
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_ADD_FAVORITE,ROOT_SERVER];
    NSDictionary* temp = [NSDictionary dictionaryWithObjectsAndKeys:
                          userId, @"user_id",
                          offer_id, @"offer_id",
                          nil];
    [self RK_RequestDictionaryMappingResponseWithURL:url postData:temp keyPath:nil withContext:context_id requestId:ID_REQUEST_FAVORITE];

}
-(void)RK_RequestApiRemoveFavorite:(id)context_id forUserID:(NSString*)userId forOfferID:(NSString*)offer_id
{
    NSString *url=[NSString stringWithFormat:API_REQUEST_REMOVE_FAVORITE,ROOT_SERVER];
    NSDictionary* temp = [NSDictionary dictionaryWithObjectsAndKeys:
                          userId, @"user_id",
                          offer_id, @"offer_id",
                          nil];
    [self RK_RequestDictionaryMappingResponseWithURL:url postData:temp keyPath:nil withContext:context_id requestId:ID_REQUEST_FAVORITE];
}
@end
