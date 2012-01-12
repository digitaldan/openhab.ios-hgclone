//
//  openhabTableViewCellList.m
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

#import "openhabTableViewCellList.h"

@implementation openhabTableViewCellList
@synthesize theControl;
-(void)loadWidget:(openhabWidget *)theWidget
{
    [super loadWidget:theWidget];
	
	[theControl removeAllSegments];
	[theControl setApportionsSegmentWidthsByContent:YES];
	openhabMapping*map;
	
	if ([theWidget.item.type isEqualToString:@"RollershutterItem"]) {
		// If rollershutter put images
		
		// Insert Segments
		for (int i=0; i<[theWidget.mappings count];i++) {
			map=[theWidget.mappings objectAtIndex:i];
			[theControl setContentMode:UIViewContentModeScaleToFill];
			[theControl insertSegmentWithImage:[UIImage imageNamed:map.label] atIndex:i animated:NO];
		}
	}
	else
	{
		// Insert Segments
		for (int i=0; i<[theWidget.mappings count];i++) {
			map=[theWidget.mappings objectAtIndex:i];
			[theControl insertSegmentWithTitle:map.label atIndex:i animated:NO];	
		}
		if ([theControl numberOfSegments]!=1 && ![theWidget.item.type
												  isEqualToString:@"RollershutterItem"])
		{
			//[theControl setSelectedSegmentIndex:0];
			for (int i=0; i<[theWidget.mappings count];i++) {
				map=[theWidget.mappings objectAtIndex:i];
				if (widget.item && [widget.item.state isEqualToString:map.command])
					[theControl setSelectedSegmentIndex:i];
			}
		}
		
		// IF IPAD
		
		// Return YES for supported orientations
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
}

-(BOOL)mayBeModified
{
	return YES;
}
-(IBAction)changeValue:(id)sender
{

	if ([sender isKindOfClass:[UISegmentedControl class]])
	{
		openhabMapping*theCommand=[widget.mappings objectAtIndex:[theControl selectedSegmentIndex]];
		// Change the state of the item
		if ([theControl numberOfSegments]!=1 && ![widget.item.type
												  isEqualToString:@"RollershutterItem"])
			[widget.item setState:theCommand.command];
		NSLog(@"Value changed to %@",theCommand.label);
		[[openhab sharedOpenHAB] changeValueofItem:self.widget.item toValue:theCommand.command];
		[[openhab sharedOpenHAB] refreshSitemap];
	}
}

@end
