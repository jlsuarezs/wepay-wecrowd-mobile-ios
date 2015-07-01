//
//  WCCampaignDonationModel.m
//  WeCrowd
//
//  Created by Zach Vega-Perkins on 6/11/15.
//  Copyright (c) 2015 WePay. All rights reserved.
//

#import "WCCampaignDonationModel.h"

#pragma mark - Interface

@interface WCCampaignDonationModel ()

@property (strong, nonatomic, readwrite) NSString *campaignID;
@property (strong, nonatomic, readwrite) NSString *donatorName;
@property (strong, nonatomic, readwrite) NSString *donatorEmail;
@property (strong, nonatomic, readwrite) NSString *creditCardID;
@property (strong, nonatomic, readwrite) NSString *amount;

@end

#pragma mark - Implementation

@implementation WCCampaignDonationModel

- (instancetype) initWithCampaignID:(NSString *) campaignID
                        donatorName:(NSString *) donatorName
                       donatorEmail:(NSString *) donatorEmail
                       creditCardID:(NSString *) creditCardID
                             amount:(NSString *) amount
{
    if (self = [super init]) {
        self.campaignID = campaignID;
        self.donatorName = donatorName;
        self.donatorEmail = donatorEmail;
        self.creditCardID = creditCardID;
        self.amount = amount;
    } else {
        // Do nothing
    }
    
    return self;
}

@end
