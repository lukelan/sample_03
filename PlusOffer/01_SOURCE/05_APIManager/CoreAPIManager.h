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

@property (nonatomic, strong) NSString *accessTokenKey;
#pragma mark
#pragma mark ultility function for authentication with server
- (NSString *)getFullLinkAPI:(NSString *)url;
-(NSString *)getFormatAuthentication;
#pragma mark
#pragma mark Restkit parse and return array of object.
- (void)RK_SendRequestAPI_Descriptor:(RKResponseDescriptor *)objectDescriptor withURL:(NSURL *)pathURL postData:(NSDictionary *)temp keyPost:(NSString *)keyPost withContext:(id)context_id requestId:(int)request_id;
- (void)RK_SendRequestGetAPI_Descriptor:(RKResponseDescriptor *)objectDescriptor withURL:(NSString *)pathURL parameters:(NSDictionary *)temp withContext:(id)context_id requestId:(int)request_id;
#pragma mark
#pragma mark call API and restkit parse save to core data
- (void)RK_RequestApi_EntityMapping:(RKEntityMapping *)objMapping pathURL:(NSString *)pathURL postData:(NSDictionary *)temp keyPost:(NSString *)keyPost keyPath:(NSString *)keyPath;
//using request post with default key @"data"
- (void)RK_RequestApi_EntityMapping:(RKEntityMapping *)objMapping pathURL:(NSString *)pathURL postData:(NSDictionary *)temp keyPath:(NSString *)keyPath;
#pragma mark
#pragma mark mapping to custom handle parse json
//post using keyDefault @"data"
- (void)RK_RequestDictionaryMappingResponseWithURL:(NSString *)url postData:(NSDictionary *)temp keyPath:(NSString *)keyPath withContext:(id)context_id requestId:(int)request_id;
- (void)RK_RequestDictionaryMappingResponseWithURL:(NSString *)url postData:(NSDictionary *)temp keyPost:(NSString *)keyPost keyPath:(NSString *)keyPath withContext:(id)context_id requestId:(int)request_id;
- (void)RK_RequestArrayMappingResponseWithURL:(NSString *)url postData:(NSDictionary *)temp keyPath:(NSString *)keyPath withContext:(id)context_id requestId:(int)request_id;
- (void)RK_RequestArrayMappingResponseWithURL:(NSString *)url postData:(NSDictionary *)temp keyPost:(NSString *)keyPost keyPath:(NSString *)keyPath withContext:(id)context_id requestId:(int)request_id;
#pragma mark send location to server
- (void)RK_UpdateLocationUserId:(NSString*)userId beInAddress:(NSString*)addr latitude:(NSString*)lat longitude:(NSString*)log atTime:(NSString*)time context:(id)context;
#pragma mark using for load user default
//Function for save data to phone through NSUserDefaults class
+(NSArray *) getArrayDataInAppForKey:(NSString *)key;
+(void) setArrayDataInApp:(NSArray *)array ForKey:(NSString *)key;

+(void)setBoolValue:(BOOL)bvalue ForKey:(NSString *)key;
+(BOOL)getValueAsBoolForKey:(NSString *)key;

+(NSString *)getStringInAppForKey:(NSString *)key;
+(void) setStringInApp:(NSString *)value ForKey:(NSString *)key;
+(void) deleteObjectForKey:(NSString *)key;
+ (BOOL)isStoredLocalData;
+ (void)resetDefaults;

+(void) setValueForKey:(id)value ForKey:(NSString *)key;
+(id) getValueForKey:(NSString *)key;

//Save My Location
+ (void)saveLocationObject:(Location *)obj;
+ (Location *)loadLocationObject;

//Save for local Object
+ (void) saveObject:(id)obj forKey:(NSString *)key;
+ (id)loadObjectForKey:(NSString *)key;

+(NSDictionary*)encryptDictionaryWithDictionary:(NSDictionary*)dict;
+(NSDictionary*)decryptDictionaryWithDictionary:(NSDictionary*)dict;

#pragma mark 
#pragma mark using for communicate with server
+(CoreAPIManager*)sharedAPIManager;
@end
