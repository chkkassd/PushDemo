//
//  ViewController.m
//  SizeClassDemo
//
//  Created by peter on 14-10-16.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ViewController.h"
#import "ZDWebConnection.h"
#import "AppDelegate.h"
#import "NSString+Tony.h"
#import <CommonCrypto/CommonDigest.h>

#define UserName @"UserName"
#define UserPassword @"UserPassword"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)updateInfo:(NSNotification *)noti
{
    self.infoLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"managerid"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    self.infoLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"managerid"];
}

- (IBAction)registerButtonPressed:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString * projectNo = ProjectNo;
    NSString * groupNo = @"34343";
    NSString * groupName = @"haha";
    NSString * userNo = @"20553013";
    NSString * userName = @"hehe";
    NSString * deviceNo = appDelegate.tokenString;//@"3302f8c9e6dc3c0c1c34978c06e4eb8c";//设备编号,唯一标示符
    NSString * deviceSn = [NSString stringWithFormat:@"iOS_%@",appDelegate.tokenString];;//设备序列号
    NSString * deviceType = @"1";
    
    long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    
    NSString * reqTimestamp = [NSString stringWithFormat:@"%lld",time];
    NSString * dateString = [[NSString stringTranslatedFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * sn = [NSString stringWithFormat:@"%@-%@",ProjectNo,dateString];//[NSString stringWithFormat:@"A%@",[NSString uuidString]];
    NSString * signOri = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",projectNo,groupNo,groupName,userNo,userName,deviceNo,deviceSn,deviceType,reqTimestamp,sn,secret];
    NSString * sign = [NSString md5StringFromString:signOri];
    
    NSDictionary * dic = @{@"projectNo":projectNo,
                           @"groupNo":groupNo,
                           @"groupName":groupName,
                           @"userNo":userNo,
                           @"userName":userName,
                           @"deviceNo":deviceNo,
                           @"deviceSn":deviceSn,
                           @"deviceType":deviceType,
                           @"reqTimestamp":reqTimestamp,
                           @"sn":sn,
                           @"sign":sign
                           };
    NSString * dataString = [self translateToJsonStringWithDictionary:dic];
    
    [self newRegisterDeviceWithType:@"200001" dataString:dataString completionHandler:^(NSString *string, NSError *error) {
        if (!error) {
            NSLog(@"%@",string);
        } else {
            NSLog(@"%@",error.localizedDescription);
        }
        
    }];

}

- (IBAction)sendButtonPressed:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString * smsTitle = @"hello";
    NSString * smsTxt = @"hello world呵呵";//广播，必推
    NSString * smsTransContent = @"I am peter哈哈";//消息，必推,推送内容
    NSString * projectNo = ProjectNo;
    NSString * target = [NSString stringWithFormat:@"[{\\\"pn\\\":\\\"D\\\",\\\"t\\\":\\\"14\\\",\\\"no\\\":\\\"%@\\\"}]",@"5912984b4aea64b73744e6c272d69b9916c0fa3225109e4a43d41dd74c82fa1d"];
    NSString * target2 = [NSString stringWithFormat:@"[{\"pn\":\"D\",\"t\":\"14\",\"no\":\"%@\"}]",@"5912984b4aea64b73744e6c272d69b9916c0fa3225109e4a43d41dd74c82fa1d"];
    NSString * sendType = @"1";//1.广播2.消息
    NSString * pshType = @"1";//消息类型
    NSString * sendTime = @"";//[NSString stringTranslatedFromDate:[NSDate date]];
    NSString * smsType = @"0";
    NSString * priority = @"1";
    NSString * maxCount = @"3";
    NSString * remark = @"{\\\"type\\\":\\\"1\\\",\\\"content\\\":\\\"peter\\\"}";
    NSString * remark2 = @"{\"type\":\"1\",\"content\":\"peter\"}";
    long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    NSString * reqTimestamp = [NSString stringWithFormat:@"%lld",time];
    NSString * dateString = [[NSString stringTranslatedFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * sn = [NSString stringWithFormat:@"%@-%@",ProjectNo,dateString];//[NSString stringWithFormat:@"A%@",[NSString uuidString]];
    
    NSString * signOri = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",smsTitle,smsTxt,smsTransContent,projectNo,target2,sendType,pshType,sendTime,smsType,priority,maxCount,remark2,reqTimestamp,sn,secret];
    NSString * sign = [NSString md5StringFromString:signOri];
    
    NSDictionary * dic = @{@"smsTitle":smsTitle,
                           @"smsTxt":smsTxt,
                           @"smsTranscontent":smsTransContent,
                           @"projectNo":projectNo,
                           @"target":target,
                           @"sendType":sendType,
                           @"pshType":pshType,
                           @"sendTime":sendTime,
                           @"smsType":smsType,
                           @"priority":priority,
                           @"maxCount":maxCount,
                           @"remark":remark,
                           @"reqTimestamp":reqTimestamp,
                           @"sn":sn,
                           @"sign":sign
                           };
    NSString * dataString = [self translateToJsonStringWithDictionary:dic];

    [self newSendRemotePushWithType:@"100001" dataString:dataString completionHandler:^(NSString *string, NSError *error) {
        if (!error) {
            NSLog(@"%@",string);
        } else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

//设备注册
- (void)registerDeviceWithType:(NSString *)typeString
                    dataString:(NSString *)dataString
             completionHandler:(void (^)(NSString *string, NSError *error))handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *soapMsg = [NSString stringWithFormat:
                                @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://websvc/\">"
                                 "<soapenv:Header/>"
                                 "<soapenv:Body>"
                                 "<web:dispatchCommand>"
                                 "<!--Optional:-->"
                                 "<web:arg0>%@</web:arg0>"
                                 "<!--Optional:-->"
                                 "<web:arg1>%@</web:arg1>"
                                 "</web:dispatchCommand>"
                                 "</soapenv:Body>"
                                 "</soapenv:Envelope>",typeString,dataString];
            
            NSURL *url = [NSURL URLWithString: PushWebURL];
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
            [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            [req setHTTPMethod:@"POST"];
            [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
            
            ZDWebConnection * connection = [[ZDWebConnection alloc] initWithRequest:req completionHandler:handler];
            [connection startConnection];
        });
    });
}

//设备注册
- (void)newRegisterDeviceWithType:(NSString *)typeString
                       dataString:(NSString *)dataString
                completionHandler:(void (^)(NSString *string, NSError *error))handler
{
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://websvc/\">"
                         "<soapenv:Header/>"
                         "<soapenv:Body>"
                         "<web:dispatchCommand>"
                         "<!--Optional:-->"
                         "<web:arg0>%@</web:arg0>"
                         "<!--Optional:-->"
                         "<web:arg1>%@</web:arg1>"
                         "</web:dispatchCommand>"
                         "</soapenv:Body>"
                         "</soapenv:Envelope>",typeString,dataString];
    
    NSURL *url = [NSURL URLWithString: PushWebURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            handler(string,nil);
        } else {
            handler(nil,connectionError);
        }
    }];
}

