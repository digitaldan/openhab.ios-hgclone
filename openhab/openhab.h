//
//  openhab.h
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
#import "openhabItem.h"
#import "openhabWidget.h"
#import "openhabImage.h"

@protocol openHABprotocol;

@interface openhab : NSObject <requestQueueprotocol>
{
	NSString*theBaseUrl;
	NSString*theMap;
	NSMutableArray* arrayItems;
	NSMutableArray*sitemap;
	NSString*sitemapName;
	NSMutableDictionary*pagesDictionary,*imagesDictionary;
	requestQueue* queue;
	BOOL itemsLoaded,groupsLoaded,sitemapLoaded,refreshing,serverReachable;
	NSInteger currentlyPolling,currentlyRefreshing;
	NSString*currentPage;
	id<openHABprotocol> delegate;
}
@property (nonatomic,strong) NSString*theBaseUrl;
@property (nonatomic,strong) NSString*theMap;
@property (nonatomic,strong) NSString*sitemapName;
@property (nonatomic,strong) NSMutableArray*arrayItems;
@property (nonatomic,strong) requestQueue*queue;
@property (nonatomic,strong) NSMutableArray*sitemap;
@property (nonatomic,strong) NSMutableDictionary*pagesDictionary,*imagesDictionary;
@property (atomic) BOOL itemsLoaded,groupsLoaded,refreshing,sitemapLoaded,longPolling,serverReachable;
@property (atomic) NSInteger currentlyPolling,currentlyRefreshing;
@property (nonatomic,strong) NSString*currentPage;
@property (nonatomic,strong) id<openHABprotocol> delegate;


// Public Methods

+ (openhab*)sharedOpenHAB;
+ (openhab*)deleteSharedOpenHAB;
-(void)addressIsReacheable;
-(void)initArrayItems;
-(void)initSitemap;
-(void)requestSitemaps:(NSString*)fromServer;// v1.2 get the sitemaps
-(openhabItem*)getItembyName:(NSString*)name;
-(void)changeValueofItem:(openhabItem*)item toValue:(NSString*)value;
-(void)refreshItems;
-(void)refreshSitemap;
-(void)refreshPage:(NSString*)page;
-(void)longPollSitemap:(NSString*)page;
-(void)cancelPolling;
-(void)longPollCurrent;
-(void)cancelRefresh;
-(void)getImage:(NSString*)theImageName;
-(void)getImageWithURL:(NSString*)theImageName;
// v1.2 delete image for charts
-(void)deleteImage:(NSString*)theImageName;
@end

@protocol openHABprotocol
@optional
-(void)itemsLoaded;
-(void)groupsLoaded;
-(void)sitemapLoaded;
-(void)requestSitemapsResponse:(NSArray*)theSitemaps; //V1.2 return the sitemaps.
-(void)valueOfItemChangeRequested:(openhabItem*)theItem;
-(void)itemsRefreshed;
-(void)sitemapRefreshed;
-(void)imagesRefreshed;
-(void)pageRefreshed:(commLibrary*)page;
-(void)longpollDidReceiveData:(commLibrary*)request;
-(void)requestFailed:(commLibrary*)request withError:(NSError*)error;
-(void)JSONparseError:(NSString*)parsePhase withError:(NSError*)error;
-(void)allRequestsFinished;
@end
