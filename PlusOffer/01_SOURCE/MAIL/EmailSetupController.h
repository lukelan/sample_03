#import <UIKit/UIKit.h>
#import "CheckboxCell.h"
#import "SettingsCell.h"


@interface EmailSetupController : UITableViewController <UITextFieldDelegate>
{
	SettingsCell *cellHost;
	SettingsCell *cellPort;
	CheckboxCell *cellSsl;
	SettingsCell *cellUsername;
	SettingsCell *cellPassword;
}

@end
