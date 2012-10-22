//
//  openhabItem.h
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


#import <Foundation/Foundation.h>

/*
 Los items may be groups or:
 
 'Switch' | 'Rollershutter' | 'Number' | 'String' | 'Dimmer' | 'Contact' | 'DateTime' | ID
 
 */

@interface openhabItem : NSObject
{
    NSString *type;
    NSString *name;
    NSString *state;
    NSString *link;
    NSMutableSet *groups;
}

@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSMutableSet *groups;

// Initialize with a dictionary
-(openhabItem*)initWithDictionary:(NSDictionary*)dictionary;
@end