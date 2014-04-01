#import "Utils.h"


@implementation Utils

// Utils

+ (void) alertError:(NSString *)msg
{
	[Utils alert:msg title:@"Error"];
}

+ (void) alert:(NSString *)msg title:(NSString *)title
{
	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = title;
	alert.message = msg;
	[alert addButtonWithTitle:@"OK"];
	[alert show];
}

@end

