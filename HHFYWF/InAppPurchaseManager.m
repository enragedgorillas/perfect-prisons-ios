//
//  InAppPurchaseManager.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 5/1/13.
//
//
#define kInAppPurchaseFullUpgradeProductId @"com.lms.PerfectPrisons01.fullversion"
#import "InAppPurchaseManager.h"
#import "cocos2d.h"

#import "UserPreferences.h"
@implementation InAppPurchaseManager



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
    [self requestFullUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseFullVersion
{
    SKPayment *payment = [SKPayment paymentWithProduct:fullUpgradeProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void) restoreFullVersion{
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
    
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseFullUpgradeProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kInAppPurchaseFullUpgradeProductId])
    {
        // enable the pro features
        //[[UserPreferences sharedInstance] activateFullVersion];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFullVersion"];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseFullUpgradeProductId object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseFullUpgradeProductId object:self userInfo:userInfo];
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






- (void)requestFullUpgradeProductData{
    
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.lms.PerfectPrisons01.fullversion"];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *products = response.products;
    fullUpgradeProduct = [products count] == 1 ? [[products firstObject] retain] : nil;
    if (fullUpgradeProduct)
    {
        NSLog(@"Product title: %@" , fullUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@" , fullUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@" , fullUpgradeProduct.price);
        NSLog(@"Product id: %@" , fullUpgradeProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseFullUpgradeProductId object:self userInfo:nil];
}
static InAppPurchaseManager *sharedManager = nil;

+(InAppPurchaseManager *) sharedInstance{
    if (!sharedManager) {
        sharedManager = [[InAppPurchaseManager alloc] init];
    }
    return sharedManager;

}

    

@end

