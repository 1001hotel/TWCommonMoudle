//
//  TW_WebPage.m
//  TourWay
//
//  Created by luomeng on 15/12/29.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import "TW_WebPage.h"
#import <WebKit/WebKit.h>


@interface TW_WebPage ()
{
    
     WKWebView *_webView;
    
    float _startProgress;

}


@property(strong, nonatomic) UIProgressView *progressView;


@end

@implementation TW_WebPage (private)


- (void)_initWKWebView{
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.processPool = [[WKProcessPool alloc] init];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 20) configuration:config];
    [self.view addSubview:_webView];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setTranslucent:NO];
    
     [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}
//进度条
- (void)initProgressView{
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
    progressView.tintColor = [UIColor colorWithRed:74 / 255.0 green:189 / 255.0 blue:204 / 255.0 alpha:1];
    progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    float progressvalue = 0;
    
    while (progressvalue < 10) {
        
        progressvalue = arc4random() % 50;
    }
    
    _startProgress = progressvalue / 100.0;
    [self.progressView setProgress:_startProgress animated:YES];
}
- (void)_back{
    
    [self cleanCacheAndCookie];
    [self dismissViewControllerAnimated:YES completion:nil];
    [super back];
}

@end

@implementation TW_WebPage

#pragma mark -
#pragma mark - lifeCycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItem = [self createCustomizedItemWithSEL:@selector(_back) titleStr:@"返回" titleColor:[UIColor blueColor]];
    [self _initWKWebView];
    [self initProgressView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
    if (self.isViewLoaded && !self.view.window) {
        
#ifdef INTERNAL_SERVER_DEBUG_MODE
        NSLog(@"%@ didReceiveMemoryWarning, it's view change nil.", [[self class] description]);
#endif
        self.view = nil;
    }
}
- (void)dealloc{
    
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (void)cleanCacheAndCookie{
    
    if ([[UIDevice currentDevice] systemVersion].floatValue > 9.0) {
        
        //        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSSet *websiteDataTypes = [NSSet setWithArray:[NSArray arrayWithObjects:
                                                       WKWebsiteDataTypeDiskCache,
                                                       WKWebsiteDataTypeMemoryCache,
                                                       WKWebsiteDataTypeOfflineWebApplicationCache,
                                                       WKWebsiteDataTypeSessionStorage,
                                                       WKWebsiteDataTypeLocalStorage,
                                                       WKWebsiteDataTypeWebSQLDatabases,
                                                       WKWebsiteDataTypeIndexedDBDatabases,
                                                       nil]];
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
        }];
    }
    else{
        
        
    }
}

#pragma mark -
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
        }
        else {
            
            self.progressView.hidden = NO;
            
            float progress = _startProgress + (newprogress * (1 - _startProgress));
            [self.progressView setProgress:progress animated:YES];
        }
    }
    else if (object == _webView && [keyPath isEqualToString:@"title"]){
        
        self.navigationItem.title = _webView.title;
    }
    else if (object == _webView && [keyPath isEqualToString:@"canGoBack"]){
        
//       self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[self createTopLeftBack], [self createCustomizedItemWithSEL:@selector(_back) titleStr:@"关闭" titleColor:[UIColor blueColor]], nil];
    }
    else{
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark -
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopLoading];
    
    if (self.navigationItem.title.length == 0) {
        
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    if ([_webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[self createTopLeftBack], [self createCustomizedItemWithSEL:@selector(_back) titleStr:@"关闭" titleColor:[UIColor blueColor]], nil];
    }

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self stopLoading];
}
- (void)_back{

    [self dismissViewControllerAnimated:YES completion:nil];
   [super back];
}
- (void)back{

    if ([_webView canGoBack]) {
        
        [_webView goBack];
    }
    else{
    
        [self _back];
    }
}


@end









