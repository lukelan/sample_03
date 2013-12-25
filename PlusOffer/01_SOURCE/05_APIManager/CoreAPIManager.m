//
//  APIManager.m
//  MovieTicket
//
//  Created by Phuong. Nguyen Minh on 12/7/12.
//  Copyright (c) 2012 Phuong. Nguyen Minh. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CoreAPIManager.h"
#import <CoreData/CoreData.h>
#import "NSString+MD5Addition.h"
#import "NSString+trimSpecialCharacter.h"

@implementation CoreAPIManager

static CoreAPIManager* _sharedCoreAPIManager = nil;
+(CoreAPIManager*)sharedAPIManager
{
    //This way guaranttee only a thread execute and other thread will be returned when thread was running finished process
    if(_sharedCoreAPIManager != nil)
    {
        return _sharedCoreAPIManager;
    }
    static dispatch_once_t _single_thread;//block thread
    dispatch_once(&_single_thread, ^ {
        _sharedCoreAPIManager = [[super allocWithZone:nil] init];
    });//This code is called most once.
    return _sharedCoreAPIManager;
}

#pragma implements these methods below to do the appropriate things to ensure singleton status.
//if you want a singleton instance but also have the ability to create other instances as needed through allocation and initialization, do not override allocWithZone: and the orther methods below
//We don't want to allocate a new instance, so return the current one
+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedAPIManager];
}


//We don't want to generate mutiple conpies of the singleton
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)init{
    self=[super init];
    if (self) {
    }
    return self;
}

#pragma mark General method for app
-(NSString *)getFormatAuthentication
{
    return [NSString stringWithFormat:@"sig=%@&ts=%0.0f",[[NSString stringWithFormat:@"%@%0.0f",MAPP_KEY,[NSDate timeIntervalSinceReferenceDate]] stringFromMD5],[NSDate timeIntervalSinceReferenceDate]];
}


- (NSString *)getFullLinkAPI:(NSString *)url
{
    NSString *pathURL = [NSString stringWithFormat:@"%@&%@",url, [self getFormatAuthentication]];
    return pathURL;
}

#pragma mark process for Object is subclass of NSManageObject
//using request post with default key @"data"
- (void)RK_RequestApi_EntityMapping:(RKEntityMapping *)objMapping pathURL:(NSString *)pathURL postData:(NSDictionary *)temp keyPath:(NSString *)keyPath
{
    [self RK_RequestApi_EntityMapping:objMapping pathURL:pathURL postData:temp keyPost:@"data" keyPath:keyPath];
}

//using request when post with key
- (void)RK_RequestApi_EntityMapping:(RKEntityMapping *)objMapping pathURL:(NSString *)pathURL postData:(NSDictionary *)temp keyPost:(NSString *)keyPost keyPath:(NSString *)keyPath
{
    RKResponseDescriptor *filmDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objMapping method:RKRequestMethodAny pathPattern:nil keyPath:keyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [filmDescriptor setBaseURL:[NSURL URLWithString:BASE_URL_SERVER]];
    [[RKObjectManager sharedManager] addResponseDescriptor:filmDescriptor];
    
    [self RK_SendRequestFetchCD_URL:[NSURL URLWithString:pathURL] postData:temp keyPost:keyPost responseDescriptor:filmDescriptor];
}

- (void)RK_SendRequestFetchCD_URL:(NSURL *)pathURL postData:(NSDictionary *)temp keyPost:(NSString *)keyPost responseDescriptor:(RKResponseDescriptor *)responseDescriptor
{
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodAny matchingPathPattern:[pathURL absoluteString]];
    //send request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:pathURL];
    if (temp) {
        request = [self RK_SetupConfigPostRequestWithURL:pathURL temp:temp keyPost:keyPost];
    }
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [[RKObjectManager sharedManager] removeResponseDescriptor:responseDescriptor];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Failed %@", error);
    }];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:objectRequestOperation];
}

