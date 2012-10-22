//
//  loginViewController.m
//  openHAB iOS User Interface
//  Copyright © 2011 Pablo Romeu
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// v1.2 NEW! login

#import "loginViewController.h"
#import "PDKeychainBindings.h"

@interface loginViewController ()

@end

@implementation loginViewController
@synthesize userField;
@synthesize passwordField;
@synthesize warningAuthText;
@synthesize server;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
	// v1.2
	userField.text=[bindings stringForKey:[server stringByAppendingString:@"user"]];
	passwordField.text=[bindings stringForKey:[server stringByAppendingString:@"password"]];
	warningAuthText.text=NSLocalizedString(@"warningAuthTextLoc", @"warningAuthTextLoc");
	self.navigationItem.title=NSLocalizedString(@"loginLoc", @"loginLoc");
}

- (void)viewDidUnload
{
	[self setUserField:nil];
	[self setPasswordField:nil];
	[self setWarningAuthText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)done:(id)sender {
	PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
	// Saving
	[bindings setObject:userField.text forKey:[server stringByAppendingString:@"user"]];
	[bindings setObject:passwordField.text forKey:[server stringByAppendingString:@"password"]];

	[self dismissModalViewControllerAnimated:YES];
}
@end
