//
//  AuthManager.h
//  ThatInbox
//
//  Created by Liyan David Chang on 7/31/13.
//  Copyright (c) 2013 Ink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>
#import "GTMOAuth2ViewControllerTouch.h"

@class GDataFeedContact;

@interface AuthManager : NSObject

@property (nonatomic, strong, readonly) GDataFeedContact *googleContacts;

+ (id)sharedManager;

@property (nonatomic, assign) BOOL isAccountChecked;

- (void)refresh;
- (void)logout;

- (MCOSMTPSession *) getSmtpSession;
- (MCOIMAPSession *) getImapSession;
- (void) setOauth2Token:(NSString*)token;
- (void) setOauth2:(GTMOAuth2Authentication*)auth;

- (void) requestGoogleContacts:(void (^)(GDataFeedContact *feed, NSError *error))handler;

@end