#pragma mark process for Object not subclass NSManageObject
//post using keyDefault @"data"
- (void)RK_RequestDictionaryMappingResponseWithURL:(NSString *)url postData:(NSDictionary *)temp keyPath:(NSString *)keyPath withContext:(id)context_id requestId:(int)request_id
{
    [self RK_RequestDictionaryMappingResponseWithURL:url postData:temp keyPost:@"data" keyPath:keyPath withContext:context_id requestId:request_id];
}

- (void)RK_RequestDictionaryMappingResponseWithURL:(NSString *)url postData:(NSDictionary *)temp keyPost:(NSString *)keyPost keyPath:(NSString *)keyPath withContext:(id)context_id requestId:(int)request_id
{
    RKObjectMapping *dicMapping = [RKObjectMapping mappingForClass:[DictionaryMapping class]];
    [dicMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"curDictionary"]];
    
    [self RK_RequestWithObjectMapping:dicMapping pathURL:[self getFullLinkAPI:url] postData:temp keyPost:keyPost keyPath:keyPath withContext:context_id requestId:request_id];
}

//request general mapping object and send, receive response
- (void)RK_RequestWithObjectMapping:(RKObjectMapping *)objMapping pathURL:(NSString *)pathURL postData:(NSDictionary *)temp keyPost:(NSString *)keyPost keyPath:(NSString *)keyPath withContext:(id)context_id requestId:(int)request_id
{
    RKResponseDescriptor *objDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objMapping method:RKRequestMethodAny pathPattern:nil keyPath:keyPath statusCodes:nil];
    [self RK_SendRequestAPI_Descriptor:objDescriptor withURL:[NSURL URLWithString:pathURL] postData:temp keyPost:(NSString *)keyPost withContext:context_id requestId:request_id];
}

- (NSMutableURLRequest *)RK_SetupConfigPostRequestWithURL:(NSURL *)pathURL temp:(NSDictionary *)temp keyPost:(NSString *)keyPost
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temp options:0 error:&error];
//    [RKMIMETypeSerialization dataFromObject:temp MIMEType:RKMIMETypeJSON error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *stringSend = jsonString;
    if (keyPost) {
        stringSend = [NSString stringWithFormat:@"%@=%@", keyPost, jsonString];
    }
    NSData *requestBody = [stringSend dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:pathURL];    
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody:requestBody];
    [myRequest setHTTPShouldHandleCookies:YES];
    [myRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];

    [myRequest setTimeoutInterval:60];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeXML];
    
    [[RKObjectManager sharedManager] setAcceptHeaderWithMIMEType:RKMIMETypeXML];
    [[RKObjectManager sharedManager] setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [[RKObjectManager sharedManager] setAcceptHeaderWithMIMEType:RKMIMETypeFormURLEncoded];
    return myRequest;
}

- (void)RK_SendRequestAPI_Descriptor:(RKResponseDescriptor *)objectDescriptor withURL:(NSURL *)pathURL postData:(NSDictionary *)temp keyPost:(NSString *)keyPost withContext:(id)context_id requestId:(int)request_id
{
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodAny matchingPathPattern:[pathURL absoluteString]];
    NSMutableURLRequest *request = [NSMutableURLRequest  requestWithURL:pathURL];
    if (temp) {
        request = [self RK_SetupConfigPostRequestWithURL:pathURL temp:temp keyPost:keyPost];
    }
    else
    {
        //send request
        if (!request) {
            return;
        }
        [request setHTTPShouldHandleCookies:YES];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [request setTimeoutInterval:60];
    }
    if (!request) {
        return;
    }
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[objectDescriptor]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //            RKLogInfo(@"Array Load content  = %@", mappingResult.dictionary);
        [self RK_CallBackMethod:request_id mappingResult:mappingResult context_id:context_id objectDescriptor:objectDescriptor];
        [[RKObjectManager sharedManager] removeResponseDescriptor:objectDescriptor];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Failed %@", error);
    }];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:objectRequestOperation];
}

