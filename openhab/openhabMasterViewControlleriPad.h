//
//  openhabMasterViewController.h
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
#import "openhab.h"
#import "configuracion.h"
#import "MBProgressHUD.h"

@class openhabDetailViewController;
@class configurationViewController;
@protocol splitMultiple;

@interface openhabMasterViewControlleriPad : UITableViewController <openhabProtocol,UISplitViewControllerDelegate,MBProgressHUDDelegate>
{
    UIBarButtonItem* elBoton;
    UIPopoverController* elPopover;
    IBOutlet UIBarButtonItem *botonRefresco;
    MBProgressHUD *HUD;
}

@property (strong,nonatomic) UIBarButtonItem*elBoton;
@property (strong,nonatomic) UIPopoverController*elPopover;
@property (strong,nonatomic)  IBOutlet UIBarButtonItem *botonRefresco;
@property (strong, nonatomic) UIViewController *detailViewController;
@property (nonatomic,assign) IBOutlet UITableViewCell*celdaOpenHAB;
@property (strong, nonatomic) openhab *oh;
@property (assign) BOOL trabajando;
@property (strong, nonatomic) configuracion* conf;

-(IBAction)refrescaOpenHAB:(id)sender;
-(void)refrescaEstadoOpenHAB;
@end

@protocol splitMultiple

-(void)muestraBoton:(UIBarButtonItem*)boton pop:(UIPopoverController*)popover;
-(void)ocultaBoton:(UIBarButtonItem*)boton;

@end