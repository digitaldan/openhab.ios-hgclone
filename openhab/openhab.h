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
	NSMutableArray*imagesArray;
	requestQueue* queue;
	BOOL itemsLoaded,groupsLoaded,sitemapLoaded,refreshing;
	id<openHABprotocol> delegate;
}
@property (nonatomic,strong) NSString*theBaseUrl;
@property (nonatomic,strong) NSString*theMap;
@property (nonatomic,strong) NSString*sitemapName;
@property (nonatomic,strong) NSMutableArray*arrayItems;
@property (nonatomic,strong) requestQueue*queue;
@property (nonatomic,strong) NSMutableArray*sitemap;
@property (nonatomic,strong) NSMutableArray*imagesArray;
@property (nonatomic) BOOL itemsLoaded,groupsLoaded,refreshing,sitemapLoaded;
@property (nonatomic,strong) id<openHABprotocol> delegate;


// Public Methods

+ (openhab*)sharedOpenHAB;
+ (openhab*)deleteSharedOpenHAB;
-(void)initArrayItems;
-(void)initSitemap;
-(openhabItem*)getItembyName:(NSString*)name;
-(void)changeValueofItem:(openhabItem*)item toValue:(NSString*)value;
-(void)refreshItems;
-(void)refreshSitemap;
-(void)getImage:(NSString*)theImageName;
-(void)getImageWithURL:(NSString*)theImageName;
@end

@protocol openHABprotocol

-(void)itemsLoaded;
-(void)groupsLoaded;
-(void)sitemapLoaded;
-(void)valueOfItemChangeRequested:(openhabItem*)theItem;
-(void)itemsRefreshed;
-(void)sitemapRefreshed;
-(void)imagesRefreshed;
-(void)requestFailed:(commLibrary*)request withError:(NSError*)error;
-(void)JSONparseError:(NSString*)parsePhase withError:(NSError*)error;
-(void)allRequestsFinished;
@end
