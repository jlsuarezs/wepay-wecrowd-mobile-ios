//
//  WCManualPaymentViewController.h
//  WeCrowd
//
//  Created by Zach Vega-Perkins on 6/30/15.
//  Copyright (c) 2015 WePay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCManualPaymentViewController;

@protocol ManualPaymentDelegate <NSObject>

- (void) manualPaymentViewController:(WCManualPaymentViewController *) manualPaymentViewController
                didSubmitPaymentInfo:(id) sender;

@end

@interface WCManualPaymentViewController : UIViewController

@end
