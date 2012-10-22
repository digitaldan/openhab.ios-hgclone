//
//  openhabTableViewCellVideo.m
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
//

/*Sample 
 
 MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
 player.view.frame = CGRectMake(184, 200, 400, 300);
 [self.view addSubview:player.view];
 [player play];*/

#import "openhabTableViewCellVideo.h"

@implementation openhabTableViewCellVideo
@synthesize loaded,player;

-(void)loadWidget:(openhabWidget *)theWidget
{
    [super loadWidget:theWidget];
	//
	// Set the widget
    // Ask for the video
	
    if (!loaded)
	{
		
		if (theWidget.theWidgetUrl)
		{
			player.view.autoresizingMask=UIViewAutoresizingNone;
			player = [[MPMoviePlayerController alloc] initWithContentURL:theWidget.theWidgetUrl];
			player.view.frame = self.contentView.bounds;
			
			[self.contentView addSubview:player.view];
			[player play];
			[self setLoaded:YES];
		}
	}
	else
	{
		[theSpinner stopAnimating];
		[self.theImage setHidden:YES];
		

		player.view.frame=self.contentView.bounds;

		//[theWebView reload];
	}

}


@end
