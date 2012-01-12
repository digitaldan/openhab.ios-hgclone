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
@synthesize theSlider,times;

-(void)loadWidget:(openhabWidget *)theWidget
{
    [super loadWidget:theWidget];

	theSlider.value=[theWidget.item.state floatValue];
	
}

-(BOOL)mayBeModified
{
	return YES;
}

-(IBAction)startDragging:(id)sender
{
	[openhab sharedOpenHAB].refreshing=YES;
	times=0;

}
-(IBAction)stopDragging:(id)sender
{
	[openhab sharedOpenHAB].refreshing=NO;
	// Refresh sitemap and icon
	[[openhab sharedOpenHAB] refreshSitemap];
}

-(IBAction)changeValue:(id)sender
{
    if (times==0 && [sender isKindOfClass:[UISlider class]])
    {
		NSString*theStringValue=[NSString stringWithFormat:@"%.0f",[theSlider value]];
		if (theSlider.value==0)
			NSLog(@"!!!!!");
        NSLog(@"Value changed, %@",theStringValue);
		self.widget.item.state=theStringValue;
        [[openhab sharedOpenHAB] changeValueofItem:self.widget.item toValue:theStringValue];
        times=(times+1)%5;
    }
	else
	{
		times=(times+1)%5;
	}
}

@end
