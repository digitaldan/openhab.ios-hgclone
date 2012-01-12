//
//  infoViewController.m
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

#import "infoViewController.h"

@interface infoViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation infoViewController
@synthesize toBeLocalizedSomeStats = _toBeLocalizedSomeStats;
@synthesize theTextView = _theTextView;
@synthesize donateButton = _donateButton;

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
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.donateButton.title=NSLocalizedString(@"Donations", @"Donations");
	self.navigationItem.title=NSLocalizedString(@"Info", @"Info");
	self.theTextView.text=NSLocalizedString(@"InfoText", @"InfoText");
	
	float size=[[openhab sharedOpenHAB].queue sizeDownloaded]/1024.0;
	
	self.toBeLocalizedSomeStats.text=[NSString stringWithFormat:NSLocalizedString(@"Stats3", @"Stats3"),[[openhab sharedOpenHAB].queue Allpetitions],size,[[openhab sharedOpenHAB].imagesArray count]];
}

- (void)viewDidUnload
{
	[self setTheTextView:nil];
	[self setToBeLocalizedSomeStats:nil];
    [self setDonateButton:nil];
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

@end
