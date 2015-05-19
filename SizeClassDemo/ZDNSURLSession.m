//
//  ZDNSURLSession.m
//  BackgroundDemo
//
//  Created by peter on 14/10/28.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDNSURLSession.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface ZDNSURLSession()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURLRequest * request;
@property (strong, nonatomic) void(^completion)(NSError *error, NSDictionary *resultDic);
@property (strong, nonatomic) NSURLSession * session;
@property (strong, nonatomic) NSURLSessionUploadTask * dataTask;

@end

@implementation ZDNSURLSession

- (id)initWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSError *error, NSDictionary *resultDic))handler
{
    self = [super init];
    if (self) {
        self.request = request;
        self.completion = handler;
    }
    return self;
}

- (void)startSession
{
    receiveData = [[NSMutableData alloc] init];
    NSString * sessionIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSURLSessionConfiguration * confifuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sessionIdentifier];
    self.session = [NSURLSession sessionWithConfiguration:confifuration delegate:self delegateQueue:nil];
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    doc = [doc stringByAppendingPathComponent:@"haha"];
    
    [[@"hehe" dataUsingEncoding:NSUTF8StringEncoding] writeToFile:doc atomically:YES];
    
    self.dataTask = [self.session uploadTaskWithRequest:self.request fromFile:[NSURL fileURLWithPath:doc]];//[self.session uploadTaskWithRequest:self.request fromData:self.request.HTTPBody];
    [self.dataTask resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // we only trust our own domain
        NSLog(@"%@",challenge.protectionSpace.host);
        if ([PushWebURL rangeOfString:challenge.protectionSpace.host].length)
        {
            NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //1
    AppDelegate* appDelegate =
    (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
//    void(^completionHandler)(UIBackgroundFetchResult) =
//    appDelegate.silentRemoteNotificationCompletionHandler;
    
    //2
//    if (error) {
//        if (completionHandler) {
//            completionHandler(UIBackgroundFetchResultFailed);
//        }
//        NSLog(@"Error : %@", error.localizedDescription);
//    }
//    else if (completionHandler) {
//        completionHandler(UIBackgroundFetchResultNewData);
//    }
    
    //3
//    appDelegate.silentRemoteNotificationCompletionHandler = nil;

}

#pragma mark - NSURLSessionDateDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *))completionHandler
{
    NSError *error = nil;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:&error];
//    NSString * dataString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",dataString);
//    int a = [dataString intValue];
//    if (a > 0) {
//        self.completion(dataString);
//    } else {
//        NSError *error = [[NSError alloc] init];
//        self.completion(error);
//    }
    if ([responseDic[@"status"] isEqualToString:@"0"]) {
        self.completion(nil, responseDic);
    } else {
        NSError *error = [[NSError alloc] init];
        self.completion(error, nil);
    }
    
    completionHandler(NULL);
}

@end
