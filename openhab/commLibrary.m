//
//  commLibrary.m
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

#import "commLibrary.h"

@implementation commLibrary

@synthesize responseData,delegate,theUrl,TheConnection,timeout,postValue,tag;

-(commLibrary*)init
{	
	self.timeout=10.0;
	self.tag=0;
	self.postValue=nil;
	return self;
}

#pragma mark - connection functions

-(void)doGet:(NSURL *)url
{
	theUrl=url;
	NSURLRequest* UrlRequest=[NSURLRequest requestWithURL:url
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:timeout];
	// create the connection with the request
	// and start loading the data
	TheConnection=[[NSURLConnection alloc] initWithRequest:UrlRequest delegate:self];

	if (!TheConnection)
	{
		NSLog(@"ERROR: Could not create a connection");
		[delegate requestFinishedWithErrors:self error:nil];
	}
}

-(void)doPost:(NSURL *)url value:(NSString*)value
{
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
	[req setHTTPMethod:@"POST"];
	NSData *dataPayload = [value dataUsingEncoding:NSUTF8StringEncoding];
	[req setHTTPBody:dataPayload];
	[req setValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	self.theUrl=url;
	self.postValue=value;
	
	TheConnection=[[NSURLConnection alloc] initWithRequest:req delegate:self];
	
	if (!TheConnection)
	{
		NSLog(@"ERROR: Could not create a PUT connection");
		[delegate requestFinishedWithErrors:self error:nil];
	}	
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (!responseData) {
		responseData=[[NSMutableData alloc]init];
	}
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"%@",[NSString stringWithFormat:@"ERROR: Connection failed: %@", [error description]]);
	[delegate requestFinishedWithErrors:self error:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSString*response=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	//NSLog(@"%@",response);
	[delegate requestFinished:self];
}
@end
