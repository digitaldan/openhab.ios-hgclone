//
//  openhabMapping.m
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

#import "openhabMapping.h"

@implementation openhabMapping
@synthesize command,label;
-(openhabMapping*)initWithDictionary:(NSDictionary*)theDictionary
{
	self.command=[theDictionary valueForKey:@"command"];
	self.label=[theDictionary valueForKey:@"label"];
	return self;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"command: %@, label: %@",self.command,self.label];
}

-(openhabMapping*)initwithStrings:(NSString*)theCommand label:(NSString*)theLabel
{
	return [self initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:theLabel,@"label",theCommand, @"command", nil]];
}
@end
