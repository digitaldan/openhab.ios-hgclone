//
//  openhabTableViewCellSetpoint.h
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

#import "openhabTableViewCellSetpoint.h"

@implementation openhabTableViewCellSetpoint
@synthesize theControl,detailLabel;

-(void)loadWidget:(openhabWidget *)theWidget
{
    [super loadWidget:theWidget];
	self.detailLabel.text=theWidget.data;
	
	[theControl removeAllSegments];
	[theControl setApportionsSegmentWidthsByContent:YES];
	openhabMapping*map;
	
	
	// v1.2
	
	
	/*Get a sorted array*/
	
	NSArray*theSortedKeys=[[theWidget.mappings allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]; // DOWN before UP
	int i=0;
	for (NSString*themapping in theSortedKeys) {
		map=[theWidget.mappings objectForKey:themapping];
		[theControl setContentMode:UIViewContentModeScaleToFill];
		[theControl insertSegmentWithImage:[UIImage imageNamed:map.label] atIndex:i animated:NO];
		i++;
	}
	
	// IF IPAD
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
		// Resize if less than 5
		int segmentWidth=60;
		CGRect oldframe=theControl.frame;
		CGFloat x=oldframe.origin.x;
		
		// If we have note resized, resize
		if (theControl.numberOfSegments<6 && (oldframe.size.width/theControl.numberOfSegments)!=segmentWidth)
		{
			int difference=oldframe.size.width-theControl.numberOfSegments*segmentWidth;
			oldframe.size.width=theControl.numberOfSegments*segmentWidth;
			oldframe.origin.x=x+difference;
			theControl.frame=oldframe;
		}
	}
}


-(BOOL)mayBeModified
{
	return YES;
}
-(IBAction)changeValue:(id)sender
{
	
	if ([sender isKindOfClass:[UISegmentedControl class]])
	{
		NSArray*theSortedKeys=[[widget.mappings allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]; // DOWN before UP

		NSString*selection=[theSortedKeys objectAtIndex:[theControl selectedSegmentIndex]];
		openhabMapping*theCommand=[widget.mappings objectForKey:selection];
		// Change the state of the item
		float newValue=[self.widget.item.state floatValue];
		if ([theCommand.label isEqualToString:@"UP"] && widget.maxValue>newValue)
		{
			newValue+=widget.step;
			widget.item.state=[NSString stringWithFormat:@"%f",newValue];
			NSLog(@"Value changed to %@",[NSString stringWithFormat:@"%f",newValue]);
			[[openhab sharedOpenHAB] changeValueofItem:self.widget.item toValue:[NSString stringWithFormat:@"%f",newValue]];
			//[[openhab sharedOpenHAB] refreshSitemap];

		}
		else if ([theCommand.label isEqualToString:@"DOWN"] && widget.minValue<newValue)
		{
			newValue-=widget.step;
			widget.item.state=[NSString stringWithFormat:@"%f",newValue];
			NSLog(@"Value changed to %@",[NSString stringWithFormat:@"%f",newValue]);
			[[openhab sharedOpenHAB] changeValueofItem:self.widget.item toValue:[NSString stringWithFormat:@"%f",newValue]];
			//[[openhab sharedOpenHAB] refreshSitemap];

		}
		else
		{
			NSLog(@"Boundaries reached: Max %f,Min %f,step %f, current: %@",widget.maxValue,widget.minValue,widget.step,widget.item.state);
		}
	}
}

@end
