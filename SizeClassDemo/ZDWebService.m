//
//  ZDWebService.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDWebService.h"
#import "ZDWebService+URL.h"
#import "WebConnect.h"
#import "ZDNSURLSession.h"
#define BASE_URL        @"http://120.24.67.134:8080/AlertMe/"
@implementation ZDWebService

- (void)sendHttpRequestWithUrl:(NSURL *)url body:(NSData *)body completion:(void(^)(NSString *obj))handler {
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:
//     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//         if (connectionError) {
//             handler(nil);
//         } else {
//             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//                 if (httpResponse.statusCode == 200) {
//                     NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                     NSLog(@"Status: %@", status);
//                     handler(status);
//                 } else {
//                     handler(nil);
//                 }
//             }
//         }
//     }];
    
//    NSURLSession * session = [NSURLSession sharedSession];
//    [[session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (!error) {
//            NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"Status: %@", status);
//        } else {
//            handler(nil);
//        }
//    }] resume];
//    ZDNSURLSession * session = [[ZDNSURLSession alloc] initWithRequest:request completionHandler:handler];
//    [session startSession];
    
}

- (void)signInWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSString *obj))handler {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"signIn"]];
    
    NSString *bodyString = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [self sendHttpRequestWithUrl:url body:body completion:handler];
}

#pragma mark - 所有webservice接口

