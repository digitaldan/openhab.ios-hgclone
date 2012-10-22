//
//  bonjourBrowserDelegate.m
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

#import "bonjourBrowserDelegate.h"

@implementation bonjourBrowserDelegate
@synthesize bonjourResolver,delegate;
- (id)init
{
    self = [super init];
    if (self) {
        services = [[NSMutableArray alloc] init];
		bonjourResolver=[bonjourNetworkResolution new];
		[bonjourResolver setDelegate:self];
        searching = NO;
    }
    return self;
}

// Sent when browsing begins
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
	NSLog(@"Started bonjour");
    searching = YES;
    [self updateUI];
}

// Sent when browsing stops
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
    searching = NO;
    [self updateUI];
}

// Sent if browsing fails
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
			 didNotSearch:(NSDictionary *)errorDict
{
    searching = NO;
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode]];
}

// Sent when a service appears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
		   didFindService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing
{
	[aNetService setDelegate:bonjourResolver];
	[aNetService resolveWithTimeout:5.0];
    [services addObject:aNetService];
    if(!moreComing)
    {
        [self updateUI];
    }
}

// Sent when a service disappears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
		 didRemoveService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing
{
    [services removeObject:aNetService];
	
    if(!moreComing)
    {
        [self updateUI];
    }
}

// Error handling code
- (void)handleError:(NSNumber *)error
{
    NSLog(@"An error occurred. Error code = %d", [error intValue]);
    // Handle error here
}

// UI update code
- (void)updateUI
{
    if(searching)
    {
        // Update the user interface to indicate searching
        // Also update any UI that lists available services
		NSLog(@"UPDATE bonjour browsing: %@",services);
    }
    else
    {
        // Update the user interface to indicate not searching
		NSLog(@"UPDATE bonjour NoT browsing: %@",services);
    }
}

-(void)resolvedNetService:(NSArray*)addresses
{
	[self.delegate updateInterface:addresses];
}

@end
