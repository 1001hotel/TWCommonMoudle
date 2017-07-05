//
//  TWCommonDefine.h
//  TWCommonMoudleDemo
//
//  Created by luomeng on 2017/7/4.
//  Copyright © 2017年 XRY. All rights reserved.
//

#ifndef TWCommonDefine_h
#define TWCommonDefine_h

#import "UIColor+ColorTransfer.h"
#import "UIView+Extension.h"
#import "UIView+ZLAutoLayout.h"


#define KEY_ACCESSTOKEN                       @"accesstoken"
#define IS_EXPERT                             @"isExpert"

//调试状态下生效的日志打印
#ifdef DEBUG
#   define MyLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define MyLog(...)
#endif



//色值转换（需要将#换成0x）
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//把NSNull类型的值替换成@""
#define VerifyValue(value)\
({id result;\
if ([value isKindOfClass:[NSNull class]]){\
result = @"";}\
else if([value isKindOfClass:[NSDictionary class]]||[value isKindOfClass:[NSArray class]])\
{result=value;}\
else if([[NSString stringWithFormat:@"%@",value]isEqualToString:@"(null)"])\
{result=@"";}\
else\
{result = [NSString stringWithFormat:@"%@",value];}\
result;\
})\

#define IsAvilableValue(value)\
({BOOL result;\
if ([value isKindOfClass:[NSNull class]]){\
result = 0;}\
else if([value isKindOfClass:[NSDictionary class]]||[value isKindOfClass:[NSArray class]])\
{result=1;}\
else if([[NSString stringWithFormat:@"%@",value]isEqualToString:@"(null)"])\
{result=0;}\
else\
{result = 1;}\
result;\
})\

#define DEFAULT_IMAGE_HEAD    [UIImage imageNamed:@"head_default"]
#define DEFAULT_IMAGE         [UIImage imageNamed:@"common_head_default"]

//给定iPhone6 plus屏幕下的100个像素点
#define ONE_HUNDRED_PIXEL [UIScreen mainScreen].bounds.size.width * 100.0 / 414.0

#define hundredLenthForIPhone6s [UIScreen mainScreen].bounds.size.width * 100.0 / 375.0
//#define hundredLenthForIPhone6s 100.0


//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NAVBAR_HEIGHT 44
#define PAGE_PER_NUM 20

#define MAINCOLOR [UIColor colorWithRed:74 / 255.0 green:189 / 255.0 blue:204 / 255.0 alpha:1]
#define PLACEHOLDERCOLOR [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1]
#define INPUTCOLOR [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1]

#define MALE_COLOR [UIColor colorTransferToRGB:@"#7bc3f7"]
#define FEMALE_COLOR [UIColor colorTransferToRGB:@"#fab9c6"]

#define APPID_VALUE                              @"58809cff"


#define REDIREC_URL                @"http://1001tourway.com/"

#define SINA_WEIBO_APPKEY          @"2699227547"
#define SINA_WEIBO_APPSECRET       @"5bfc19c93cc31d3a03284fd945ddc80a"

#define QQ_APPKEY                  @"1105532851"
#define QQ_APPSECRET               @"eMlwZS1vNKn6grcr"

#define WECHAT_APPKEY              @"wxb667dc352c05a728"
#define WECHAT_APPSECRET           @"ca2575373e9f6e20a01c1b87b7db3b7a"

#define FACEBOOK_APPKEY            @"622510244594247"
#define FACEBOOK_APPSECRET         @"a3fc06ef2e2917e0318fa7ee845714f0"


#define NOTIFICATION_USER_INFO_CHANGED         @"userInfoChanged"
#define NOTIFICATION_USER_CHANGED              @"userChanged"



#define MEDIA_BASE                      @"Media/"
#define IMAGE_DIR                       @"Images/"
#define AUDIO_DIR                       @"Audio/"
#define VIDEO_DIR                       @"Video/"
#define OTHER_DIR                       @"Other/"
#define DATA_DIR                        @"Data/"



#define TODAY                                       @"today"
#define JANUARY                                     @"January"//一月January
#define FEBRUARY                                    @"February"//二月February
#define MARCH                                       @"March"//三月March
#define APRIL                                       @"April"//四月April
#define MAY                                         @"May"//五月May
#define JUNE                                        @"June"//六月June
#define JULY                                        @"July"//七月July
#define AUGUST                                      @"August"//八月August
#define SEPTEMBRT                                   @"September"//九月September
#define OCTOBER                                     @"October"//十月October
#define NOVEMBER                                    @"November"//十一月November
#define DECEMBER                                    @"December"//十二月December


#endif /* TWCommonDefine_h */






