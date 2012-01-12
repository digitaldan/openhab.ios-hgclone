//
//  requestQueue.m
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

#import "requestQueue.h"
#import "configuration.h"

@implementation requestQueue
@synthesize queue,operations,Allpetitions,sizeDownloaded,maxOperations,delegate,theLock;

-(requestQueue*)init
{
	if (!self.queue)
		self.queue=[NSMutableArray new];
	if (!self.theLock)
		self.theLock=[NSCondition new];
	operations=0;
	Allpetitions=0;
	sizeDownloaded=0;
	maxOperations=[(NSNumber*)[configuration readPlist:@"maxConnections"] intValue];
	NSLog(@"Ops: %i",maxOperations);
	return self;
}

-(int)operationsInQueue
{
    return [self.queue count];
}
-(void)doGetUrl:(NSURL*)url withTag:(NSInteger)tag
{
	commLibrary*c=[commLibrary new];
	[c setDelegate:self];
	[c setTag:tag];
	
	if (operations < maxOperations)
	{
		operations++;
		Allpetitions++;
		[c doGet:url];
	}
	else
	{
		// TOO MUCH CONCURRENT OPERATIONS, save te url and wait
		[c setTheUrl:url];
		[queue addObject:c];
	}
}

-(void)doPostUrl:(NSURL*)url withValue:(NSString*)value withTag:(NSInteger)tag
{
	commLibrary*c=[commLibrary new];
	[c setDelegate:self];
	[c setTag:tag];
	
	if (operations < maxOperations)
	{
		operations++;
		Allpetitions++;
		[c doPost:url value:value];
	}
	else
	{
		// TOO MUCH CONCURRENT OPERATIONS, save te url, the put value and wait
		[c setTheUrl:url];
		[c setPostValue:value];
		[queue addObject:c];
	}
}


-(void)continueOperations
{
	// Do not enter if it is the last one
	
	// Get an object
	commLibrary*c=[self.queue objectAtIndex:0];
	operations++;
		
	if (c.postValue)
	{
		Allpetitions++;
		[c doPost:c.theUrl value:c.postValue];
	}
	else
	{
		Allpetitions++;
		[c doGet:c.theUrl];
	}
	
	[self.queue removeObject:c];
	
}

#pragma mark - delegate commLibrary

-(void)requestFinished:(commLibrary*)com
{
	//NSString*response=[[NSString alloc] initWithData:com.responseData encoding:NSUTF8StringEncoding];
	//NSLog(@"Llamado %@ con %@: \n\n %@\n-----",com.theUrl,com.theUrlRequest,response);
		
	// Acquire the lock
	[theLock lock];
	
	// Reduce operations
	operations--;
	// Wait for operations to finish
	while (operations>=maxOperations) {
		[theLock wait];
	}
	
	
	if ([self.queue count]>0)
		[self continueOperations];
	
	// Save the size
	
	sizeDownloaded+=com.responseData.length;
	
	// Tell the delegate that the requestFinished
	[self.delegate requestinQueueFinished:com];
	
	// If we are done with the queue, tell the delegate
	if ([self.queue count]+operations==0)
		[self.delegate allrequestsinQueueFinished];
	
	// We unlocked one, signal next
	[theLock signal];
	[theLock unlock];
}

-(void)requestFinishedWithErrors:(commLibrary*)com error:(NSError*)error
{
	NSLog(@"%@\n-----",error);
	
	// Acquire the lock
	[theLock lock];	
	// Reduce operations
	operations--;
	// Wait for operations to finish
	while (operations>=maxOperations) {
		[theLock wait];
	}
	if ([self.queue count]>0)
		[self continueOperations];
	
	// Save the size
	
	sizeDownloaded+=com.responseData.length;
	
	// Tell the delegate that the requestFinished
	[self.delegate requestinQueueFinishedwithError:com error:error];
	
	// If we are done with the queue, tell the delegate
	if ([self.queue count]+operations==0)
		[self.delegate allrequestsinQueueFinished];
	
	// We unlocked one, signal next
	[theLock signal];
	[theLock unlock];		
}

@end
