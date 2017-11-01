//
//  TW_WebPage.h
//  TourWay
//
//  Created by luomeng on 15/12/29.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import "TW_CommonPage.h"
#import <WebKit/WebKit.h>

@interface TW_WebPage : TW_CommonPage

@property(nonatomic, copy) NSString *webUrl;
@property(nonatomic, strong) WKWebView *webView;
@property(strong, nonatomic) UIProgressView *progressView;


- (void)cleanWebViewCacheAndCookie;
- (void)cleanWebViewCache;

@end
