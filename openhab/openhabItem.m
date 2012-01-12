//
//  openhabItem.m
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

@implementation openhabItem

@synthesize type;
@synthesize name;
@synthesize link;
@synthesize state;
@synthesize groups;

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		groups=[[NSMutableSet alloc]initWithCapacity:0];
    }
    
    return self;
}

- (id)copy
{
	openhabItem*theCopy=[openhabItem alloc];
	theCopy.type=[self.type copy];
	theCopy.name=[self.name copy];
	theCopy.link=[self.link copy];
	theCopy.state=[self.state copy];
	theCopy.groups=[self.groups copy];
	return theCopy;
}

-(openhabItem*)initWithDictionary:(NSDictionary*)dictionary
{
    [self setLink:[dictionary valueForKey:@"link"]];
    [self setType:[dictionary valueForKey:@"type"]];
    [self setName:[dictionary valueForKey:@"name"]];
    [self setState:[dictionary valueForKey:@"state"]];
	groups=[[NSMutableSet alloc]initWithCapacity:0];
    //[self setGroups:[dictionary valueForKey:@"groups"]];
    return self;
}

#pragma mark - Descriptions

- (NSString*)membersName
{
	NSMutableString*temp=[[NSMutableString alloc]initWithCapacity:0];
	for (openhabItem*n in self.groups) {
		temp=(NSMutableString*)[temp stringByAppendingFormat:@"%@ ",n.name];
	}
	return temp;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@, Groups:%@",name,type,state,link, [self membersName]];
}


@end
