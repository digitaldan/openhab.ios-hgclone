//
//  requestQueue.h
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

@protocol requestQueueprotocol;

@interface requestQueue : NSObject <commLibraryprotocol>
{
	NSMutableArray*queue;
	NSMutableArray*longPollingQueue;
	NSInteger operations;
	NSInteger maxOperations;
	NSInteger Allpetitions;
	NSInteger sizeDownloaded;
	NSCondition* theLock;
	id <requestQueueprotocol>delegate;
	
}
@property (atomic,strong)NSMutableArray*queue;
@property (atomic,strong)NSMutableArray*longPollingQueue;
@property (atomic)NSInteger operations;
@property (atomic)NSInteger maxOperations;
@property (atomic)NSInteger Allpetitions;
@property (atomic)NSInteger sizeDownloaded;
@property (atomic)NSInteger SerialNumber;
@property (atomic,strong) NSCondition*theLock;
@property (nonatomic,strong) id <requestQueueprotocol>delegate;


-(void)doGetUrl:(NSURL*)url withTag:(NSInteger)tag;
-(NSInteger)doGetUrlWithOperation:(NSURL*)url withTag:(NSInteger)tag;
// v1.2 Long-polling urls
-(int)doGetLongPollUrl:(NSURL*)url withTag:(NSInteger)tag;
-(void)doPostUrl:(NSURL*)url withValue:(NSString*)value withTag:(NSInteger)tag;
-(void)cancelRequest:(NSInteger)requestSerialNumber;
-(void)cancelRequests;
-(int)operationsInQueue;

@end

@protocol requestQueueprotocol
-(void)requestinQueueFinished:(commLibrary*)com;
-(void)requestinQueueFinishedwithError:(commLibrary*)com error:(NSError*)error;
-(void)allrequestsinQueueFinished;
@end