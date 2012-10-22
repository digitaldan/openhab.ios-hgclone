//
//  openhabTableViewCellChart.m
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

#import "openhabTableViewCellChart.h"

@implementation openhabTableViewCellChart
@synthesize bigImage,theTimer;


-(void)launchDeletion
{
	self.widget.Image=nil;
	
	[[openhab sharedOpenHAB] deleteImage:self.widget.imageURL];
	// lets look for the image and download it
	[[openhab sharedOpenHAB] getImageWithURL:self.widget.imageURL];
}
-(void)loadWidget:(openhabWidget *)theWidget
{
    [super loadWidget:theWidget];
	//    self.bigImage;
	// Set the widget, the label and the image
    // Ask for the image
    
    if (self.widget.Image!=nil)
    {
        self.bigImage.image=self.widget.Image;
        [self.theSpinner stopAnimating];
		[self.theImage setHidden:YES];
		[self.label setHidden:YES];

		// v1.2 Schedule refresh
		if (self.widget.refresh>0 && !theTimer)
		{
			NSInteger refreshtime=self.widget.refresh/1000;
			theTimer=[NSTimer scheduledTimerWithTimeInterval:refreshtime target:self selector:@selector(launchDeletion) userInfo:nil repeats:YES];
		}
    }
    else
    {
		[self.theImage setHidden:NO];
		 [self.theSpinner startAnimating];
        // lets look for the image and download it
        [[openhab sharedOpenHAB] getImageWithURL:self.widget.imageURL];
    }
}

@end
