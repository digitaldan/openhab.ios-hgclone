//
//  openhabImage.m
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
#import "openhabImage.h"

@implementation openhabImage
@synthesize image,name;

-(openhabImage*)initWithName:(NSString*)theName
{
	image=nil;
	name=theName;
	return self;
}
-(openhabImage*)initWithData:(NSData*)theData andName:(NSString*)theName
{
	image=[UIImage imageWithData:theData];
	name=theName;
	return self;
}

-(openhabImage*)initWithImage:(UIImage*)theImage andName:(NSString*)theName{
	image=theImage;
	name=theName;
	return self;
}

-(NSString*)description
{
	return self.name;
}
@end