//登录接口   对外暴露的error，若为nil则取到数据，若不为nil，链接失败
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler
{
    password = [NSString md5:password];
    NSDictionary *dic = @{
                           @"userName":userName,
                           @"password":password
                           };
    NSURL *url = [self URLForLogin];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

- (void)loginSessionWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler
{
    password = [NSString md5:password];
    NSDictionary *dic = @{
                          @"userName":userName,
                          @"password":password
                          };
    NSURL *url = [self URLForLogin];
    [self fetchSessionByWebserviceURL:url dictionary:dic handler:handler];
}

//根据用户id得到所有的customers的总数量
- (void)fetchCustomersCountWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler
{
    NSDictionary *dic = @{
                           @"id":userid
                           };
    NSURL *url = [self URLForGetCustomersCount];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//根据用户id得到所有的customers,废弃
- (void)fetchCustomersWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler
{
    NSDictionary *dic = @{
                          @"pageNo":@"1",
                          @"pageSize":@"20",
                          @"id":userid
                          };
    NSURL *url = [self URLForGetAllCustomers];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//根据cusmomerid得到其所有的产品,废弃
- (void)fetchProductsWithCustomerId:(NSString *)customerid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler
{
    NSDictionary *dic = @{@"id":customerid};
    NSURL *url = [self URLForGetAllProductsWithCustomer];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//根据productid得到产品详情，废弃
- (void)fetchProductDetailWithProductId:(NSString *)productid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler
{
    NSDictionary *dic = @{@"id":productid};
    NSURL *url = [self URLForGetProductDetailWithProduct];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//根据customer的mobile查询其业务,”0”:理财, ”1”:借贷
//- (void)fetchBusinessWithCustomerMobile:(NSString *)mobile andBusinessType:(NSString *)type completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
//{
//    NSDictionary * dic = @{@"mobile": mobile, @"businessType":@"0"};//0，理财，1，借贷，现阶段只有理财
//    NSURL *url = [self URLForGetAllBusinessWithCustomer];
//    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
//}

- (void)fetchBusinessesWithCustomerId:(NSString *)customerid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler
{
    NSDictionary *dic = @{@"id":customerid};
    NSURL *url = [self URLForGetBusinessesWithCustomerId];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

- (void)fetchBusinessesWithManagerId:(NSString *)managerid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler
{
    NSDictionary *dic = @{@"managerId":managerid};
    NSURL *url = [self URLForGetBusinessesWithManagerId];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

#pragma mark - 储备客户相关

//获取所有客户列表，用于机会页面,type:0-all、1-储备客户、2-客户、3-老客户
- (void)fetchAllCustomersWithManagerUserId:(NSString *)userid
                                      type:(NSString *)type
                               completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{
                           @"managerId": userid,
                           @"pageNum": @"1",
                           @"pageSize": @"400",
                           @"type": type
                           };
    NSURL * url = [self URLForGetAllChanceCustomers];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

// 新增储备客户
- (void)addPotentialCustomerWithCustomerName:(NSString *)customerName
                         sex:(NSString *)sex
                   managerId:(NSString *)managerId
                      mobile:(NSString *)mobile
                        memo:(NSString *)memo
                        hope:(NSString *)hope
                      source:(NSString *)source
                        area:(NSString *)areaValue
           completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{
                           @"managerId": managerId,
                           @"customerName": customerName,
                           @"sex": sex,
                           @"mobile": mobile,
                           @"memo": memo,
                           @"hope": hope,
                           @"source": source,
                           @"area":areaValue
                           };
    NSURL * url = [self URLForAddPotentialCustomer];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

// 更改储备客户
// 1000541601
- (void)updatePotentialCustomerWithCustomerName:(NSString *)customerName
                         sex:(NSString *)sex
                   managerId:(NSString *)managerId
                      mobile:(NSString *)mobile
                        memo:(NSString *)memo
                        hope:(NSString *)hope
                      source:(NSString *)source
               andCustomerId:(NSString *)customerId
           completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{
                           @"managerId": managerId,
                           @"customerName": customerName,
                           @"sex": sex,
                           @"mobile": mobile,
                           @"memo": memo,
                           @"hope": hope,
                           @"source": source,
                           @"customerId": customerId
                           };
    NSURL * url = [self URLForUpdatePotentialCustomer];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}


// 删除储备客户
- (void)deletePotentialCustomerWithCustomerId:(NSString *)customerId
              completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{
                           @"customerId": customerId
                           };
    NSURL * url = [self URLForDeletePotentialCustomer];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

#pragma mark - 联系记录

//获取客户联系纪录列表
- (void)fetchCustomerContactListWithManagerUserId:(NSString *)userid
                                    andCustomerId:(NSString *)customerid
                                completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{
                           @"managerId": userid,
                           @"customerid": customerid
                           };
    NSURL * url = [self URLForGetCustomerContactLists];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

// 新增客户联系记录,contactType: 联系方式（1-电话、2-邮件、3-QQ、4-传真）hope: 客户意愿(3-一般，2-感兴趣，1-强烈)
- (void)addContactRecordWithManagerId:(NSString *)managerId
              customerId:(NSString *)customerId
             contactType:(NSString *)contactType
              contactNum:(NSString *)contactNum
                 content:(NSString *)content
                    hope:(NSString *)hope
             contactTime:(NSString *)contactTime
               inputDate:(NSString *)inputDate
                 inputId:(NSString *)inputId
                    memo:(NSString *)memo
                 handler:(void (^)(NSError *error, NSDictionary *resultDic))handler
{
    NSDictionary * dic = @{
                           @"managerId": managerId,
                           @"customerId": customerId,
                           @"contactType": contactType,
                           @"contactNum": contactNum,
                           @"memo": memo,
                           @"hope": hope,
                           @"content": content,
                           @"contactTime": contactTime,
                           @"inputDate": inputDate,
                           @"inputId": inputId,

                           };
    NSURL * url = [self URLForAddContact];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

// 修改客户联系记录
- (void)updateContactRecordWithManagerId:(NSString *)managerId
              customerId:(NSString *)customerId
             contactType:(NSString *)contactType
              contactNum:(NSString *)contactNum
                 content:(NSString *)content
                    hope:(NSString *)hope
             contactTime:(NSString *)contactTime
               inputDate:(NSString *)inputDate
                 inputId:(NSString *)inputId
                    memo:(NSString *)memo
                   recordId:(NSString *)recordId
                 handler:(void (^)(NSError *error, NSDictionary *resultDic))handler
{
    NSDictionary * dic = @{
                           @"managerId": managerId,
                           @"customerId": customerId,
                           @"contactType": contactType,
                           @"contactNum": contactNum,
                           @"memo": memo,
                           @"hope": hope,
                           @"content": content,
                           @"contactTime": contactTime,
                           @"inputDate": inputDate,
                           @"inputId": inputId,
                           @"recordId": recordId
                           };
    NSURL * url = [self URLForUpdateContact];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

// 删除客户联系记录
- (void)deleteContactRecordWithCustomerId:(NSString *)customerId
                   recordId:(NSString *)recordId
              completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{
                           @"customerId": customerId,
                           @"recordId": recordId
                           };
    NSURL * url = [self URLForDeleteContact];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//意见反馈,
- (void)commitFeedbackWithManagerId:(NSString *)managerId
                            Context:(NSString *)context
                           OperDate:(NSString *)operDate
                            AppType:(NSString *)appType
                         AppVersion:(NSString *)appVersion
                             System:(NSString *)system
                      SystemVersion:(NSString *)systemVersion
                  completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{
                           @"managerId": managerId,
                           @"context": context,
                           @"operDate": operDate,
                           @"appType": appType,
                           @"appVersion": appVersion,
                           @"system": system,
                           @"systemVersion": systemVersion
                           };
    NSURL * url = [self URLForCommitFeedback];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//登录后获取提醒信息,  infoType:1投资，2生日
- (void)fetchRemindInfosWithManagerId:(NSString *)managerId
                    completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{@"id": managerId};
    NSURL * url = [self URLForGetRemindInfos];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//查看投资到期提醒信息列表
- (void)fetchCreditRemindListWithManagerId:(NSString *)managerId
                                  pageSize:(NSString *)pageSize
                                    pageNo:(NSString *)pageNo
                         completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{@"pageNo": pageNo,
                           @"pageSize": pageSize,
                           @"id": managerId};
    NSURL * url = [self URLForGetCreditRemindList];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//查看生日到期提醒信息列表
- (void)fetchBirthRemindListWithManagerId:(NSString *)managerId
                                  pageSize:(NSString *)pageSize
                                    pageNo:(NSString *)pageNo
                         completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{@"pageNo": pageNo,
                           @"pageSize": pageSize,
                           @"id": managerId};
    NSURL * url = [self URLForGetBirthRemindList];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//二维码扫描登录
- (void)CRMLoginOnWebWithUserName:(NSString *)userName
                         dimeCode:(NSString *)dimeCode
                completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{@"userName":userName,
                           @"dimeCode":dimeCode
                           };
    NSURL * url = [self URLForLoginOnWebByDimeCode];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//二维码扫描确认登录
- (void)confirmCRMLoginOnWebWithdimeCode:(NSString *)dimeCode
                       completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{@"dimeCode":dimeCode};
    
    NSURL * url = [self URLForLoginOnWebByDimeCodeConfirm];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//二维码扫描取消登录
- (void)cancleCRMLoginOnWebWithdimeCode:(NSString *)dimeCode
                      completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{@"dimeCode":dimeCode};
    
    NSURL * url = [self URLForLoginOnWebByDimeCodeCancle];
    [self fetchByWebserviceURL:url dictionary:dic handler:handler];
}

//获取参数
- (void)fetchParamsWithParams:(NSString *)params
            completionHandler:(void(^)(NSError * error,NSDictionary * resultDic))handler
{
    NSDictionary * dic = @{@"params": @[params]};
    
    NSURL * url = [self URLForqueryParams];
    [self fetchParamsByWebserviceURL:url dictionary:dic handler:handler];
}

#pragma mark - 共用请求方法

// webservice的接口请求设置
- (void)fetchByWebserviceURL:(NSURL *)url dictionary:(NSDictionary *)dict handler:(void (^)(NSError *error, NSDictionary *resultDic))handler
{
    NSString *jsonString = [self translateToJsonStringWithDictionary:dict];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonString length]];
    
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"" forHTTPHeaderField:@"netmac"];//客户端网卡mac值
    [req addValue:[self currentAppVersion] forHTTPHeaderField:@"version"];//手机端应用版本号
    [req addValue:@"" forHTTPHeaderField:@"token"];//ios提交
//    [req addValue:@"" forHTTPHeaderField:@"User-Agent"];//1.系统的名称如： iPhone OS，Android 2.设备系统的版本号；如： 5.1、6.0、7.0 3.设备的型号 如：iPad、iphone、ipod touch
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    WebConnect * connection = [[WebConnect alloc] initWithRequest:req completionHandler:handler];
    [connection startConnection];
}

- (void)fetchSessionByWebserviceURL:(NSURL *)url dictionary:(NSDictionary *)dict handler:(void (^)(NSError *error, NSDictionary *resultDic))handler
{
    NSString *jsonString = [self translateToJsonStringWithDictionary:dict];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonString length]];
    
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"" forHTTPHeaderField:@"netmac"];//客户端网卡mac值
    [req addValue:[self currentAppVersion] forHTTPHeaderField:@"version"];//手机端应用版本号
    [req addValue:@"" forHTTPHeaderField:@"token"];//ios提交
    //    [req addValue:@"" forHTTPHeaderField:@"User-Agent"];//1.系统的名称如： iPhone OS，Android 2.设备系统的版本号；如： 5.1、6.0、7.0 3.设备的型号 如：iPad、iphone、ipod touch
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ZDNSURLSession * session = [[ZDNSURLSession alloc] initWithRequest:req completionHandler:handler];
    [session startSession];
//    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    NSURLSession * session = [NSURLSession sharedSession];//[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
//     [[session uploadTaskWithRequest:req fromData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//         if (!error) {
//             NSError *Error = nil;
//             NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&Error];
//             NSLog(@"%@",responseDic);
//             handler(nil,responseDic);
//         } else {
//             NSLog(@"%@",error.localizedDescription);
//             NSError * Error = [[NSError alloc] init];
//             handler(Error,nil);
//         }
//        
//    }] resume];
}

- (void)fetchParamsByWebserviceURL:(NSURL *)url dictionary:(NSDictionary *)dict handler:(void (^)(NSError *error, NSDictionary *resultDic))handler
{
    NSString *jsonString = [self translateParamsToJsonStringWithDictionary:dict];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonString length]];
    
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"" forHTTPHeaderField:@"netmac"];//客户端网卡mac值
    [req addValue:[self currentAppVersion] forHTTPHeaderField:@"version"];//手机端应用版本号
    [req addValue:@"" forHTTPHeaderField:@"token"];//ios push
