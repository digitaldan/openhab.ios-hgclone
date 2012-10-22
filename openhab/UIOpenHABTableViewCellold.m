//
//  UIOpenHABTableViewCell.m
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

#import "UIOpenHABTableViewCell.h"

@implementation UIOpenHABTableViewCell
@synthesize tipo,label,icon,value,item,widgets,interruptor,elstepper,delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)changeValue:(id)sender
{
    if ([self.tipo isEqualToString:@"Switch"] )
    {
        // Cambiar valor del switch. modificaEstado lo cambiará en el item
        NSLog(@"El switch esta %i",[self.interruptor isOn]);
        if (![self.item.estado isEqualToString:@"ON"])
        {
            [self.item modificaEstado:@"ON"];
        }
        else
        {
            [self.item modificaEstado:@"OFF"];
        }
    }
    if ([self.tipo isEqualToString:@"Slider"] )
    {
        // Cambiar valor del switch
        NSString* i=[NSString stringWithFormat:@"%d",(int)self.elstepper.value];
        self.value.text = i;
        NSLog(@"Stepper %@",i);
        [self.item modificaEstado:i];
    }
    // Hay que esperar porque sino openhab no le da tiempo a refrescar
	[NSTimer scheduledTimerWithTimeInterval:1 target:self.delegate selector:@selector(actualizaTabla) userInfo:nil repeats:NO];
}

-(void)rellenaCelda:(openhabWidget*)widget
{
    self.label.text=widget.label;
    self.tipo=widget.tipo;
    
    // comprobamos si tiene item
    if (widget.item!=nil)
    {
		self.item=widget.item;
        
        // Poner el estado si no es indefinido
        
        NSRange loc=[widget.item.estado rangeOfString:@"Undefined"];
        if (loc.location==NSNotFound)
        {
            if (widget.data)
                self.value.text=widget.data;
            else
                self.value.text=nil;
            
        }
        else
        {
            self.value.text=nil;
        }
        
        // ponemos el valor al switch
        if ([self.tipo isEqualToString:@"Switch"])
        {
            if ([widget.item.estado rangeOfString:@"ON"].location!=NSNotFound)
            {
                [self.interruptor setOn:YES];
            }
            else
            {
                [self.interruptor setOn:NO];
            }
        }
                 
    }
    
  
	if (widget.widgets!=nil)
	{
		self.widgets=widget.widgets;
	}
	else
    {
		self.widgets=nil;
    }
    
    if (widget.icon == nil)
    {

        self.icon.image=[UIImage imageNamed:@"switch.png"];
    }
    else
    {
        self.icon.image=[UIImage imageNamed:[widget.icon stringByAppendingString:@".png"]];
    }
}


@end
