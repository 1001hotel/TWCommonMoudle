//
//  TW_WebServiceController.m
//  TourWay
//
//  Created by luomeng on 15/11/17.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import "TW_WebServiceController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "Utilities.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSError *error);

static HttpDnsService *httpdns;


@implementation TW_WebServiceController



+ (NSString *)getSign:(NSDictionary *)dic{
    
    NSArray *keys = dic.allKeys;
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[keys sortedArrayUsingDescriptors:sortDescriptors]];
    if ([sortedArray containsObject:@"version"]) {
        [sortedArray removeObject:@"version"];
    }
    if ([sortedArray containsObject:@"sign"]) {
        [sortedArray removeObject:@"sign"];
    }
    if ([sortedArray containsObject:@"mac"]) {
        [sortedArray removeObject:@"mac"];
    }
    if ([sortedArray containsObject:@"request_locale"]) {
        [sortedArray removeObject:@"request_locale"];
    }
    
    NSMutableArray *keyValueStrArr = [NSMutableArray array];
    for (NSString *key in sortedArray) {
        if ([NSString stringWithFormat:@"%@", [dic objectForKey:key]].length > 0 ) {
            NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@", key, [dic objectForKey:key]];
            [keyValueStrArr addObject:keyValueStr];
            
        }
    }
    NSString *resultTemp = [keyValueStrArr componentsJoinedByString:@"&"];
    NSString *resultStr = [NSString stringWithFormat:@"%@&key=8b790e0fb4484a17bd726dc4b060a0c8", resultTemp];
    NSString *md5Result = [Utilities md5:resultStr];
    NSString *upperStr = [md5Result uppercaseString];
    
    return upperStr;
}
+ (AFHTTPSessionManager *)AFJSONoperationmanager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"application/xhtml+xml",@"application/xml",@"text/json",@"text/javascript",nil];
    //,@"application/x-www-form-urlencoded
    manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    [manager setSecurityPolicy:securityPolicy];
    return manager;
}

+ (NSString *)errorDescriptionWithError:(NSError *)error{
    NSString *errorStr = @"网络或其他错误";
    NSString *str = [NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"NSLocalizedDescription"]];
    if (str.length > 0) {
        errorStr = str;
    }
    return errorStr;
}
+ (NSMutableDictionary *)requerstContentWith:(NSDictionary *)dic{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dic];
    [result setObject:@"ios" forKey:@"client"];
    [result setObject:[NSString stringWithFormat:@"%@.%@", app_Version, app_build] forKey:@"version"];
    [result setObject:[Utilities uniqueID] forKey:@"mac"];
    //    [result setObject:preferredLang forKey:@"request_locale"];
    [result setObject:[Utilities nowString] forKey:@"timestamp"];
    
    NSString *sign = [self getSign: result];
    
    
    [result setObject:sign forKey:@"sign"];
    return result;
}
+ (void)AFJSONgetWithUrl:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure{
    
  
    AFHTTPSessionManager *manager = [self AFJSONoperationmanager];
    
    __block NSString *selfUrl = url;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        @try {
            ///*
            NSString *host = [[NSURL URLWithString:url] host];
            if (host.length > 0) {
                
                httpdns = [HttpDnsService sharedInstance];
                
                [manager.requestSerializer setValue:host forHTTPHeaderField:@"host"];
                
                NSString *ip = [httpdns getIpByHostAsyncInURLFormat:host];
                
                NSRange hostFirstRange = [url rangeOfString:host];
                if (NSNotFound != hostFirstRange.location && ip.length > 0) {
                    selfUrl = [selfUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                }
            }
            //*/
        } @catch (NSException *exception) {
            
            
            
        } @finally {
            
            [manager GET:selfUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
    });
    
}
+ (void)AFJSONpostWithUrl:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure{
    
    AFHTTPSessionManager *manager = [self AFJSONoperationmanager];
    __block NSString *selfUrl = url;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            ///*
            NSString *host = [[NSURL URLWithString:url] host];
            
            if (host.length > 0) {
                
                httpdns = [HttpDnsService sharedInstance];
                
                [manager.requestSerializer setValue:host forHTTPHeaderField:@"host"];
                
                NSString *ip = [httpdns getIpByHostAsyncInURLFormat:host];
                NSRange hostFirstRange = [url rangeOfString:host];
                if (NSNotFound != hostFirstRange.location && ip.length > 0) {
                    selfUrl = [selfUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                }
                
            }
            //*/
        } @catch (NSException *exception) {
            
            
        } @finally {
            
            [manager POST:selfUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    //to be finished
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
        
    });
    
}



#pragma mark -
#pragma mark - MJ_REFRESH
+ (MJRefreshNormalHeader *)refreshHeaderWithCallback:(refreshBlock)result{
    
    //刷新
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        result();
    }];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    return refreshHead;
}
+ (MJRefreshBackStateFooter *)loadingFooterWithCallback:(loadingBlock)result{
    
    MJRefreshBackStateFooter *refreshFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        result();
    }];
    [refreshFooter setTitle:@"松开手开始加载" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"正在加载数据" forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    refreshFooter.stateLabel.textColor = [UIColor grayColor];
    return refreshFooter;
}



@end













