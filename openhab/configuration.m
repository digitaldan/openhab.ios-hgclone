//
//  configuracion.m
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

#import "configuration.h"

@implementation configuration

+ (NSString*)inicializaPlist
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
	else
	{
		// Update non existing settings
		
		// Get the old one
		NSMutableDictionary *diccionarioAntiguo = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		
		// Get the new one
		
		NSURL *bundle = [[NSBundle mainBundle] URLForResource:@"data" withExtension:@"plist"];
		NSData *tmp = [NSData dataWithContentsOfURL:bundle options:NSDataReadingMappedIfSafe error:nil];
		NSDictionary *diccionarioNuevo = [NSPropertyListSerialization propertyListWithData:tmp options:NSPropertyListImmutable format:nil error:nil];
		
		NSMutableArray *newKeys=[[diccionarioNuevo allKeys] mutableCopy];
		[newKeys removeObjectsInArray:[diccionarioAntiguo allKeys]];
		
		for (NSString*key in newKeys) {
			[diccionarioAntiguo setObject:[diccionarioNuevo objectForKey:key] forKey:key];

		}
		[diccionarioAntiguo writeToFile:path atomically:YES];
	}
    return path;
}

+ (NSObject*)readPlist:(NSString*)dato
{
    
    NSMutableDictionary *diccionario = [[NSMutableDictionary alloc] initWithContentsOfFile: [configuration inicializaPlist]];
    
    NSObject* value = [[diccionario objectForKey:dato]copy];
    //NSLog(@"Leido %@",value);
    return value;
}

+ (void)writeToPlist:(NSString*)dato valor:(NSObject*)value
{
    NSString*path=[self inicializaPlist];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    //here add elements to data file and write data to file
    [data setObject:value forKey:dato];
    [data writeToFile: path atomically:YES];
}

@end