//xu ly truong hop neu muon truyen khoang trang trong request get
- (void)RK_SendRequestAPI_Descriptor:(RKResponseDescriptor *)objectDescriptor withURL:(NSString *)pathURL parameters:(NSDictionary *)temp withContext:(id)context_id requestId:(int)request_id
{
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodAny matchingPathPattern:pathURL];
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:pathURL parameters:temp] ;
    //send request
    if (!request) {
        return;
    }
    [request setHTTPShouldHandleCookies:YES];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:60];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[objectDescriptor]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //            RKLogInfo(@"Array Load content  = %@", mappingResult.dictionary);
        [self RK_CallBackMethod:request_id mappingResult:mappingResult context_id:context_id objectDescriptor:objectDescriptor];
        [[RKObjectManager sharedManager] removeResponseDescriptor:objectDescriptor];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Failed %@", error);
        if ([context_id respondsToSelector:@selector(processFailedRequestId:)]) {
            [context_id processFailedRequestId:request_id];
        }
    }];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:objectRequestOperation];
}

#pragma mark process call back method for result response from server
- (void)RK_CallBackMethod:(int)request_id mappingResult:(RKMappingResult *)mappingResult context_id:(id)context_id objectDescriptor:(RKResponseDescriptor *)objectDescriptor
{
    if (context_id)
    {
        id resultObject = [mappingResult.dictionary objectForKey:objectDescriptor.keyPath];
        if (!objectDescriptor.keyPath)
        {
            NSEnumerator *enumerator = [mappingResult.dictionary objectEnumerator];
            resultObject = [enumerator nextObject];
        }
        if (resultObject ) {
            if ([context_id respondsToSelector:@selector(processResultResponseDictionaryMapping:requestId:)] && [resultObject isKindOfClass:[DictionaryMapping class]])
            {
                [context_id processResultResponseDictionaryMapping:(DictionaryMapping *)resultObject requestId:request_id];
            }
            else if([resultObject isKindOfClass:[NSArray class]])
            {
                if (([resultObject count] == 0)) {
                    if([context_id respondsToSelector:@selector(processResultResponseArrayMapping:requestId:)])
                    {
                        [context_id processResultResponseArrayMapping:(ArrayMapping *)resultObject requestId:request_id];
                    }
                    else
                    {
                        if([context_id respondsToSelector:@selector(processResultResponseArray:requestId:)])
                        {
                            [context_id processResultResponseArray:mappingResult.array requestId:request_id];
                        }
                    }
                    return;
                }
                id curObject = [resultObject objectAtIndex:0];
                if ([curObject isKindOfClass:[ArrayMapping class]]) {
                    if([context_id respondsToSelector:@selector(processResultResponseArrayMapping:requestId:)])
                    {
                        [context_id processResultResponseArrayMapping:(ArrayMapping *)curObject requestId:request_id];
                    }
                } else {
                    if([context_id respondsToSelector:@selector(processResultResponseArray:requestId:)])
                    {
                        [context_id processResultResponseArray:mappingResult.array requestId:request_id];
                    }
                }
            }
        }
    }
}

#pragma mark API request with restkit
-(void)RK_RequestApiGetListPlusOfferContext:(id)context_id
{
//    NSString *url = [NSString stringWithFormat:ADN_API_GET_CATEGORY,ROOT_SERVER];
//    //---------------------------------//
//    RKObjectMapping *category = [RKObjectMapping mappingForClass:[AppCategory class]];
//    [category addAttributeMappingsFromDictionary:@{
//     @"id" : @"cat_id",
//     @"name" : @"name",
//     @"created" : @"created",
//     @"update_date" : @"update_date",
//     @"channel" : @"channel",
//     @"code" : @"code",
//     @"banner" : @"banner"
//     }];
//    RKResponseDescriptor *locationDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:category method:RKRequestMethodAny pathPattern:nil keyPath:@"result" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    [self RK_SendRequestAPI_Descriptor:locationDescriptor withURL:[NSURL URLWithString:url] postData:nil keyPost:nil withContext:context_id requestId:ID_REQUEST_GET_CATEGORY];
}
@end

