//
//  configurationLocalIPViewController.h
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

#import <UIKit/UIKit.h>
#import "bonjourBrowserDelegate.h"
#import "openhab.h"


@interface configurationLocalIPViewController : UITableViewController <UITextFieldDelegate,bonjourBrowser,openHABprotocol>
{
	NSNetServiceBrowser *serviceBrowser;
	NSNetServiceBrowser *serviceBrowser2;
}
@property (strong,nonatomic)	NSMutableArray*bonjourAddresses;
@property (strong,nonatomic) bonjourBrowserDelegate*bonjourDelegate;
@property (strong,nonatomic)	NSNetServiceBrowser *serviceBrowser;
@property (strong,nonatomic)	NSNetServiceBrowser *serviceBrowser2;
@property (weak, nonatomic) UITableViewController*lastViewController;
@property (strong,nonatomic) NSString*theField;
@property (strong,nonatomic) NSMutableArray *arrayLasts;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sitemapButton;
@property (weak, nonatomic) IBOutlet UITextField *theTextField;
@property (nonatomic) NSInteger lastselected;
- (IBAction)deleteAlternate:(id)sender;

- (IBAction)doneButton:(id)sender;
@end