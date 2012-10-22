//
//  configurationViewController.h
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

#import "configuracion.h"
#import "openhabMasterViewControlleriPad.h"


@interface configurationViewController : UIViewController <UITextFieldDelegate,UISplitViewControllerDelegate,splitMultiple>
{
	__weak IBOutlet UITextField*direccion;
	__weak IBOutlet UITextField*mapa;
	__weak IBOutlet UILabel*refresco;
	__weak IBOutlet UIStepper*elstepper;
	__strong configuracion* fichero;
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) UITextField* direccion;
@property (weak, nonatomic) UITextField* mapa;
@property (weak, nonatomic) UILabel* refresco;
@property (weak, nonatomic) UIStepper* elstepper;
@property (strong, nonatomic) configuracion* fichero;

-(IBAction)cambiaRefresco:(id)sender;
-(IBAction)botonOk:(id)sender;

@end
