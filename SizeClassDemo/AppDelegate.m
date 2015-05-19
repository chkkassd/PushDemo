//
//  AppDelegate.m
//  SizeClassDemo
//
//  Created by peter on 14-10-16.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+Tony.h"
#import "ZDWebConnection.h"
#import "ZDWebService.h"
#import <CommonCrypto/CommonDigest.h>

@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureRemoteNotification];
    
    
    NSDictionary * noti = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"%@",noti);
    
    return YES;
}

#pragma mark - 接收到远程推送的回调

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:@"IdAccept"]) {
        NSLog(@"accept");
    } else if ([identifier isEqualToString:@"IdReject"]) {
        NSLog(@"reject");
    }
    
    if (completionHandler) {
        completionHandler();
    }
}
#pragma mark - 注册远程推送回调

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    self.tokenString = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

#pragma mark - methods

- (void)configureRemoteNotification {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    } else {
        //创建动作
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"IdReject";
        action.title = @"忽略";
        action.activationMode = UIUserNotificationActivationModeBackground;
        action.authenticationRequired = YES;
        action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"IdAccept";
        action2.title = @"查看";
        action2.activationMode = UIUserNotificationActivationModeForeground;

        //创建动作集合
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = @"IdQuickOperation";
        [category setActions:@[action,action2] forContext:UIUserNotificationActionContextDefault];
        
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |UIUserNotificationTypeSound |UIUserNotificationTypeBadge categories:[NSSet setWithObject:category]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
@end
