//
//  bonjourBrowserDelegate.h
//  openhab
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
#import "bonjourNetworkResolution.h"

@protocol bonjourBrowser;

@interface bonjourBrowserDelegate : NSObject <NSNetServiceBrowserDelegate,bonjourResolver>
{
    // Keeps track of available services
    NSMutableArray *services;

    // Keeps track of search status
    BOOL searching;
	
	bonjourNetworkResolution *bonjourResolver;
	id <bonjourBrowser> delegate;
}
@property (strong,nonatomic)	id <bonjourBrowser> delegate;
@property (strong,nonatomic)	bonjourNetworkResolution *bonjourResolver;
// NSNetServiceBrowser delegate methods for service browsing
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser;
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser;
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
			 didNotSearch:(NSDictionary *)errorDict;
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
		   didFindService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing;
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
		 didRemoveService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing;

// Other methods
- (void)handleError:(NSNumber *)error;
- (void)updateUI;
@end

@protocol bonjourBrowser
- (void)updateInterface:(NSArray*)serverList;
@end
