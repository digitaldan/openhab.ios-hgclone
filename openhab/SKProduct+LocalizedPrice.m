//
//  SKProduct+LocalizedPrice.m
//  Salterio
//
//  Created by Pablo Romeu Guallart on 11/01/12.
//  Copyright (c) 2012 spaphone. All rights reserved.
//

#import "SKProduct+LocalizedPrice.h"

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    return formattedString;
}



@end
