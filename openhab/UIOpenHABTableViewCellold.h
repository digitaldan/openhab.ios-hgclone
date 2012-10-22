//
//  UIOpenHABTableViewCell.h
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


@protocol UIOpenHABCellProtocol;
@interface UIOpenHABTableViewCell : UITableViewCell
{
    NSString* tipo;
	openhabItem* item;
	NSMutableArray* widgets;
    __weak IBOutlet UILabel* label;
    __weak IBOutlet UIImageView* icon;
    __weak IBOutlet UILabel* value;
    __weak IBOutlet UISwitch* interruptor;
    __weak IBOutlet UIStepper* elstepper;
	__weak IBOutlet id <UIOpenHABCellProtocol> delegate;

}

@property (nonatomic,strong) NSString* tipo;
@property (nonatomic,strong) openhabItem*item;
@property (nonatomic,strong) NSMutableArray*widgets;
@property (nonatomic,weak) id <UIOpenHABCellProtocol> delegate;
@property (nonatomic,weak) UILabel*label;
@property (nonatomic,weak) UILabel*value;
@property (nonatomic,weak) UIImageView* icon;
@property (nonatomic,weak) UISwitch* interruptor;
@property (nonatomic,weak) UIStepper* elstepper;

-(IBAction)changeValue:(id)sender;
-(void)rellenaCelda:(openhabWidget*)widget;

@end

@protocol UIOpenHABCellProtocol

-(void)actualizaTabla;

@end