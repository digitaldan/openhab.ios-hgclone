//
//  bonjourNetworkResolution.m
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

#include <arpa/inet.h>
#import "bonjourNetworkResolution.h"

@implementation bonjourNetworkResolution
@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self) {
        services = [[NSMutableArray alloc] init];
        addresses = [[NSMutableArray alloc] init];
    }
    return self;
}


// Sent when addresses are resolved
- (void)netServiceDidResolveAddress:(NSNetService *)netService
{
    // Make sure [netService addresses] contains the
    // necessary connection information
    if ([self addressesComplete:[netService addresses]
				 forServiceType:[netService type]]) {
        [services addObject:netService];
		
		
		for (NSData* data in [netService addresses]) {
			
			char addressBuffer[100];
			
			struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
			
			int sockFamily = socketAddress->sin_family;
			
			if (sockFamily == AF_INET || sockFamily == AF_INET6) {
				
				const char* addressStr = inet_ntop(sockFamily,
												   &(socketAddress->sin_addr), addressBuffer,
												   sizeof(addressBuffer));
				
				int port = ntohs(socketAddress->sin_port);
				
				if (addressStr && port)
				{
					
					NSString*fullAdress;
					if ([[netService type] isEqualToString:@"_openhab-server._tcp."])
					{

						fullAdress=@"http://";
					}
					else
					{
						fullAdress=@"https://";
					}
					fullAdress=[NSString stringWithFormat:@"%@%s:%d/",fullAdress,addressStr,port];
					
					if (![addresses containsObject:fullAdress])
					{
						[addresses addObject:fullAdress];
						NSLog(@"Found service %@, %d total",fullAdress,[addresses count]);
						[self.delegate resolvedNetService:addresses];
					}
				}
				
			}
			
		}
	}
}

// Sent if resolution fails
- (void)netService:(NSNetService *)netService
	 didNotResolve:(NSDictionary *)errorDict
{
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode] withService:netService];
    [services removeObject:netService];
}

// Verifies [netService addresses]
- (BOOL)addressesComplete:(NSArray *)addresses
		   forServiceType:(NSString *)serviceType
{
    // Perform appropriate logic to ensure that [netService addresses]
    // contains the appropriate information to connect to the service
    return YES;
}

// Error handling code
- (void)handleError:(NSNumber *)error withService:(NSNetService *)service
{
    NSLog(@"An error occurred with service %@.%@.%@, error code = %@",
		  [service name], [service type], [service domain], error);
    // Handle error here
}

@end
