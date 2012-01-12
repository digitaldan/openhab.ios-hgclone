//
//  openhabDetailViewController.h
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
#import "openhabMasterViewController.h"
#import "openhab.h"
#import "configuration.h"
#import "openhabTableViewCell.h"
#import "openhabTableViewCellgroup.h"
#import "openhabTableViewCelltext.h"
#import "openhabTableViewCellgroup.h"
#import "openhabTableViewCellimage.h"
#import "openhabTableViewCellSwitch.h"
#import "openhabTableViewCellSelection.h"
#import "openhabTableViewCellSlider.h"
#import "openhabTableViewCellList.h"
#import "openhabTableViewCellimageNoChildren.h"
#import "openhabTableViewCelltextNoChildren.h"
#import "openhabTebleViewCellSelectionDetail.h"
#import "MBProgressHUD.h"


@interface openhabDetailViewController :  UITableViewController <splitMultipleDetailViews,openHABprotocol>
{
    __weak IBOutlet UIView *theLoadingView;
    __weak NSArray*myWidgets;
    __weak IBOutlet UIActivityIndicatorView*loadingSpinner;
    __weak IBOutlet UILabel*loadingLabel;
    MBProgressHUD*HUD;
    UIAlertView*alert;
}
@property (weak, nonatomic) IBOutlet UIView *theLoadingView;
@property (nonatomic,weak) NSArray*myWidgets;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView*loadingSpinner;
@property (nonatomic,weak) IBOutlet UILabel*loadingLabel;
@property (nonatomic,strong) NSTimer*refreshTimer;
@property (nonatomic,strong) NSTimer*progressTimer;
@property (nonatomic,strong)     MBProgressHUD*HUD;
@property (nonatomic,strong)      UIAlertView*alert;

-(IBAction)refreshTableandSitemap:(id)sender;
@end
