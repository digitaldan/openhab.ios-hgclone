//
//  openhabTableViewCellSlider.m
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

#import "openhabTableViewCellSlider.h"

@implementation openhabTableViewCellSlider
@synthesize detailLabel,theSlider,times,theTimer;


-(void)loadWidget:(openhabWidget *)theWidget
{
    [super loadWidget:theWidget];

	if (!self.sliding)
	{	// V1.2 Do not change the value if refreshing
		[theSlider setValue:[theWidget.item.state floatValue]];
	}

	// v1.2 modified to show data
	
	if (theWidget.data)
	{
		detailLabel.text=theWidget.data;
		[detailLabel setHidden:NO];
	}
	else
		[detailLabel setHidden:YES];
}

-(BOOL)mayBeModified
{
	return YES;
}

-(void)resetTimes
{
	NSLog(@"reset time");
	times=0;
}

-(IBAction)startDragging:(id)sender
{
	[openhab sharedOpenHAB].refreshing=YES;
	[[openhab sharedOpenHAB] cancelPolling];
	self.sliding=YES;
	times=1;
	theTimer=[NSTimer scheduledTimerWithTimeInterval:self.widget.sendFrequency target:self selector:@selector(resetTimes) userInfo:nil repeats:NO];
}
-(IBAction)stopDragging:(id)sender
{
	if ([sender isKindOfClass:[UISlider class]])
    {
		NSString*theStringValue=[NSString stringWithFormat:@"%.0f",[theSlider value]];
		if (theSlider.value==0)
			NSLog(@"!!!!!");
        NSLog(@"Value changed, %@",theStringValue);
		self.widget.item.state=theStringValue;
        [[openhab sharedOpenHAB] changeValueofItem:self.widget.item toValue:theStringValue];
		times=0;
    }
	self.sliding=NO;
	[openhab sharedOpenHAB].refreshing=NO;
	[[openhab sharedOpenHAB] longPollCurrent];
	[[openhab sharedOpenHAB] refreshPage:[openhab sharedOpenHAB].currentPage];
}

-(IBAction)changeValue:(id)sender
{
    if (times==0)
    {
		UISlider *newSlider=(UISlider*)sender;
		NSString*theStringValue=[NSString stringWithFormat:@"%.0f",[newSlider value]];
		self.widget.item.state=theStringValue;
		NSLog(@"Value changed, %@",self.widget.item.state);
        [[openhab sharedOpenHAB] changeValueofItem:self.widget.item toValue:theStringValue];
        times++;
		theTimer=[NSTimer scheduledTimerWithTimeInterval:self.widget.sendFrequency target:self selector:@selector(resetTimes) userInfo:nil repeats:NO];
    }
}

@end
