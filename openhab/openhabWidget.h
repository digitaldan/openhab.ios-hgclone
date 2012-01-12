//
//  openhabWidget.h
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

#import "openhabItem.h"
#import "openhabMapping.h"

/* Widgets are
 
 ((Switch | Selection | Slider | List) or (Text | Group | Image | Frame)
 */



@interface openhabWidget : NSObject
{
	NSString *type; // All widgets have type
    NSString *label; // All have labels
    NSString *icon; // Maybe icon
    UIImage*iconImage; // Maybe an iconImage
	UIImage*Image; // Maybe an Image
	NSString*imageURL; //Maybe an image url
    openhabItem *item; // Maybe item
    NSMutableArray *widgets; //  (Text | Group | Image | Frame) may contain otro widget
	NSMutableArray *mappings; // We may have mappings. Mappings are objects with a couple (command, label)
	NSString *data; // Maybe label has [localized data]
}

@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *label;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) UIImage *iconImage;
@property (nonatomic,strong) UIImage *Image;
@property (nonatomic,strong) NSString*imageURL;
@property (nonatomic,strong) openhabItem *item;
@property (nonatomic,strong) NSMutableArray *widgets;
@property (nonatomic,strong) NSMutableArray *mappings;
@property (nonatomic,strong) NSString *data;

-(openhabWidget*)initWithDictionary:(NSDictionary*)dictionary;

// itemTypes: 1 Switch | 2 Selection | 3 Slider | 4 List
//groupWidgettypes itemTypes: 5 Text | 6 Group | 7 Image | 8 Frame
// 0 for unknown type
-(NSInteger)widgetType;

-(NSString*)structure;
@end
