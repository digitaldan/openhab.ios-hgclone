//
//  openhabTableViewCell.h
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

#import <UIKit/UIKit.h>
#import "openhabWidget.h"
#import "openhab.h"


@interface openhabTableViewCell : UITableViewCell
{
	openhabWidget*widget;

	__weak IBOutlet UILabel * label;
	__weak IBOutlet UIImageView * theImage;
    __weak IBOutlet UIActivityIndicatorView * theSpinner;
    BOOL refreshIcon;
}

@property (nonatomic,weak)IBOutlet UILabel * label;
@property (nonatomic,weak)IBOutlet UIImageView*theImage;
@property (nonatomic,strong) openhabWidget*widget;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView * theSpinner;
@property (nonatomic)   BOOL refreshIcon;

-(void)loadWidget:(openhabWidget*)theWidget;
-(BOOL)mayBeModified;
-(IBAction)changeValue:(id)sender;  
@end
