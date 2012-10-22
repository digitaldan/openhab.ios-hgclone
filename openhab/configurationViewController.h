//
//  configurationViewController.h
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
#import "openhabMasterViewController.h"

@interface configurationViewController : UITableViewController <splitMultipleDetailViews>


@property (weak, nonatomic) IBOutlet UILabel *labelServer;
@property (weak, nonatomic) IBOutlet UILabel *labelAlternateServer;
@property (weak, nonatomic) IBOutlet UILabel *labelSitemap;
@property (weak, nonatomic) IBOutlet UILabel *labelRefresh;
@property (weak, nonatomic) IBOutlet UILabel *labelMaxConnections;

@property (weak, nonatomic) IBOutlet UILabel *theUrl;
@property (weak, nonatomic) IBOutlet UILabel *theAlternateUrl;
@property (weak, nonatomic) IBOutlet UILabel *theSitemap;
@property (weak, nonatomic) IBOutlet UILabel *refreshTime;
@property (weak, nonatomic) IBOutlet UILabel *maxConnections;
@property (weak, nonatomic) IBOutlet UILabel *theAuthenticationLabel;
@property (weak, nonatomic) IBOutlet UIStepper *refreshStepper;
@property (weak, nonatomic) IBOutlet UIStepper *maxStepper;

- (IBAction)changeRefreshValue:(id)sender;
- (IBAction)changeMaxConnectionsValue:(id)sender;

@end
