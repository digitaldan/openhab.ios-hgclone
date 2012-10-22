//
//  openhabWidget.m
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

#import "openhabWidget.h"

@implementation openhabWidget
@synthesize type,label,icon,imageURL,Image,data,item,widgets,mappings,iconImage,linkedPage,theWidgetUrl,service,period,refresh,height;

#pragma mark - init method

-(openhabWidget*)initWithDictionary:(NSDictionary*)dictionary
{
    // Get the values
    [self setType:[dictionary valueForKey:@"type"]];
    [self setLabel:[dictionary valueForKey:@"label"]];
    [self setIcon:[dictionary valueForKey:@"icon"]];
    [self setItem:nil];
    [self setData:nil];
    [self setIconImage:nil];
	[self setImage:nil];
	[self setImageURL:nil];
	[self setTheWidgetUrl:nil];
	[self setHeight:0];
	[self setWidgets:[[NSMutableArray alloc] initWithCapacity:0]];
    [self setMappings:[[NSMutableDictionary alloc] initWithCapacity:0]];
	[self setLinkedPage:[[dictionary objectForKey:@"linkedPage"] objectForKey:@"id"]];
	[self setService:[dictionary objectForKey:@"service"]];
	[self setPeriod:[dictionary objectForKey:@"period"]];
	[self setRefresh:0];
	
    // Copy the localized part of the label inside "[...]"
    NSRange begin=[self.label rangeOfString:@"["];
    
    if (begin.location != NSNotFound)
    {
        // Divide in two
        
        NSArray* temp=[self.label componentsSeparatedByString:@"["];
        
        // Copy the label
        self.label=[[temp objectAtIndex:0]copy];
        self.data= [[[temp objectAtIndex:1] componentsSeparatedByString:@"]"]objectAtIndex:0];
    }
	
	// We do not have either item nor widgets set.
	return self;
}

#pragma mark - convenience methods

- (NSString*)description
{
    NSMutableString* text=[NSString stringWithFormat:@"type: %@,label: %@,icon: %@,item: %@.\n",type,label,icon,item];
    for (openhabWidget*widget in self.widgets) {
        text=(NSMutableString*)[text stringByAppendingFormat:@"widget --->:%@    %@\n",[widget label],[widget description]];
    }
    return text;
}
-(openhabWidget*)copy
{
	openhabWidget*new=[openhabWidget new];
	new.type=[self.type copy];
	new.label=[self.label copy];
	new.icon=[self.icon copy];
	new.linkedPage=[self.linkedPage copy]; // v1.2
	new.iconImage=[self.iconImage copy];
	new.Image=[self.Image copy];
	new.imageURL=[self.imageURL copy];
	new.item=[self.item copy];
	new.widgets=[self.widgets copy];
	new.mappings=[self.mappings copy];
	new.data=[self.data copy];
	new.theWidgetUrl=[self.theWidgetUrl copy]; // v1.2
	new.sendFrequency=self.sendFrequency;
	new.minValue=self.minValue;
	new.maxValue=self.maxValue;
	new.step=self.step;	// v1.2 Sliders may have send frequency
	// and setpoint values
	new.height=self.height; // V1.2 Might have height value
	new.service=[self.service copy];
	new.period=[self.period copy];
	new.refresh=self.refresh;
	return new;
}

-(NSString*)structure
{
    NSMutableString* text=[NSString stringWithFormat:@"--->%@",label];
    if (self.widgets!=nil)
    {
        text=(NSMutableString*)[text stringByAppendingString:@" --> "];
        for (openhabWidget*widget in self.widgets) {
            text=(NSMutableString*)[text stringByAppendingFormat:@"  %@ ",[widget structure]];
        }
    }
    text=(NSMutableString*)[text stringByAppendingString:@"\n"];
    return text;
}

