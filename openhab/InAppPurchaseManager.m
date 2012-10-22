//
//  InAppPurchaseManager.m
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



#import "InAppPurchaseManager.h"

/**********************************************/
/****                                       ***/
/****   Remember to change product names!   ***/
/****                                       ***/
/**********************************************/

#define k099 @"1Donation1"
#define k499 @"2donation2"
#define k999 @"3donation3"
#define k1999 @"4donation4"

@implementation InAppPurchaseManager
@synthesize donateProducts,productsRequest;
// InAppPurchaseManager.m


- (void)requestDonationProductData
{
    donateProducts=nil;
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 [NSString stringWithFormat:k099]
                                 ,[NSString stringWithFormat:k499]
                                 ,[NSString stringWithFormat:k999]
                                 ,[NSString stringWithFormat:k1999]
                                 ,nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    donateProducts= [response.products copy];
    if ([donateProducts count] != 0)
    {
        for (SKProduct*donateProduct in donateProducts) {
            NSLog(@"Product title: %@" , donateProduct.localizedTitle);
            NSLog(@"Product description: %@" , donateProduct.localizedDescription);
            NSLog(@"Product price: %@" , [donateProduct localizedPrice]);
            NSLog(@"Product id: %@" , donateProduct.productIdentifier);
        }
        
    }
    else
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestDonationProductData];
}

-(void)dealloc
{
	 [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

-(SKProduct*)productWithIdentifier:(NSString*)theProductId
{
    SKProduct*theProduct=nil;
    
    for (SKProduct*temp in self.donateProducts) {
        if ([temp.productIdentifier isEqualToString:theProductId])
            theProduct=temp;
    }
    
    return theProduct;
}

//
// kick off the upgrade transaction
//
- (void)purchase:(NSString*)product
{
    SKProduct*pr=[self productWithIdentifier:product];
    SKPayment *payment = [SKPayment paymentWithProduct:pr];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:k099])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"k099TransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:k499])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"k499TransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:k999])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"k999TransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:k1999])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"k1999TransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:k099])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k099 ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([productId isEqualToString:k499])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k499 ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([productId isEqualToString:k999])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k999 ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([productId isEqualToString:k1999])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k1999 ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end
