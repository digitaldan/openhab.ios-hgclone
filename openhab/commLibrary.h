//
//  commLibrary.h
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


@protocol commLibraryprotocol;
@interface commLibrary : NSObject <NSURLConnectionDelegate>
{
	NSURL* theUrl;
	NSURLConnection* TheConnection;
	NSMutableData*responseData;
	NSString* postValue;
	NSInteger timeout;
	NSInteger tag;
	NSInteger serial;
	// v1.2 Do not return anything if cancelled
	BOOL cancelled;
	__strong id <commLibraryprotocol>delegate;
}
@property (nonatomic,strong) NSMutableData*responseData;
@property (nonatomic,strong) NSURL *theUrl;
@property (nonatomic,strong) NSURLConnection *TheConnection;
@property (nonatomic,strong) NSString* postValue;
@property (nonatomic) 	NSInteger timeout;
@property (nonatomic) 	NSInteger tag;
@property (nonatomic)	NSInteger serial;
@property (nonatomic)	BOOL cancelled;
@property (nonatomic,strong) id<commLibraryprotocol>delegate;
@property (nonatomic) BOOL longpoll;

-(commLibrary*)init;
-(void)doGet:(NSURL*)url;
// v1.2 Long-polling
-(void)doGetLongPolling:(NSURL*)url;
-(void)doGetOperation:(NSURL*)url;
-(void)doPost:(NSURL *)url value:(NSString*)value;
@end

@protocol commLibraryprotocol
// v1.2 Long-polling
-(void)longPollingrequestFinished:(commLibrary*)com;
-(void)operationRequestFinished:(commLibrary*)com;
-(void)requestFinished:(commLibrary*)com;
-(void)requestFinishedWithErrors:(commLibrary*)com error:(NSError*)error;
@end