//消息推送
- (void)sendRemotePushWithType:(NSString *)typeString
                    dataString:(NSString *)dataString
             completionHandler:(void (^)(NSString *string, NSError *error))handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *soapMsg = [NSString stringWithFormat:
                                 @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://websvc/\">"
                                 "<soapenv:Header/>"
                                 "<soapenv:Body>"
                                 "<web:dispatchCommand>"
                                 "<!--Optional:-->"
                                 "<web:arg0>%@</web:arg0>"
                                 "<!--Optional:-->"
                                 "<web:arg1>%@</web:arg1>"
                                 "</web:dispatchCommand>"
                                 "</soapenv:Body>"
                                 "</soapenv:Envelope>",typeString,dataString];
            
            NSURL *url = [NSURL URLWithString: PushWebURL];
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
            [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            [req setHTTPMethod:@"POST"];
            [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
            
            ZDWebConnection * connection = [[ZDWebConnection alloc] initWithRequest:req completionHandler:handler];
            [connection startConnection];
        });
    });
}

//消息推送
- (void)newSendRemotePushWithType:(NSString *)typeString
                       dataString:(NSString *)dataString
                completionHandler:(void (^)(NSString *string, NSError *error))handler
{
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://websvc/\">"
                         "<soapenv:Header/>"
                         "<soapenv:Body>"
                         "<web:dispatchCommand>"
                         "<!--Optional:-->"
                         "<web:arg0>%@</web:arg0>"
                         "<!--Optional:-->"
                         "<web:arg1>%@</web:arg1>"
                         "</web:dispatchCommand>"
                         "</soapenv:Body>"
                         "</soapenv:Envelope>",typeString,dataString];
    
    NSURL *url = [NSURL URLWithString: PushWebURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            handler(string,nil);
        } else {
            handler(nil,connectionError);
        }
    }];
}

- (NSString *)translateToJsonStringWithDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSArray *values = [dic allValues];
    NSString *jsonString = @"{";
    for (int i = 0; i < keys.count; i ++) {
        if (i != (keys.count - 1)) {
            jsonString = [jsonString stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\",",keys[i],values[i]]];
        } else {
            jsonString = [jsonString stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",keys[i],values[i]]];
        }
    }
    jsonString = [jsonString stringByAppendingString:@"}"];
    return jsonString;
}

-(NSString *)md5:(NSString *)text {
    const char *cStr = [text UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end
