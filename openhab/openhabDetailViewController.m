//
//  openhabDetailViewController.m
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

#import "openhabDetailViewController.h"

@interface openhabDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
-(void)enableRefresh;
-(void)disableRefresh;

-(void)initProgressHUD:(NSString*)text;
-(void)setProgress:(float)progress withText:(NSString*)text;
-(void)hideProgressHUD;
-(void)hideLoad;

@end

@implementation openhabDetailViewController
@synthesize theLoadingView;
@synthesize loadingLabel,HUD,progressTimer,alert,refreshTimer,loadingSpinner,myWidgets,masterPopoverController = _masterPopoverController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.refreshTimer=nil;
        self.HUD=nil;
        self.alert=nil;
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
    // Load openhab
    
	openhab*oh=[openhab sharedOpenHAB];
    self.loadingLabel.text=[NSString stringWithFormat:NSLocalizedString(@"LoadingSitemapUrl2", @"LoadingSitemapUrl2"),[configuration readPlist:@"BASE_URL"],[configuration readPlist:@"map"]];
    if (oh.delegate!=self) {
        [oh setDelegate:self];
    }
    if (!oh.sitemapLoaded)
    {
        [self initProgressHUD:NSLocalizedString(@"Loading",@"Loading")];
		[HUD setDetailsLabelText:NSLocalizedString(@"LoadingItems",@"LoadingItems")];
        [oh initSitemap];
    }
    else
    {
        [self.loadingLabel setHidden:YES];
        [self.loadingSpinner setHidden:YES];
        [self.theLoadingView setHidden:YES];
        //[oh changeValueofItem:[[oh arrayItems] objectAtIndex:1] toValue:@"ON"];
    }
}

- (void)viewDidUnload
{
    theLoadingView = nil;
    self.refreshTimer=nil;
    self.HUD=nil;
    [self setTheLoadingView:nil];
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
	// If it is not loaded, move
	if (![openhab sharedOpenHAB].itemsLoaded) {
		[self.loadingLabel setHidden:NO];
		[self.loadingSpinner setHidden:NO];
		[self.theLoadingView setHidden:NO];
	}
    
    // If sitemap is loaded, set the refresh
    if ([openhab sharedOpenHAB].sitemap && self.refreshTimer==nil)
        [self enableRefresh];
	if ([openhab sharedOpenHAB].delegate!=self)
	{
		[[openhab sharedOpenHAB] setDelegate:self];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Disable the refresh whan we will disappear
    [self disableRefresh];
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self.tableView reloadData];
	[self.tableView.window.rootViewController.view setNeedsLayout];
}

#pragma mark - tableview methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Count the number of sections. They are "frame" widgets
    NSInteger i=0;
    for (openhabWidget*w in self.myWidgets) {
        if ([w widgetType]==8)
            i++;
    }
    if (i==0)
        i++;
    return i;
}


- (NSArray*)WidgetsInSection:(NSUInteger)section
{
    NSUInteger i = 0;
    NSArray *wtemp=nil;
    for (openhabWidget*w in self.myWidgets) {
        if ([w widgetType]==8)
        {
            if (i==section)
                wtemp=w.widgets;
            i++;
        }
    }
    if (i==0)
	{
		return self.myWidgets;
	}
    return wtemp;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self WidgetsInSection:section] count];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Contar el numero de frames
    NSUInteger i = 0;
    NSString*val=@"";
    for (openhabWidget*w in self.myWidgets) {
        if ([w widgetType]==8)
            if (i==section)
                val=w.label;
		i++;
    }
	
    return val;
}



