//
//  InAppPurchaseManager.h
//  Salterio
//
//  Created by Pablo Romeu Guallart on 11/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// InAppPurchaseManager.h
#import <StoreKit/StoreKit.h>
#import "SKProduct+LocalizedPrice.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    NSArray *donateProducts;
    SKProductsRequest *productsRequest;
}
@property (nonatomic,strong) NSArray *donateProducts;
@property (nonatomic,strong) SKProductsRequest *productsRequest;

- (void)requestDonationProductData;

- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchase:(NSString*)product;
@end

