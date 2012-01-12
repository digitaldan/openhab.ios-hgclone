//
//  openhabTableViewCellSwitch.m
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

#import "openhabTableViewCellSwitch.h"

@implementation openhabTableViewCellSwitch
@synthesize theSwitch;

-(void)loadWidget:(openhabWidget *)theWidget
{
    [super loadWidget:theWidget];
    if ([theWidget.item.state rangeOfString:@"ON"].location!=NSNotFound)
    {
        [self.theSwitch setOn:YES];
    }
    else
    {
        [self.theSwitch setOn:NO];
    }
}

-(BOOL)mayBeModified
{
	return YES;
}
-(IBAction)changeValue:(id)sender
{
    if ([sender isKindOfClass:[UISwitch class]])
    {
        NSLog(@"Value switched, %i",[self.theSwitch isOn]);
        if ([self.theSwitch isOn]) {
            [[openhab sharedOpenHAB] changeValueofItem:self.widget.item toValue:@"ON"];
            self.widget.item.state=@"ON";
        }
        else
        {
            [[openhab sharedOpenHAB] changeValueofItem:self.widget.item toValue:@"OFF"];
            self.widget.item.state=@"OFF";
        }
        
//        // Refresh sitemap and icon
        
        [[openhab sharedOpenHAB] refreshSitemap];
    }
}
@end