-(NSInteger)widgetType
{
    // itemTypes: Switch | Selection | Slider | List | Setpoint |WebView | Video | chart
    //groupWidgettypes itemTypes: Text | Group | Image | Frame
    // 0 for unknown type
	
	/*
	 "- Then, when I find a switch widget, I must check if it has mappings  to show a (short) number of buttons instead of a switch that will  send commands. --> LISTSWITCH
	 - and also, If it is a switch, check if it is a rollershutter to  show a three button widget? --> LISTSWITCH
	 - And, On the other hand, Dimmer and Rollershutters can come on  "slider" widgets?
	 - List widget will have mappings
	 - Selection widget will have mappings"
	 */
	
    if ([self.type rangeOfString:@"Switch"].location!=NSNotFound)
    {
		if ([self.mappings count]>0) {
			return 4;
		}
		if (self.item) // This is a rollershutter
			if ([self.item.type isEqualToString:@"RollershutterItem"])
			{		
				[self.mappings setObject:[[openhabMapping alloc] initwithStrings:@"DOWN" label:@"DOWN"] forKey:@"DOWN"] ;
				[self.mappings setObject:[[openhabMapping alloc] initwithStrings:@"STOP" label:@"STOP"] forKey:@"STOP"];
				[self.mappings setObject:[[openhabMapping alloc] initwithStrings:@"UP" label:@"UP"] forKey:@"UP"];
				return 4;
			}
        return 1;
    }
    else if ([self.type rangeOfString:@"Selection"].location!=NSNotFound)
    {
        return 2;
    }
    else if ([self.type rangeOfString:@"Slider"].location!=NSNotFound)
    {
        return 3;
    }
    else if ([self.type rangeOfString:@"List"].location!=NSNotFound)
    {
        return 4;
    }
    else if ([self.type rangeOfString:@"Text"].location!=NSNotFound)
    {
		if ([self.widgets count]==0) {
			return 9;
		}
        return 5;
    }
    else if ([self.type rangeOfString:@"Group"].location!=NSNotFound)
    {
        return 6;
    }
    else if ([self.type rangeOfString:@"Image"].location!=NSNotFound)
    {
		if ([self.widgets count]==0) {
			return 10;
		}
        return 7;
    }
    else if ([self.type rangeOfString:@"Frame"].location!=NSNotFound)
    {
        return 8;
    }
	// v1.2 Setpoint
	else if ([self.type rangeOfString:@"Setpoint"].location!=NSNotFound)
    {
		// We map the two buttons
		if ([self.mappings count]==0)
		{
			[self.mappings setObject:[[openhabMapping alloc] initwithStrings:@"DOWN" label:@"DOWN"] forKey:@"DOWN"];
			[self.mappings setObject:[[openhabMapping alloc] initwithStrings:@"UP" label:@"UP"] forKey:@"UP"];
		}
        return 11;
    }
	else if ([self.type rangeOfString:@"Webview"].location!=NSNotFound)
	{
		return 12;
	}
	else if ([self.type rangeOfString:@"Video"].location!=NSNotFound)
	{
		return 14;
	}
	else if ([self.type rangeOfString:@"Chart"].location!=NSNotFound)
	{
		return 16;
	}
    else
    {
        NSLog(@"ERROR: Unknown type of widget,%@",self);
        return 0;
    }    
}

-(NSUInteger)count
{
	NSUInteger temp=1;
	for (openhabWidget*w in self.widgets) {
		temp+=[w count];
	}
	return temp;
}
-(void)buildChartingURLString:(NSString*)baseURL
{
	// SHOULD CHECK FOR SERVICE! IF NOT RRD WE SHOULD CHANGE THIS
	NSString* theURLofChart=[baseURL stringByAppendingString:@"rrdchart.png?"];
	
	// v1.2 sample url  http://demo.openhab.org:8080/rrdchart.png?groups=Weather_Chart&period=d
	
	if ([self.item.type isEqualToString:@"GroupItem"])
		theURLofChart=[theURLofChart stringByAppendingFormat:
					   @"groups=%@",self.item.name];
	else
		theURLofChart=[theURLofChart stringByAppendingFormat:
					   @"items=%@",self.item.name];
	
	theURLofChart=[theURLofChart stringByAppendingFormat:
				   @"&period=%@",self.period];
	
	self.imageURL=theURLofChart;
}

@end
