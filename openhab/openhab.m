//
//  openhab.m
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

#import "openhab.h"
#import "configuration.h"

// Prepare singleton
static openhab *sharedOpenhab = nil;

@interface openhab ()
//-(void)searchAndUpdateIconImages:(NSString*)imageName withData:(NSData*)data andWidgets:(NSArray*)theWidgets;
-(void)updateArrayAndCopyImages:(openhabImage*)image andWidgets:(NSArray*)theWidgets;
@end

@implementation openhab
@synthesize arrayItems,queue,sitemap;
@synthesize itemsLoaded,sitemapName,imagesArray,refreshing,groupsLoaded,sitemapLoaded,delegate,theBaseUrl,theMap;

-(openhab*)init
{
	self = [super init];
    if (self) {
        // Initialization code here.
        self.arrayItems=[[NSMutableArray alloc]init];
		self.queue=[[requestQueue alloc]init];
		self.sitemap=[[NSMutableArray alloc]init];
		self.imagesArray=[[NSMutableArray alloc]init];
		self.delegate=nil;
		self.theBaseUrl=nil;
		self.theMap=nil;
		self.sitemapName=nil;
		itemsLoaded=NO;
		refreshing=NO;
		groupsLoaded=NO;
		sitemapLoaded=NO;
    }
    return self;
}

#pragma mark Singleton Methods
+ (openhab*)sharedOpenHAB {
    @synchronized(self) {
        if (sharedOpenhab == nil)
            sharedOpenhab = [[self alloc] init];
    }
    return sharedOpenhab;
}

+ (openhab*)deleteSharedOpenHAB {
    @synchronized(self) {
            sharedOpenhab = [[self alloc] init];
    }
    return sharedOpenhab;
}

#pragma mark - initialize items

-(void)initArrayItems
{
	self.theBaseUrl=(NSString*)[configuration readPlist:@"BASE_URL"];
	// UPDATE: from version 0.9
	NSURL*fullUrl=[NSURL URLWithString:[theBaseUrl stringByAppendingFormat:@"rest/items?type=json"]];
	[self.queue setDelegate:self];
	//NSLog(@"cargando %@",fullUrl);
	[self.queue doGetUrl:fullUrl withTag:0];
}
#pragma mark - initialize groups

-(void)initArrayGroups:(NSString*)group
{
	if (itemsLoaded)
	{
		// UPDATE: from version 0.9
		NSURL*fullUrl=[NSURL URLWithString:[theBaseUrl stringByAppendingFormat:@"rest/items/%@?type=json",group]];
		[self.queue setDelegate:self];
		[self.queue doGetUrl:fullUrl withTag:1];
	}
    else
    {
        [self initArrayItems];
    }
}

#pragma mark - initialize widgets

-(void)initSitemap
{
	if (itemsLoaded && groupsLoaded)
	{
		theMap=(NSString*)[configuration readPlist:@"map"];
		// UPDATE: from version 0.9
		NSURL*fullUrl=[NSURL URLWithString:[theBaseUrl stringByAppendingFormat:@"rest/sitemaps/%@?type=json",theMap]];
		[self.queue setDelegate:self];
		[self.queue doGetUrl:fullUrl withTag:2];
	}
    else
    {
        [self initArrayItems];
    }
}

#pragma mark - convenience method to get an item by its name

-(openhabItem*)getItembyName:(NSString*)name
{
	for (openhabItem*temp in arrayItems) {
		if ([temp.name isEqualToString:name]) {
			return temp;
		}
	}
	return nil;
}

#pragma mark - change value of item

-(void)changeValueofItem:(openhabItem*)item toValue:(NSString*)value
{
	if (self.sitemapLoaded)
	{
		NSURL*fullUrl=[NSURL URLWithString:item.link];
		[self.queue setDelegate:self];
		[self.queue doPostUrl:fullUrl withValue:value withTag:3];
	}
}

#pragma mark - refresh

-(void)refreshItems
{
	if (self.itemsLoaded && self.groupsLoaded)
	{
		self.refreshing=YES;
		// UPDATE: from version 0.9
		NSURL*fullUrl=[NSURL URLWithString:[theBaseUrl stringByAppendingFormat:@"rest/items?type=json"]];
		[self.queue setDelegate:self];
		[self.queue doGetUrl:fullUrl withTag:4];
	}
}
-(void)refreshSitemap
{
	if (self.sitemapLoaded)
	{
		self.refreshing=YES;
		// UPDATE: from version 0.9
		NSURL*fullUrl=[NSURL URLWithString:[theBaseUrl stringByAppendingFormat:@"rest/sitemaps/%@?type=json",theMap]];
		[self.queue setDelegate:self];
		[self.queue doGetUrl:fullUrl withTag:5];
	}
}

