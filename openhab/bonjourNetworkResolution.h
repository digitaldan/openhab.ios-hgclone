//
//  bonjourNetworkResolution.h
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
@protocol bonjourResolver;

@interface bonjourNetworkResolution : NSObject <NSNetServiceDelegate>
{
    // Keeps track of services handled by this delegate
    NSMutableArray *services;
	NSMutableArray *addresses;
	id <bonjourResolver> delegate;
}
@property (strong,nonatomic) id <bonjourResolver> delegate;
// NSNetService delegate methods for publication
- (void)netServiceDidResolveAddress:(NSNetService *)netService;
- (void)netService:(NSNetService *)netService
	 didNotResolve:(NSDictionary *)errorDict;

// Other methods
- (BOOL)addressesComplete:(NSArray *)addresses
		   forServiceType:(NSString *)serviceType;
- (void)handleError:(NSNumber *)error withService:(NSNetService *)service;

@end

@protocol bonjourResolver
-(void)resolvedNetService:(NSArray*)addresses;
@end