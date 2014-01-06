//
//  FacebookManger.h
//  123Phim
//
//  Created by phuonnm on 3/11/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import "FacebookHandler.h"

@interface FacebookManager : FacebookHandler
- (void)shareUrl:(NSString *)url
              key:(NSString*)key
      withMessage:(NSString *)message
        onSuccess:(void (^)(id))successCallback
          onError:(void (^)(NSError *))errorCallback;

- (void)shareUrl:(NSString *)url
             key:(NSString*)key
       graphPath:(NSString*)graphPath
     withMessage:(NSString *)message
    withImageUrl:(NSString*)image
       onSuccess:(void (^)(id))successCallback
         onError:(void (^)(NSError *))errorCallback;

- (void)loginAndGetFacebookInfo;

@end
