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
#import "openhabWidget.h"
#import "openhabItem.h"
#import "openhabMasterViewControlleriPad.h"
#import "openhab.h"
#import "UIOpenHABTableViewCell.h"


@interface openhabDetailViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate, splitMultiple,openhabItemprotocol,openhabProtocol,UIOpenHABCellProtocol,MBProgressHUDDelegate>
{
        MBProgressHUD *HUD;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *botonRefresco;
@property (assign, nonatomic) NSMutableArray* sitemap;
@property (strong, nonatomic) NSTimer *aTimer;
@property (assign, nonatomic) openhab *oh;
- (openhabWidget*)dameWidgetenSeccion:(NSUInteger)seccion;
-(IBAction)refreshMap:(id)sender;

@end