-(openhabTableViewCell*)recycleCell:(NSString*)type withWidget:(openhabWidget*)widget
{
    // itemTypes: 1 Switch | 2 Selection | 3 Slider | 4 List
    //groupWidgettypes itemTypes: 5 Text | 6 Group | 7 Image | 8 Frame
    
    openhabTableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:type];
    
    switch ([widget widgetType]) {
        case 1:
            if (cell == nil) {
                cell = [[openhabTableViewCellSwitch alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:type];
            }
            
            break;
        case 2:
            if (cell == nil) {
                cell = [[openhabTableViewCellSelection alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:type];
            }
            break;
        case 3:
            if (cell == nil) {
                cell = [[openhabTableViewCellSlider alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:type];
            }
            break;
        case 4:
            if (cell == nil) {
                cell = [[openhabTableViewCellList alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:type];
            }
            break;
        case 5 | 9:
            if (cell == nil) {
                cell = [[openhabTableViewCelltext alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:type];
            }
            break;
        case 6:
            if (cell == nil) {
                cell = [[openhabTableViewCellgroup alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:type];
            }
            break;
        case 7 | 10:
            if (cell == nil) {
                cell = [[openhabTableViewCellimage alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:type];
            }
            break;
        case 8:
            break;
        default:
            if (cell == nil) {
                cell = [[openhabTableViewCelltext alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:type];
            }
            break;
 
    }
    [cell loadWidget:widget];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	openhabWidget*widget=[[self WidgetsInSection:indexPath.section] objectAtIndex:indexPath.row];
	CGFloat theHeight=44;

	if (widget.Image!=nil)
	{
		CGFloat theWidth;
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
		{
			if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
				theWidth=270;
			}
			else
			{
				theWidth=430;
			}
		}
		else
			theWidth=595;
		
		theHeight=theWidth*[widget.Image size].height/[widget.Image size].width;
	}
	return theHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // itemTypes: 1 Switch | 2 Selection | 3 Slider | 4 List
    //groupWidgettypes itemTypes: 5 Text | 6 Group | 7 Image | 8 Frame
    
    openhabTableViewCell *cell;
    openhabWidget*widget=[[self WidgetsInSection:indexPath.section] objectAtIndex:indexPath.row];
    
	/*
	 "- Then, when I find a switch widget, I must check if it has mappings  to show a (short) number of buttons instead of a switch that will  send commands.
	 - and also, If it is a switch, check if it is a rollershutter to  show a three button widget?
	 - And, On the other hand, Dimmer and Rollershutters can come on  "slider" widgets?
	 - List widget will have mappings
	 - Selection widget will have mappings"
	 */
	
    switch ([widget widgetType]) {
        case 1:
            cell=[self recycleCell:@"cellSwitch" withWidget:widget];
            break;
        case 2:
			if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone &&
				UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
				cell=[self recycleCell:@"cellSelectionH" withWidget:widget];
			else
				cell=[self recycleCell:@"cellSelection" withWidget:widget];
            break;
        case 3:
            cell=[self recycleCell:@"cellSlider" withWidget:widget];
            break;
        case 4:
            cell=[self recycleCell:@"cellList" withWidget:widget];
            break;
        case 5:
			if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone &&
				(UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ||
				 [widget.data isEqualToString:@""]|| widget.data==nil))
				cell=[self recycleCell:@"cellTextH" withWidget:widget];
			else
				cell=[self recycleCell:@"cellText" withWidget:widget];
            break;
        case 6:
			if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone &&
				(UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ||
				[widget.data isEqualToString:@""] || widget.data==nil))
				cell=[self recycleCell:@"cellGroupH" withWidget:widget];
			else
				cell=[self recycleCell:@"cellGroup" withWidget:widget];
            break;
        case 7:
            cell=[self recycleCell:@"cellImage" withWidget:widget];
            break;
        case 8:
            NSLog(@"ERROR: A frame is not a cell,%@",widget);
			widget.label=NSLocalizedString(@"ErrorSitemapConfig", @"ErrorSitemapConfig");
			cell=[self recycleCell:@"cellTextNoChildren" withWidget:widget];
            break;
		case 9:
			if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone &&
				UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
				cell=[self recycleCell:@"cellTextNoChildrenH" withWidget:widget];
			else
				cell=[self recycleCell:@"cellTextNoChildren" withWidget:widget];
            break;
		case 10:
			cell=[self recycleCell:@"cellImageNoChildren" withWidget:widget];
            break;
        default:
            NSLog(@"ERROR: Unknown type of widget,%@",widget);
            cell=[self recycleCell:@"cellText" withWidget:widget];
            break;
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue destinationViewController] isKindOfClass:[openhabDetailViewController class]])
	{
		openhabDetailViewController*dvc=[segue destinationViewController];
		openhabTableViewCell*selectedCell=(openhabTableViewCell*)sender;
		dvc.myWidgets=selectedCell.widget.widgets;
		openhab* sharedOH=[openhab sharedOpenHAB];
		[sharedOH setDelegate:dvc];
		dvc.navigationItem.title=[[selectedCell label] text];
	}
	else if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]] &&
			 [[[segue destinationViewController] topViewController] isKindOfClass:[openhabTebleViewCellSelectionDetail class]])
	{
		openhabTebleViewCellSelectionDetail*dvc=(openhabTebleViewCellSelectionDetail*)[(UINavigationController*)[segue destinationViewController]topViewController];
		dvc.lastTableView=self.tableView;
		openhabTableViewCell*selectedCell=(openhabTableViewCell*)sender;
		dvc.widget=selectedCell.widget;
		dvc.navigationItem.title=[[selectedCell label] text];
	}
	else
	{
		// Do nothin
	}
}
#pragma mark - Refresh the sitemap