#pragma mark - get icons and images

-(openhabImage*)getOpenHABImageinArray:(NSString*)name
{
	openhabImage *result=nil;
	for (openhabImage*oi in imagesArray) {
		if ([name isEqualToString:oi.name]) {
			result=oi;
			return oi;
		}
	}
	return result;
}

-(BOOL)getNameinImageinArray:(NSString*)name
{
	for (openhabImage*oi in imagesArray) {
		if ([name isEqualToString:oi.name]) {
			return YES;
		}
	}
	return NO;
}




-(void)getImage:(NSString*)theImageName
{
	// If name is not there, put it there
	
	if (![self getNameinImageinArray:theImageName])
	{
		[imagesArray addObject:[[openhabImage alloc] initWithName:theImageName]];
		
		// Ask for the image to the server
		NSURL*fullUrl=[NSURL URLWithString:[theBaseUrl stringByAppendingFormat:@"images/%@.png",theImageName]];
		[self.queue setDelegate:self];
		[self.queue doGetUrl:fullUrl withTag:6];

	}
	else
	{
		// The image's name  is in the array
		openhabImage*theImage=[self getOpenHABImageinArray:theImageName];
		
		// If it is already downloaded, update
		if (theImage.image!=nil)
		{
			NSLog(@"Got image %@, do not download!",theImageName);
			[self updateArrayAndCopyImages:theImage andWidgets:sitemap];
			[delegate imagesRefreshed];
		}
	}	
}

-(void)getImageWithURL:(NSString *)theImageName
{
	// If name is not there, put it there
	
	if (![self getNameinImageinArray:theImageName])
	{
		[imagesArray addObject:[[openhabImage alloc] initWithName:theImageName]];
		
		// Ask for the image to the server
		NSURL*fullUrl=[NSURL URLWithString:theImageName];
		[self.queue setDelegate:self];
		[self.queue doGetUrl:fullUrl withTag:7];
		
	}
	else
	{
		// The image's name  is in the array
		openhabImage*theImage=[self getOpenHABImageinArray:theImageName];
		
		// If it is already downloaded, update
		if (theImage.image!=nil)
		{
			NSLog(@"Got image %@, do not download!",theImageName);
			[self updateArrayAndCopyImages:theImage andWidgets:sitemap];
			[delegate imagesRefreshed];
		}
	}	
}

#pragma mark - process responses

-(void)initArrayItemsResponse:(NSData*)data
{
	NSError*error;
	id JSONdata=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (error)
	{
		//NSLog(@"ERROR: error parsing JSON %@ with data:%@",error,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]); 
		[delegate JSONparseError:@"items" withError:error];
	}
	else
	{
		// We get de value of the item entry in the JSON
		NSDictionary*dict=(NSDictionary*)JSONdata;
		NSArray*itemsList=(NSArray*)[dict objectForKey:@"item"];
		for (NSDictionary*dictionaryItem in itemsList) {
			openhabItem*item = [[openhabItem alloc]initWithDictionary:dictionaryItem] ;
			[self.arrayItems addObject:item];
		}
		//NSLog(@"array de items %@",arrayItems);
		// items Loaded, now the groups
		
		self.itemsLoaded=YES;
        [self.delegate itemsLoaded];
		for (openhabItem*item in arrayItems)
		{
				if([item.type isEqualToString:@"GroupItem"])
					[self initArrayGroups:item.name];
		}
	}
}



-(void)initArrayGroupsResponse:(NSData*)data
{
	NSError*error;
	id JSONdata=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (error)
	{
		NSString*corrupted=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"ERROR: error parsing JSON %@ as a string \n%@",error,corrupted); 
		[delegate JSONparseError:@"groups" withError:error];
	}
	else
	{
		NSDictionary*dict=(NSDictionary*)JSONdata;
		NSString*group=(NSString*)[dict objectForKey:@"name"];
		id members=[dict objectForKey:@"members"];
		NSArray*itemsInGroup;
		
		if ([members isKindOfClass:[NSDictionary class]])
		{
			itemsInGroup=[NSArray arrayWithObject:members];
		}
		else
		{
			itemsInGroup=(NSArray*)members;
		}
		// Get the group item
		openhabItem*theGroup;
		for (openhabItem*temp in arrayItems) {
			if ([temp.name isEqualToString:group])
				theGroup=temp;
		}
		// Assign to members. BEWARE!! WE ONLY ASSIGN DIRECT GROUPS, NOT INHERITED!
		
		for (NSDictionary*itemDict in itemsInGroup) {
			for (openhabItem*temp in arrayItems) {
				if ([temp.name isEqualToString:[itemDict objectForKey:@"name"]]) {
					[temp.groups addObject:theGroup];
					//NSLog(@"Item: %@ group %@",temp.name, temp.groups);
				}
			}
		}
	}
}

