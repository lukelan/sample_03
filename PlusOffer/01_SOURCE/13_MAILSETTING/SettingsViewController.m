//
//  SettingsViewController.m
//  iOS UI Test
//
//  Created by Jonathan Willing on 4/8/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "SettingsViewController.h"
#import "FXKeychain.h"

NSString * const UsernameKey = @"username";
NSString * const PasswordKey = @"password";
NSString * const HostnameKey = @"hostname";
NSString * const FetchFullMessageKey = @"FetchFullMessageEnabled";
NSString * const OAuthEnabledKey = @"OAuth2Enabled";

@implementation SettingsViewController

- (void)done:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text ?: @"" forKey:UsernameKey];
    [[FXKeychain defaultKeychain] setObject:self.passwordTextField.text ?: @"" forKey:PasswordKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.hostnameTextField.text ?: @"" forKey:HostnameKey];
    [[NSUserDefaults standardUserDefaults] setBool:[self.fetchFullMessageSwitch isOn] forKey:FetchFullMessageKey];
    [[NSUserDefaults standardUserDefaults] setBool:[self.useOAuth2Switch isOn] forKey:OAuthEnabledKey];

    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.hostnameTextField resignFirstResponder];

    [self.delegate settingsViewControllerFinished:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.hostnameTextField.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    self.emailTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey];
    self.passwordTextField.text = [[FXKeychain defaultKeychain] objectForKey:PasswordKey];
    self.hostnameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:HostnameKey];
    self.fetchFullMessageSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:FetchFullMessageKey];
    self.useOAuth2Switch.on = [[NSUserDefaults standardUserDefaults] boolForKey:OAuthEnabledKey];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text ?: @"" forKey:UsernameKey];
    [[FXKeychain defaultKeychain] setObject:self.passwordTextField.text ?: @"" forKey:PasswordKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.hostnameTextField.text ?: @"" forKey:HostnameKey];
    [[NSUserDefaults standardUserDefaults] setBool:[self.fetchFullMessageSwitch isOn] forKey:FetchFullMessageKey];
    [[NSUserDefaults standardUserDefaults] setBool:[self.useOAuth2Switch isOn] forKey:OAuthEnabledKey];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        NSLog(@"Return pressed");
        [textField resignFirstResponder];
    } else {
        NSLog(@"Other pressed");
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
