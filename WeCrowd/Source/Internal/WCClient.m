//
//  WCClient.m
//  WeCrowd
//
//  Created by Zach Vega-Perkins on 6/19/15.
//  Copyright (c) 2015 WePay. All rights reserved.
//

#import "WCClient.h"


// Requests
static NSInteger const kTimeoutInterval = 5;
static NSString* const kAPIURLString    = @"http://0.0.0.0:3000/api";

#pragma mark - Interface

@interface WCClient ()

@end


#pragma mark - Implementation

@implementation WCClient


#pragma mark Request / Response
+ (void) makePostRequestToEndPoint:(NSURL *) endpoint
                            values:(NSDictionary *) params
                       accessToken:(NSString *) accessToken
                      successBlock:(void (^)(NSDictionary * returnData)) successHandler
                      errorHandler:(void (^)(NSError * error)) errorHandler
{
    NSError* parseError = nil;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:endpoint
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:kTimeoutInterval];
    // Configure the  request
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"charset" forHTTPHeaderField:@"utf-8"];
    [request setValue:@"WeCrowd iOS" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params
                                                         options:kNilOptions
                                                           error:&parseError]];
    
    // Set access token (Not super sure what this does since the cases I've seen have all been nil
    if(accessToken) {
        [request setValue:[NSString stringWithFormat:@"Bearer: %@", accessToken]
       forHTTPHeaderField:@"Authorization"];
    }
    
    // Handle improperly formatted data
    if (parseError) {
        errorHandler(parseError);
    } else {
        NSOperationQueue* queue = [NSOperationQueue mainQueue];
        
        // Send the request asynchronously and process the response
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   // Process the server's response
                                   [self processResponse:response
                                                    data:data
                                                   error:connectionError
                                            successBlock:successHandler
                                            errorHandler:errorHandler];
                               }
         ];
    }
}

+ (void) processResponse:(NSURLResponse *) response
                    data:(NSData *) data
                   error:(NSError *) error
            successBlock:(void (^)(NSDictionary* returnData)) successHandler
            errorHandler:(void (^)(NSError* error))  errorHandler
{
    // Build a dictionary from the raw data
    NSDictionary* extractedData = nil;
    
    if ([data length] >= 1) {
        extractedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    
    if (extractedData && !error) {
        // Safely retrieve the status code since there were no errors and the data is valid
        NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
        
        // Check the status code. 200 means success
        if (statusCode == 200) {
            successHandler(extractedData);
        } else {
            NSLog(@"Error: response carrying status code %ld.", statusCode);
        }
    } else if (error) {
        errorHandler(error);
    } else if (!extractedData) {
        NSLog(@"Error: data extraction failed.");
    }
}

#pragma mark - Helper Functions

+ (NSURL *) apiURLWithEndpoint:(NSString *) endpoint {
    return [NSURL URLWithString:[kAPIURLString stringByAppendingString:endpoint]];
}

@end