//    [req addValue:@"" forHTTPHeaderField:@"User-Agent"];//1.系统的名称如： iPhone OS，Android 2.设备系统的版本号；如： 5.1、6.0、7.0 3.设备的型号 如：iPad、iphone、ipod touch
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*
    //ios5之后新增异步发送接口，无需再调用connectiondelegate
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            //解析得到的json数据
            NSError *error = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"%@",responseDic);
            if ([responseDic[@"status"] isEqualToString:@"0"]) {
                handler(nil, responseDic);
            } else {
                NSError *error = [[NSError alloc] init];
                handler(error, nil);
            }
        } else {
            NSLog(@"Http error:%@", connectionError.localizedDescription);
            handler(connectionError, nil);
        }
    }];
     */
    WebConnect * connection = [[WebConnect alloc] initWithRequest:req completionHandler:handler];
    [connection startConnection];
}

- (NSString *)currentAppVersion
{
    NSDictionary * info = [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleShortVersionString"];
}

#pragma mark - translateToJsonString

- (NSString *)translateToJsonStringWithDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSArray *values = [dic allValues];
    NSString *jsonString = @"json={";
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

- (NSString *)translateParamsToJsonStringWithDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSArray *values = [dic allValues];
    NSString *jsonString = @"json={";
    for (int i = 0; i < keys.count; i ++) {
        if (i != (keys.count - 1)) {
            jsonString = [jsonString stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\",",keys[i],values[i]]];
        } else {
            jsonString = [jsonString stringByAppendingString:[NSString stringWithFormat:@"\"%@\":[\"%@\"]",keys[i],[values[i] firstObject]]];
        }
    }
    jsonString = [jsonString stringByAppendingString:@"}"];
    return jsonString;
}

#pragma mark - sharedInstance

+ (ZDWebService *)sharedWebViewService
{
    static dispatch_once_t once;
    static ZDWebService *sharedWebService;
    dispatch_once(&once, ^{
        sharedWebService = [[self alloc] init];
    });
    return sharedWebService;
}

@end
