//
//  PlusAPIManager.m
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/24/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "PlusAPIManager.h"

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
@end
