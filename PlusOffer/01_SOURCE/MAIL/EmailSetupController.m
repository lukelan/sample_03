#import "EmailSetupController.h"
#import "Settings.h"
#import "Imap.h"
#import "EmailListController.h"


@implementation EmailSetupController

- (id) init
{
	if (self = [super initWithStyle:UITableViewStyleGrouped])
	{
	}
	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];

	self.title = @"Settings";
  
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnDone addTarget:self action:@selector(btnDone_Touched) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.frame = CGRectMake(80.0, 250.0, 160.0, 40.0);
	[self.view addSubview:btnDone];
	
	cellHost = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL];
	cellHost.textLabel.text = @"Host";
	cellHost.textField.text = settings.imapHost;
	cellHost.textField.placeholder = @"server.com";
	cellHost.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	cellHost.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	cellHost.textField.keyboardType = UIKeyboardTypeURL;
	cellHost.textField.delegate = self;
  
	cellPort = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL];
	cellPort.textLabel.text = @"Port";
	cellPort.textField.text = settings.imapPort > 0 ? [NSString stringWithFormat:@"%i", settings.imapPort] : NULL;
	cellPort.textField.placeholder = @"143";
	cellPort.textField.keyboardType = UIKeyboardTypeNumberPad;
	cellPort.textField.delegate = self;
    
	cellSsl = [[CheckboxCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL];
	cellSsl.textLabel.text = @"Use SSL";
	cellSsl.checkbox.on = settings.imapSsl;
	[cellSsl.checkbox addTarget:self action:@selector(cellSsl_ValueChanged) forControlEvents:UIControlEventValueChanged];
    
	cellUsername = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL];
	cellUsername.textLabel.text = @"Username";
	cellUsername.textField.text = settings.imapUsername;
	cellUsername.textField.placeholder = @"name";
	cellUsername.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	cellUsername.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	cellUsername.textField.keyboardType = UIKeyboardTypeEmailAddress;
	cellUsername.textField.delegate = self;
  
	cellPassword = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL];
	cellPassword.textLabel.text = @"Password";
	cellPassword.textField.text = settings.imapPassword;
	cellPassword.textField.placeholder = @"password";
	cellPassword.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	cellPassword.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	cellPassword.textField.secureTextEntry = true;
	cellPassword.textField.delegate = self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[cellHost release];
	[cellPort release];
	[cellSsl release];
	[cellUsername release];
	[cellPassword release];
	[super dealloc];
}

- (void) btnDone_Touched
{
	EmailListController *ctr = [[EmailListController alloc] init];
	[self.flipboardNavigationController pushViewController:ctr];
    [cellPassword.textField resignFirstResponder];
    [cellUsername.textField resignFirstResponder];
	[ctr release];
}


// UITextField

- (BOOL) textField:(UITextField *)sender shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *newString = [sender.text stringByReplacingCharactersInRange:range withString:string];

	if (sender == cellHost.textField)
		settings.imapHost = newString;
	if (sender == cellPort.textField)
		settings.imapPort = [newString intValue];
	if (sender == cellUsername.textField)
		settings.imapUsername = newString;
	if (sender == cellPassword.textField)
		settings.imapPassword = newString;
		
	return true;
}


// UISwitch

- (void) cellSsl_ValueChanged
{
	settings.imapSsl = cellSsl.checkbox.on;
}


// UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			return cellHost;
		case 1:
			return cellPort;
		case 2:
			return cellSsl;
		case 3:
			return cellUsername;
		case 4:
			return cellPassword;
	}
  
	return NULL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
