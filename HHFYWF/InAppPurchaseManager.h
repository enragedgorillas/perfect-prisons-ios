//
//  InAppPurchaseManager.h
//  Perfect Prisons
//
//  Created by McCall Saltzman on 5/1/13.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *fullUpgradeProduct;
    SKProductsRequest *productsRequest;
}


- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseFullVersion;
- (void)restoreFullVersion;

+(InAppPurchaseManager *) sharedInstance;

@end