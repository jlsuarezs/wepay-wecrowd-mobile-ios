//
//  WCSwiperViewController.m
//  WeCrowd
//
//  Created by Zach Vega-Perkins on 6/29/15.
//  Copyright (c) 2015 WePay. All rights reserved.
//

#import "WCSwiperViewController.h"
#import "WCWePayManager.h"

@interface WCSwiperViewController () <WPCardReaderDelegate, WPTokenizationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *swiperStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WCSwiperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[WCWePayManager sharedInstance].wepay startCardReaderForTokenizingWithCardReaderDelegate:self
                                                                         tokenizationDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cardReaderDidChangeStatus:(id) status
{
    if (status == kWPCardReaderStatusNotConnected) {
        self.swiperStatusLabel.text = @"Please connect the card reader to your device.";
    } else if (status == kWPCardReaderStatusConnected) {
        self.swiperStatusLabel.text = @"Card reader connected.";
    } else if (status == kWPCardReaderStatusWaitingForSwipe) {
        self.swiperStatusLabel.text = @"Waiting for swipe...";
    } else if (status == kWPCardReaderStatusSwipeDetected) {
        self.swiperStatusLabel.text = @"Detected swipe!";
    } else if (status == kWPCardReaderStatusTokenizing) {
        self.swiperStatusLabel.text = @"Tokenizing card...";
    } else if (status == kWPCardReaderStatusStopped) {
        self.swiperStatusLabel.text = @"Card reader has stopped.";
    }
}

- (void) didReadPaymentInfo:(WPPaymentInfo *) paymentInfo
{
    // Tokenize the payment info
    [[WCWePayManager sharedInstance].wepay tokenizePaymentInfo:paymentInfo
                                          tokenizationDelegate:self];
}

- (void) didFailToReadPaymentInfoWithError:(NSError *) error
{
    UIAlertController *alertController;
    UIAlertAction *closeAction;
    
    alertController = [UIAlertController alertControllerWithTitle:@"Unable to read card"
                                                          message:@"There was an error processing the card. Please try again."
                                                   preferredStyle:UIAlertControllerStyleAlert];
    closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:closeAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void) paymentInfo:(WPPaymentInfo *) paymentInfo didTokenize:(WPPaymentToken *) paymentToken
{

}

- (void) paymentInfo:(WPPaymentInfo *) paymentInfo didFailTokenization:(NSError *) error
{
    
}

@end