#pragma mark - init Sitemap response

-(openhabWidget*)buildWidgetTree:(NSDictionary*)w
{
	// initialize widget
	
	openhabWidget*theWidget=[[openhabWidget alloc]initWithDictionary:w];
	
	openhabItem*itemInWidget=[[openhabItem alloc]initWithDictionary:[w objectForKey:@"item"]];
	
	if (itemInWidget!=nil)
	{
		for (openhabItem*temp in arrayItems) {
			if ([temp.name isEqualToString:itemInWidget.name])
				theWidget.item=temp;
		}
	}

    // if there is an icon, get the icon. if it is a refresh DON'T!
//    if (!self.sitemapLoaded && ![theWidget.icon isEqualToString:@""] && ![theWidget.icon isEqualToString:@"frame"])
//        [self getImage:theWidget.icon];
    
	// Check if there ar more widgets 	
	id hasWidget=[w objectForKey:@"widget"];
	if (hasWidget)
		if ([[w objectForKey:@"widget"] isKindOfClass:[NSDictionary class]])
		{
			// Just one sibling
			[theWidget.widgets addObject:[self buildWidgetTree:[w objectForKey:@"widget"]]];
		}
		else for (NSDictionary*sibling in [w objectForKey:@"widget"]) {
			[theWidget.widgets addObject:[self buildWidgetTree:sibling]];
		}
	
	// Check if there ar more widgets in LinkedPage
	hasWidget=[[w objectForKey:@"linkedPage"] objectForKey:@"widget"];
	if (hasWidget)
		if ([hasWidget isKindOfClass:[NSDictionary class]])
		{
			// Just one sibling
			[theWidget.widgets addObject:[self buildWidgetTree:hasWidget]];
		}
		else for (NSDictionary*sibling in [[w objectForKey:@"linkedPage"]objectForKey:@"widget"]) {
			[theWidget.widgets addObject:[self buildWidgetTree:sibling]];
		}
	
	// UPDATE: Check for mappings
	
	hasWidget=[w objectForKey:@"mapping"];
	if (hasWidget)
		if ([hasWidget isKindOfClass:[NSDictionary class]])
		{
			// Just one mapping
			[theWidget.mappings addObject:[[openhabMapping alloc] initWithDictionary:hasWidget]];
		}
		else for (NSDictionary*children in [w objectForKey:@"mapping"]) {
			[theWidget.mappings addObject:[[openhabMapping alloc] initWithDictionary:children]];
		}
	// UPDATE: Check for url
	
	if ([theWidget widgetType]==7 || [theWidget widgetType]==10 ) {
		theWidget.imageURL=[w objectForKey:@"url"];
	}
	return theWidget;
}

-(void)initSitemapResponse:(NSData*)data
{
	NSError*error;
	id JSONdata=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (error)
	{
		NSLog(@"ERROR: error parsing JSON, the parser said :%@\n",error); 
		[delegate JSONparseError:@"sitemap" withError:error];
	}
	else
	{
		/*Structure of sitemap is:
		 
		 <sitemap>
			<name>sml2010</name>
			<link>...</link>
			<homepage>
			<id>sml2010</id>
			<link>.... </link>
			<widget>...</widget>
			<widget>...</widget>
			<widget>...</widget>
			<widget>...</widget>
			</homepage>
		 </sitemap>
		 
		 Then, each widget may contain a linkedPage*/
		

		NSDictionary*dict=(NSDictionary*)JSONdata;
		NSDictionary*homepage=(NSDictionary*)[dict objectForKey:@"homepage"];
		
		self.sitemapName=[homepage objectForKey:@"title"];
		// Check if more than one widget or just one
		if ([[homepage objectForKey:@"widget"] isKindOfClass:[NSDictionary class]])
			[self.sitemap addObject:[self buildWidgetTree:[homepage objectForKey:@"widget"]]];
		else for (NSDictionary*w in [homepage objectForKey:@"widget"]) {
			[self.sitemap addObject:[self buildWidgetTree:w]];
		}		// Build each branch of the tree and add to the sitemap

		self.sitemapLoaded=YES;
        [self.delegate sitemapLoaded];
	}
}

#pragma mark - convenience method to search&update item and sitemap

