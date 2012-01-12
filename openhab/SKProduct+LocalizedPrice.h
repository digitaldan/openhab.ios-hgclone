//
//  SKProduct+LocalizedPrice.h
//  Salterio
//
//  Created by Pablo Romeu Guallart on 11/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
