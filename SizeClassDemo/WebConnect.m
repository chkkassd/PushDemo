//
//  WebConnect.m
//  SizeClassDemo
//
//  Created by peter on 14/10/21.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "WebConnect.h"

#define API_Official @"https://180.166.169.132:8444" //公网测试
@implementation WebConnect

- (id)initWithRequest:(NSURLRequest *)request
    completionHandler:(void (^)(NSError *, NSDictionary *))handler
{
    self = [super init];
    if (self) {
        self.request = request;
        self.completion = handler;
    }
    return self;
}

- (void)startConnection
{
    receiveData = [[NSMutableData alloc] init];
    connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnection Delegate

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//    if ([response respondsToSelector:@selector(allHeaderFields)]) {
//        NSDictionary *dictionary = [httpResponse allHeaderFields];
//        NSLog(@"%@",dictionary);
//    }
//}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@",responseDic);
    if ([responseDic[@"status"] isEqualToString:@"0"]) {
        self.completion(nil, responseDic);
    } else {
        NSError *error = [[NSError alloc] init];
        self.completion(error, nil);
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.completion) {
        self.completion(error,nil);
    }
    NSLog(@"connection error:%@",error.localizedDescription);
}

- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // we only trust our own domain
        NSLog(@"%@",challenge.protectionSpace.host);
        if ([API_Official rangeOfString:challenge.protectionSpace.host].length)
        {
            NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