-(void)searchAndRefreshItem:(openhabItem*)theItem
{
	for (openhabItem*temp in arrayItems) {
		if ([temp.name isEqualToString:theItem.name])
		{
			temp.state=theItem.state;
		}
	}
}

-(void)searchAndRefreshWidget:(openhabWidget*)theWidgets theBranch:(openhabWidget*)theBranch
{
	//NSLog(@"Refreshed %@:%@ with %@:%@",theBranch.label,theBranch.data,theWidgets.label,theBranch.data);
    
	theBranch.label=theWidgets.label;
	
    
    // There is a problem here, we MUST ask for the image later because if not, the image is NOT updated
	
	BOOL shouldUpdateImage=NO;
	if (![theBranch.icon isEqualToString:theWidgets.icon]) {
		shouldUpdateImage=YES;
	}
        
    theBranch.icon=theWidgets.icon;
	theBranch.data=theWidgets.data;
	
	if (theWidgets.item)
	{
		theBranch.item.state=theWidgets.item.state;
	}
	
	if (shouldUpdateImage)
		[self getImage:theWidgets.icon];
	for (int i=0; i<[theWidgets.widgets count]; i++) {
		[self searchAndRefreshWidget:(openhabWidget*)[theWidgets.widgets objectAtIndex:i] theBranch:(openhabWidget*)[theBranch.widgets objectAtIndex:i]];
	}
}

-(void)updateArrayAndCopyImages:(openhabImage*)image andWidgets:(NSArray*)theWidgets
{
	// Save the image to the array
	openhabImage*theImage=[self getOpenHABImageinArray:image.name];
	if (theImage.image == nil)
		theImage.image =image.image;
	
	// get the image
	
	for (openhabWidget*w in theWidgets) {
        if ([w.icon isEqualToString:image.name]) {
            w.iconImage=theImage.image;
			[delegate imagesRefreshed];
        }
		// Updated: IMAGES LOADED HERE
		if ([w.imageURL isEqualToString:image.name]) {
            w.Image=theImage.image;
			[delegate imagesRefreshed];
		}
		if ([w.widgets count]>0)
		{
			[self updateArrayAndCopyImages:theImage andWidgets:w.widgets];
		}
    }
    
}

//-(void)searchAndUpdateIconImages:(NSString*)imageName withData:(NSData*)data andWidgets:(NSArray*)theWidgets
//{
//#warning maybe here w.icon must get its data from array¿?
//	
//	// Save the image to the array
//	if ([self getImageinArray:imageName]==nil)
//		[imagesArray addObject:[[openhabImage alloc] initWithData:data andName:imageName]];
//	
//	// get the image
//	UIImage*theImage=[self getImageinArray:imageName];
//    
//	for (openhabWidget*w in theWidgets) {
//        if ([w.icon isEqualToString:imageName]) {
//            w.iconImage=theImage;
//        }
//        [self searchAndUpdateIconImages:imageName withData:data andWidgets:w.widgets];
//    }
//}

#pragma mark - change value of item response

-(void)changeValueofItemResponse:(commLibrary*)request
{
    // DO NOT CHANGE THE VALUE!, I just want to know request finished OK
    
    // For example: http://localhost:8080/rest/items/Light_Outdoor_Terrace/state
    // Copy the name of the item
    NSArray *temp=[[NSString stringWithFormat:@"%@",request.theUrl] componentsSeparatedByString:@"/"];
    NSString *theItemName=[[temp objectAtIndex:5]copy];
    openhabItem*theItem=nil;
    for (openhabItem* itemTemp in self.arrayItems) {
        if ([itemTemp.name isEqualToString:theItemName])
        {
            theItem=itemTemp;
            break;
            
        }
    }
    [delegate valueOfItemChangeRequested:theItem];
}

#pragma mark - refresh responses

-(void)refreshItemsResponse:(NSData*)data
{
	NSLog(@"Refreshing items");
	NSError*error;
	id JSONdata=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (error)
	{
		NSLog(@"ERROR: error parsing JSON %@",error);
		[delegate JSONparseError:@"refreshitems" withError:error];
	}
	else
	{
		// We get de value of the item entry in the JSON
		NSDictionary*dict=(NSDictionary*)JSONdata;
		NSArray*itemsList=(NSArray*)[dict objectForKey:@"item"];
		for (NSDictionary*dictionaryItem in itemsList) {
			openhabItem*item = [[openhabItem alloc]initWithDictionary:dictionaryItem] ;
			[self searchAndRefreshItem:item];
		}
	}
	self.refreshing=NO;
    [delegate itemsRefreshed];
}

