//
//  TW_WebServiceController.h
//  TourWay
//
//  Created by luomeng on 15/11/17.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>



#import <MJRefresh/MJRefresh.h>

typedef void (^postCrashLogBlock)(BOOL success, NSString *desc);


typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSError *error);
typedef void (^refreshBlock)();
typedef void (^loadingBlock)();



@interface TW_WebServiceController : NSObject


+ (NSString *)errorDescriptionWithError:(NSError *)error;
+ (NSMutableDictionary *)requerstContentWith:(NSDictionary *)dic;
+ (void)AFJSONgetWithUrl:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;
+ (void)AFJSONpostWithUrl:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;


#pragma mark -
#pragma mark - MJ_REFRESH
+ (MJRefreshNormalHeader *)refreshHeaderWithCallback:(refreshBlock)result;
+ (MJRefreshBackStateFooter *)loadingFooterWithCallback:(loadingBlock)result;

@end