-(void)refreshTableandSitemap
{
	if ([openhab sharedOpenHAB].sitemapLoaded && ![openhab sharedOpenHAB].refreshing)
	{
		self.navigationItem.title=[self.navigationItem.title stringByAppendingFormat:@"...%@",NSLocalizedString(@"Refreshing", @"Refreshing")];
		[[openhab sharedOpenHAB] refreshItems];
		[[openhab sharedOpenHAB] refreshSitemap];
	}
}

-(IBAction)refreshTableandSitemap:(id)sender
{
	if (![openhab sharedOpenHAB].refreshing)
	{
		[self initProgressHUD:NSLocalizedString(@"Refreshing", @"Refreshing")];
		[self refreshTableandSitemap];
	}
}

-(void)enableRefresh
{
    double ref=[(NSNumber*)[configuration readPlist:@"refresh"] doubleValue];
    if (ref>0)
        self.refreshTimer=[NSTimer scheduledTimerWithTimeInterval:ref target:self selector:@selector(refreshTableandSitemap) userInfo:nil repeats:YES];
}
-(void)disableRefresh
{
    if (self.refreshTimer)
        [self.refreshTimer invalidate];
    self.refreshTimer=nil;
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

#pragma mark - openHABProtocol
-(void)itemsLoaded
{
    NSLog(@"Items loaded");
    [self setProgress:(1.0/3.0) withText:NSLocalizedString(@"LoadingGroups",@"LoadingGroups")];
}
-(void)groupsLoaded
{
    NSLog(@"Groups loaded");
    [self setProgress:(2.0/3.0) withText:NSLocalizedString(@"LoadingSitemap",@"LoadingSitemap")];

}
-(void)sitemapLoaded
{
    NSLog(@"Sitemap loaded");
    [self.loadingLabel setHidden:YES];
    [self.loadingSpinner setHidden:YES];
    [self.theLoadingView setHidden:YES];
    
    if (self.myWidgets==nil)
        self.myWidgets=[[openhab sharedOpenHAB] sitemap];
    [self setProgress:(3.0/3.0) withText:NSLocalizedString(@"SitemapLoaded",@"SitemapLoaded")];
	
	// NEW: CHANGE TITLE
	if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"Loading",@"Loading")])
	{
		self.navigationItem.title = [openhab sharedOpenHAB].sitemapName;
	}
	
    [self.tableView reloadData];
    if (HUD!=nil && ([[openhab sharedOpenHAB].queue operations]+[[openhab sharedOpenHAB].queue operationsInQueue])<=0)
	{
        [self hideProgressHUD];
	}

}
-(void)valueOfItemChangeRequested:(openhabItem*)theItem
{
    NSLog(@"Value of %@ changed to %@!",theItem.name,theItem.state);
	// [[openhab sharedOpenHAB] refreshSitemap];
}
-(void)itemsRefreshed
{
    NSLog(@"Items refreshed");
    [self setProgress:(1.0/2.0) withText:NSLocalizedString(@"ItemsRefreshed",@"ItemsRefreshed")];
    
}
-(void)sitemapRefreshed
{
    NSLog(@"Sitemap refreshed");
    
    // IF we have not yet set the refresh, set it now
    if ([openhab sharedOpenHAB].sitemap && self.refreshTimer==nil)
        [self enableRefresh];
    [self setProgress:(2.0/2.0) withText:@"Sitemap Refreshed"];
	NSArray*temp=[self.navigationItem.title componentsSeparatedByString:@"."];
	if ([temp count]>1)
	{
		self.navigationItem.title=[temp objectAtIndex:0];
	}
	if (HUD!=nil && ([[openhab sharedOpenHAB].queue operations]+[[openhab sharedOpenHAB].queue operationsInQueue])<=0)
        [self hideProgressHUD];
    [self.tableView reloadData];
}
-(void)imagesRefreshed
{
    
    float a=[[openhab sharedOpenHAB].queue operations];
    a+=[[openhab sharedOpenHAB].queue operationsInQueue];
    if (a==0)
        a++;
    [self setProgress:(1/a) withText:[NSString stringWithFormat:NSLocalizedString(@"ImageRefreshed1",@"ItemsRefreshed"),a]];
	NSLog(@"Images refreshed, left %.0f",a);
    [self.tableView reloadData];
}
-(void)requestFailed:(commLibrary*)request withError:(NSError*)error
{
    NSLog(@"ERROR: Request %@ failed with error: %@",request,error);
	
	[self hideLoad];
    if (alert==nil) {
        alert=[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)JSONparseError:(NSString*)parsePhase withError:(NSError*)error
{
	
	[self hideLoad];
    NSLog(@"ERROR: JSON parse %@ failed with error: %@",parsePhase,error);
    if (alert==nil) {
        alert=[[UIAlertView alloc] initWithTitle:@"Error parsing Response" message:[NSString stringWithFormat:NSLocalizedString(@"ParserFormat2",@"ParserFormat2"),parsePhase,error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)allRequestsFinished
{
    if (HUD!=nil && ([[openhab sharedOpenHAB].queue operations]+[[openhab sharedOpenHAB].queue operationsInQueue])<=0)
        [self hideProgressHUD];
    NSLog(@"Request queue empty");
}

#pragma mark - progresshud



-(void)hideLoad
{
	[self.loadingLabel setHidden:YES];
	[self.loadingSpinner setHidden:YES];
	[self.theLoadingView setHidden:YES];
    NSArray*temp=[self.navigationItem.title componentsSeparatedByString:@"."];
	if ([temp count]>1)
	{
		self.navigationItem.title=[temp objectAtIndex:0];
	}
    [self hideProgressHUD];
}

-(void)goProgress
{
	double p=[HUD progress];
	if (p>=1)
		p=0;
	[HUD setProgress:p+0.005];
}

-(void)initProgressHUD:(NSString*)text
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [HUD setProgress:0];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:text];
	[HUD setTaskInProgress:YES];
	[HUD setGraceTime:1.0];
    [self.navigationController.view addSubview:HUD];
	self.progressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(goProgress) userInfo:nil repeats:YES];
    [HUD show:YES];
}


-(void)setProgress:(float)progress withText:(NSString*)text
{
    if (HUD!=nil)
    {
        [HUD setMode:MBProgressHUDModeDeterminate];
        [HUD setProgress:progress];
        [HUD setDetailsLabelText:text];
    }
}

-(void)reallyHideProgressHUD
{
	if (HUD!=nil)
    {
		[HUD setTaskInProgress:NO];
        [HUD hide:YES afterDelay:1.0];
		[self.progressTimer invalidate];
		self.progressTimer=nil;
    }
}

-(void)hideProgressHUD
{
    if (HUD!=nil)
	{
		[HUD setMode:MBProgressHUDModeIndeterminate];
		[HUD setLabelText:NSLocalizedString(@"Alldone",@"Alldone")];
		[HUD setDetailsLabelText:NSLocalizedString(@"BuildingInterface",@"BuildingInterface")];
		[self reallyHideProgressHUD];
	}
}

@end