-(void)refreshSitemapResponse:(NSData*)data
{
	NSLog(@"Refreshing sitemap");
	NSError*error;
	id JSONdata=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (error)
	{
		NSString*corrupted=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"ERROR: error parsing JSON %@ as a string \n%@",error,corrupted); 
		[delegate JSONparseError:@"refreshsitemap" withError:error];
	}
	else
	{
		NSDictionary*dict=(NSDictionary*)JSONdata;
		NSDictionary*homepage=(NSDictionary*)[dict objectForKey:@"homepage"];
		
		
		// Check if more than one widget or just one
		NSMutableArray*theWidgets=[[NSMutableArray alloc]initWithCapacity:0];
		if ([[homepage objectForKey:@"widget"] isKindOfClass:[NSDictionary class]]){
			[theWidgets addObject:[self buildWidgetTree:[homepage objectForKey:@"widget"]]];
		}
		else for (NSDictionary*w in [homepage objectForKey:@"widget"]) {
			[theWidgets addObject:[self buildWidgetTree:w]];
		}

		for (int i=0; i<[sitemap count]; i++) {
			[self searchAndRefreshWidget:(openhabWidget*)[theWidgets objectAtIndex:i] theBranch:(openhabWidget*)[sitemap objectAtIndex:i]];
		}
	}
	self.refreshing=NO;
    [delegate sitemapRefreshed];
}


-(void)getImageResponse:(commLibrary*)com
{
    // Copy the name of the image without the .png
    NSArray* temp=[[NSString stringWithFormat:@"%@",com.theUrl] componentsSeparatedByString:@"/"];
    NSString*theImageName=[[temp lastObject]copy];
    temp=[theImageName componentsSeparatedByString:@"."];
	theImageName=[[temp objectAtIndex:0]copy];
    
    // Update the whole tree

	UIImage*theImage=[UIImage imageWithData:com.responseData];
	openhabImage*image=[[openhabImage alloc] initWithImage:theImage andName:theImageName];
    [self updateArrayAndCopyImages:image andWidgets:sitemap];
    //[delegate imagesRefreshed];
}

-(void)getImageResponseURL:(commLibrary*)com
{
    // Copy the name of the image without the .png
	NSString* theImageName=[NSString stringWithFormat:@"%@",com.theUrl];
    
    // Update the whole tree
	
	UIImage*theImage=[UIImage imageWithData:com.responseData];
	openhabImage*image=[[openhabImage alloc] initWithImage:theImage andName:theImageName];
    [self updateArrayAndCopyImages:image andWidgets:sitemap];
    //[delegate imagesRefreshed];
}

#pragma mark - protocol requestQueue

-(void)requestinQueueFinished:(commLibrary*)com
{
	//Check who replies
	
	switch (com.tag) {
		case 0:
			[self initArrayItemsResponse:com.responseData];
			break;
		case 1:
			[self initArrayGroupsResponse:com.responseData];
			break;
		case 2:
			[self initSitemapResponse:com.responseData];
			break;
		case 3:
            [self changeValueofItemResponse:com];
			break;
        case 4:
			[self refreshItemsResponse:com.responseData];
			break;
		case 5:
			[self refreshSitemapResponse:com.responseData];
			break;
        case 6:
            [self getImageResponse:com];
            break;
		case 7:
            [self getImageResponseURL:com];
            break;
		default:
			NSLog(@"ERROR: Unknown request response %@",com);
			[delegate requestFailed:com withError:nil];
			break;
	}
}
-(void)requestinQueueFinishedwithError:(commLibrary*)com error:(NSError*)error
{
	NSLog(@"ERROR: request %@ finished with error: %@",com,error);
    [delegate requestFailed:com withError:error];
}
-(void)allrequestsinQueueFinished
{

	if (!self.itemsLoaded)
	{
		NSLog(@"\n-----Items request finished-----\n\n");		
	}
	else if	(self.itemsLoaded && !self.groupsLoaded)
	{
		NSLog(@"\n-----Groups request finished-----\n\n");
		self.groupsLoaded=YES;
        [self.delegate groupsLoaded];
		// LOAD THE SITEMAP
		[self initSitemap];
	}
	else if (self.groupsLoaded && !self.sitemapLoaded)
	{
		NSLog(@"\n-----Sitemap request finished-----\n\n");	
	}
	else
	{
		NSLog(@"\n-----All requests finished----- petitions: %i Downloaded size: %i bytes\n\n\n",[queue Allpetitions],[queue sizeDownloaded]);	
	}
    [delegate allRequestsFinished];
}
@end
