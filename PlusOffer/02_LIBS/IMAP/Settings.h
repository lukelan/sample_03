#import <Foundation/Foundation.h>


@interface Settings : NSObject
{
}

@property (nonatomic, retain) NSString *imapHost;
@property (nonatomic, assign) int imapPort;
@property (nonatomic, assign) bool imapSsl;
@property (nonatomic, retain) NSString *imapUsername;
@property (nonatomic, retain) NSString *imapPassword;

@end

extern Settings *settings;