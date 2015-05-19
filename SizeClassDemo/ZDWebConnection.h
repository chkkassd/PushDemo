//
//  ZDWebConnection.h
//  netConnectionDemo
//
//  Created by peter on 14-10-9.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDWebConnection : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData * receiveData;
    NSURLConnection * connection;
    
}
@property (strong, nonatomic) NSURLRequest * request;
@property (strong, nonatomic) void(^completion)(NSString *string,NSError *error);
- (id)initWithRequest:(NSURLRequest *)request
    completionHandler:(void(^)(NSString *string,NSError *error))handler;
- (void)startConnection;

@end
