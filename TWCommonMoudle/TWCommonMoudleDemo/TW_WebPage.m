//
//  TW_WebPage.m
//  TourWay
//
//  Created by luomeng on 15/12/29.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import "TW_WebPage.h"
#import "TWUserDefine.h"


@interface TW_WebPage ()
<
UIWebViewDelegate
>
{
    
    __weak IBOutlet UIWebView *_webView;
}

@end

@implementation TW_WebPage (private)

- (void)cleanCacheAndCookie{
    //清除cookies
    //    NSHTTPCookie *cookie;
    //    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //    for (cookie in [storage cookies]){
    //        [storage deleteCookie:cookie];
    //    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
- (void)_back{
    
    [self cleanCacheAndCookie];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [super back];
}

@end

@implementation TW_WebPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [self createTopLeftBack:@selector(_back)];
    [self startLoading];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}
-(void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
    if (self.isViewLoaded && !self.view.window) {
        
#ifdef INTERNAL_SERVER_DEBUG_MODE
        NSLog(@"%@ didReceiveMemoryWarning, it's view change nil.", [[self class] description]);
#endif
        self.view = nil;
    }
}

#pragma mark -
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopLoading];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([_webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[self createTopLeftBack], [self createCustomizedItemWithSEL:@selector(_back) titleStr:@"关闭" titleColor:[UIColor whiteColor]], nil];
    }

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self stopLoading];
}
- (void)_back{

   [super back];
}
- (void)back{

    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    else{
    
        [super back];
    }
}


@end









