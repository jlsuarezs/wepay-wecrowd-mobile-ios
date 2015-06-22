//
//  WCClient.h
//  WeCrowd
//
//  Created by Zach Vega-Perkins on 6/19/15.
//  Copyright (c) 2015 WePay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCClient : NSObject

+ (void) makePostRequestToEndPoint:(NSURL *) endpoint
                            values:(NSDictionary *) params
                       accessToken:(NSString *) accessToken
                      successBlock:(void (^)(NSDictionary * returnData)) successHandler
                      errorHandler:(void (^)(NSError * error)) errorHandler;

@end
