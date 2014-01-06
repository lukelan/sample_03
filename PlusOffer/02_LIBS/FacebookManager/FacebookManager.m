//
//  FacebookManger.m
//  123Phim
//
//  Created by phuonnm on 3/11/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import "FacebookManager.h"

@implementation FacebookManager

static FacebookManager* _sharedMyFacebookManger = nil;

+ (FacebookManager *)shareMySingleton
{
    if(_sharedMyFacebookManger != nil)
    {
        return _sharedMyFacebookManger;
    }
    static dispatch_once_t _single_thread;//block thread
    dispatch_once(&_single_thread, ^ {
        _sharedMyFacebookManger = [[super allocWithZone:nil] init];
    });//This code is called most once.
    return _sharedMyFacebookManger;
}

#pragma mark - Share link
- (void)shareUrl:(NSString *)url key:(NSString*)key
              withMessage:(NSString *)message
                onSuccess:(void (^)(id))successCallback
                  onError:(void (^)(NSError *))errorCallback
{
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    [action setValue:url forKey:key];
    [action setValue:message forKey:@"message"];
    [action setValue:@"true" forKey:@"fb:explicitly_shared"];
    
    [FBRequestConnection startForPostWithGraphPath:@"me/vng_phim:share"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                     if (error) {
                                         errorCallback(error);
                                     } else {
                                         successCallback(result);
                                     }
                                 }];
}


- (void)shareUrl:(NSString *)url
             key:(NSString*)key
       graphPath:(NSString*)graphPath
                 withMessage:(NSString *)message
                withImageUrl:(NSString*)image
                   onSuccess:(void (^)(id))successCallback
                     onError:(void (^)(NSError *))errorCallback
{
    NSMutableDictionary<FBGraphObject>* action = [FBGraphObject graphObject];
    //    [action setValue:cinemaUrl forKey:@"cinema"];
    //    [action setValue:@"http://www.123phim.vn/chi-tiet-rap/21-bhd-cineplex-bhd-star-cineplex-3-2.html" forKey:@"cinema"];
    [action setValue:url forKey:key];
    
    NSDictionary* largeImage1 = [[NSDictionary alloc] initWithObjectsAndKeys: image, @"url", @"true", @"user_generated", nil];
    NSMutableArray* largeImageList = [[NSMutableArray alloc] initWithObjects: largeImage1, nil];
    
    [action setValue:largeImageList forKey:@"image"];
    [action setValue:message forKey:@"message"];
    [action setValue:@"true" forKey:@"fb:explicitly_shared"];
    [FBRequestConnection startForPostWithGraphPath:graphPath graphObject:action completionHandler:^(FBRequestConnection* connection, id result, NSError* error){
        if (error) {
            errorCallback(error);
        }else {
            successCallback(result);
        }
    }];
}

-(void)loginAndGetFacebookInfo
{
    [self loginFacebookWithResponseContext:self selector:@selector(loginFacebookResponse)];
}

-(void) loginFacebookResponse
{
    [self getFacebookAccountInfoWithResponseContext:nil selector:nil];
}

@end
