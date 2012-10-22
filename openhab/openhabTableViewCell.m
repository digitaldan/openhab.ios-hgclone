//
//  openhabTableViewCell.m
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

#import "openhabTableViewCell.h"

@implementation openhabTableViewCell
@synthesize widget,label,theImage,theSpinner,refreshIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadWidget:(openhabWidget*)theWidget
{
	// Set the widget, the label and the image
    // Ask for the image
    
    self.widget=theWidget;
    self.label.text=theWidget.label;
	
	// IF NOT AN IMAGE, check for icon
	if ([theWidget widgetType]!=7 && [theWidget widgetType]!=10)
	{
		if (theWidget.iconImage)
		{
			self.theImage.image=theWidget.iconImage;
			[self.theSpinner stopAnimating];
		}
		else
		{
			// lets look for the image and download it
			[[openhab sharedOpenHAB] getImage:theWidget.icon];
		}
	}
    if ([theWidget.widgets count]>0)
    {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    else
    {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}
-(BOOL)mayBeModified
{
	return NO;
}


-(IBAction)changeValue:(id)sender
{
	NSLog(@"ERROR: standard cell not switchable, %@",self);
}

@end
