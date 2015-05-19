//
//  WebConnect.h
//  SizeClassDemo
//
//  Created by peter on 14/10/21.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebConnect : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData * receiveData;
    NSURLConnection * connection;
    
}
@property (strong, nonatomic) NSURLRequest * request;
@property (strong, nonatomic) void(^completion)(NSError *error, NSDictionary *resultDic);
- (id)initWithRequest:(NSURLRequest *)request
    completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler;
- (void)startConnection;

@end
