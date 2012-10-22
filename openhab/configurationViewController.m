//
//  configurationViewController.m
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

#import "configurationViewController.h"
#import "configurationTableViewController.h"
#import "configurationLocalIPViewController.h"
#import "configurationMapViewController.h"
#import "configuration.h"
#import "loginViewController.h"

@interface configurationViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation configurationViewController
@synthesize labelServer = _labelServer;
@synthesize labelAlternateServer = _labelAlternateServer;
@synthesize labelSitemap = _labelSitemap;
@synthesize labelRefresh = _labelRefresh;
@synthesize labelMaxConnections = _labelMaxConnections;
@synthesize theUrl = _theUrl;
@synthesize theAlternateUrl = _theAlternateUrl;
@synthesize theSitemap = _theSitemap;
@synthesize refreshTime = _refreshTime;
@synthesize maxConnections = _maxConnections;
@synthesize theAuthenticationLabel = _theAuthenticationLabel;
@synthesize refreshStepper = _refreshStepper;
@synthesize maxStepper = _maxStepper;
@synthesize masterPopoverController = _masterPopoverController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title=NSLocalizedString(@"Configuration", @"Configuration");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload
{
    [self setRefreshTime:nil];
    [self setTheSitemap:nil];
    [self setTheUrl:nil];
    [self setMaxConnections:nil];
    [self setRefreshStepper:nil];
    [self setMaxStepper:nil];
	[self setLabelServer:nil];
	[self setLabelAlternateServer:nil];
	[self setTheAlternateUrl:nil];
	[self setLabelSitemap:nil];
	[self setLabelRefresh:nil];
	[self setLabelMaxConnections:nil];
	[self setTheAuthenticationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    } 
	self.theUrl.text=(NSString*)[configuration readPlist:@"BASE_URL"];
	self.theSitemap.text=(NSString*)[configuration readPlist:@"map"];
	
	self.labelServer.text=NSLocalizedString(@"labelServer", @"labelServer");
	self.labelRefresh.text=NSLocalizedString(@"labelRefresh", @"labelRefresh");
	self.labelMaxConnections.text=NSLocalizedString(@"labelMaxConnections", @"labelMaxConnections");
    
	
    [self.refreshStepper setValue:[(NSNumber*)[configuration readPlist:@"refresh"] doubleValue]];
    self.maxStepper.value=[(NSNumber*)[configuration readPlist:@"maxConnections"] doubleValue]; 
    
	self.refreshTime.text=[NSString stringWithFormat:@"%@",(NSNumber*)[configuration readPlist:@"refresh"]];

    self.maxConnections.text=[NSString stringWithFormat:@"%@",(NSNumber*)[configuration readPlist:@"maxConnections"]];
	// v1.2 get alternate url
	self.labelAlternateServer.text=NSLocalizedString(@"labelAlternateServer", @"labelAlternateServer");
	self.theAlternateUrl.text=[
						   (NSDictionary*)[configuration readPlist:@"alternateURLs"]
						  objectForKey:self.theUrl.text];
	self.theAuthenticationLabel.text=NSLocalizedString(@"theAuthenticationLabel",@"theAuthenticationLabel");
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

#pragma mark - Multiple Split view delegate

-(void)showButton:(UIBarButtonItem *)button pop:(UIPopoverController *)popover
{
    button.title = NSLocalizedString(@"Menu", @"Menu");
    [self.navigationItem setLeftBarButtonItem:button animated:YES];
    self.masterPopoverController = popover;
}

- (void)hideButton:(UIBarButtonItem *)button
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	UINavigationController*nvc=(UINavigationController*)[segue destinationViewController];
	if ([segue.identifier isEqualToString:@"urlConfigurationSegue"])
	{
		configurationTableViewController*dvc= (configurationTableViewController*)[nvc topViewController];
		dvc.navigationItem.title=NSLocalizedString(@"SetUrl", @"SetUrl");
		dvc.theField=@"BASE_URL";
		dvc.lastViewController=self;
	}
	else if ([segue.identifier isEqualToString:@"sitemapConfigurationSegue"])
	{
		configurationMapViewController*dvc= (configurationMapViewController*)[nvc topViewController];
		dvc.navigationItem.title=NSLocalizedString(@"SetSitemap", @"SetSitemap");;
		dvc.theField=@"map";
		dvc.lastViewController=self;
	}
	//v1.2 segue for login
	else if ([segue.identifier isEqualToString:@"loginSegue"])
	{
		loginViewController*dvc= (loginViewController*)[nvc topViewController];
		dvc.server=self.theUrl.text;
		// no need to save lastview
	}
	//v1.2 segue for alternate URL
	else if ([segue.identifier isEqualToString:@"serverAlternateSegue"])
	{
		configurationLocalIPViewController*dvc= (configurationLocalIPViewController*)[nvc topViewController];
		dvc.navigationItem.title=NSLocalizedString(@"SetUrl", @"SetUrl");
		dvc.theField=@"BASE_URL";
		dvc.lastViewController=self;
	}
	
}

- (IBAction)changeRefreshValue:(id)sender {
	UIStepper*stepperRefresh=(UIStepper*)sender;
	[configuration writeToPlist:@"refresh" valor:[NSNumber numberWithInt:stepperRefresh.value]];
    self.refreshTime.text=[NSString stringWithFormat:@"%@",(NSNumber*)[configuration readPlist:@"refresh"]];
    
}

- (IBAction)changeMaxConnectionsValue:(id)sender {
    UIStepper*stepperCon=(UIStepper*)sender;
	[configuration writeToPlist:@"maxConnections" valor:[NSNumber numberWithInt:stepperCon.value]];
    self.maxConnections.text=[NSString stringWithFormat:@"%@",(NSNumber*)[configuration readPlist:@"maxConnections"]];
}

@end
