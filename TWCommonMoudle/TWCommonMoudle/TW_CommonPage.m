//
//  TW_CommonPage.m
//  TourWay
//
//  Created by luomeng on 15/11/3.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import "TW_CommonPage.h"
#import "AlertMessage.h"
#import "FreshLoadingView.h"
#import "AFNetworking.h"


#define STATUSBAR_HEIGHT                    20
#define NAVIGATIONBAR_HEIGHT                44
#define NAVIGATIONBAR_LABEL_WIDTH           160
#define NAVIGATIONBAR_BUTTON_HEIGHT         44
#define NAVIGATIONBAR_BUTTON_TEXT_WIDTH     24
#define NAVIGATIONBAR_BUTTON_FONT_SIZE      16
#define NAVIGATIONBAR_LEFT_BUTTON_TO_LEFT   1
#define NAVIGATIONBAR_RIGHT_BUTTON_TO_RIGHT 1
#define OTHERBUTTONTITTLES                  @"繼續",@"确定"

#define Block_copy(...) ((__typeof(__VA_ARGS__))_Block_copy((const void *)(__VA_ARGS__)))
#define Block_release(...) _Block_release((const void *)(__VA_ARGS__))


#define hundredLenthForIPhone6s [UIScreen mainScreen].bounds.size.width * 100.0 / 375.0
#define NAVBAR_HEIGHT 44
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define URL_TOURWAY_DOWNLOAD                  @"http://web.1001hi.com/h5/download/mobile/index.html"


@interface TW_CommonPage ()
<
AlertMessageDelegate,
UIAlertViewDelegate,
UIGestureRecognizerDelegate
>
{
    
    UIView *_emptyView;
    CGFloat _keyBoardHeight;
    UIView *_whiteView;
    
}

@end


@implementation TW_CommonPage (private)


@end

@implementation TW_CommonPage


#pragma mark -
#pragma mark - lifeCycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    [self netWorkMonitoring];
    
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef INTERNAL_SERVER_DEBUG_MODE
    //*
    //1.获取系统interactivePopGestureRecognizer对象的target对象
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    
    //2.创建滑动手势，taregt设置interactivePopGestureRecognizer的target，所以当界面滑动的时候就会自动调用target的action方法。
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    pan.delegate = self;
    
    //3.添加到导航控制器的视图上
    [self.navigationController.view addGestureRecognizer:pan];
    
    //4.禁用系统的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //*/
#endif
    //    _keyBoardHeight = 216;
    _keyBoardHeight = 0;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark -
#pragma mark - public
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)identifyTourWayName:(NSString *)str{
    
    NSString * regex = @"^[a-zA-Z\\d\\s\u2E80-\u9FFF]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
- (BOOL)identifyTourWayInputContent:(NSString *)str{
    
    NSString * regex = @"^[a-zA-Z\\d\\s\u2E80-\u9FFF_,.!:;\"?@；：“”！？]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
- (BOOL)identifyTourWayPassword:(NSString *)str{
    
    NSString * regex = @"^[A-Za-z\\d_]{6,16}$";//密码正则表达判断，规则 字母、数字、下划线 6-16位
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
- (BOOL)valiMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(173)|(177)|(18[0,1,9]))\\d{8}$";
        /**
         *全球星
         */
        NSString *GlobalStar = @"^((1349))\\d{7}$";
        /**
         *虚拟运营商（Mobile Virtual Network Operator）
         */
        NSString *MVNO = @"^((170))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", GlobalStar];
        BOOL isMatch4 = [pred4 evaluateWithObject:mobile];
        NSPredicate *pred5 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MVNO];
        BOOL isMatch5 = [pred5 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3 || isMatch4 || isMatch5) {
            return YES;
        }else{
            return NO;
        }
    }
}


#pragma mark -
#pragma mark - UIBarButtonItem
- (UIBarButtonItem *)createCustomizedItemWithSEL:(SEL)sel image:(NSString *)imgName{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:imgName];
    if (!img) {
        
        return nil;
    }
    float imgWidthHeightRatio = img.size.width / img.size.height;
    btn.frame = CGRectMake(0, 0, NAVIGATIONBAR_BUTTON_HEIGHT, NAVIGATIONBAR_BUTTON_HEIGHT);
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (UIBarButtonItem *)createCustomizedItemWithSEL:(SEL)sel image:(NSString *)imgName titleStr:(NSString *)title titleColor:(UIColor *)titleColor{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:imgName];
    float imgWidthHeightRatio = img.size.width / img.size.height;
    btn.frame = CGRectMake(0, 0, NAVIGATIONBAR_BUTTON_HEIGHT, NAVIGATIONBAR_BUTTON_HEIGHT);
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:NAVIGATIONBAR_BUTTON_FONT_SIZE]];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (UIBarButtonItem *)createCustomizedItemWithSEL:(SEL)sel image:(NSString *)imgName highlightedImg:(NSString *)imgName2{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:imgName];
    float imgWidthHeightRatio = img.size.width / img.size.height;
    btn.frame = CGRectMake(0, 0, NAVIGATIONBAR_BUTTON_HEIGHT, NAVIGATIONBAR_BUTTON_HEIGHT);
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgName2] forState:UIControlStateHighlighted];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (UIBarButtonItem *)createCustomizedItemWithSEL:(SEL)sel titleStr:(NSString*)title titleColor:(UIColor *)titleColor{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:NAVIGATIONBAR_BUTTON_FONT_SIZE], NSFontAttributeName, nil];
    CGSize size = [title sizeWithAttributes:dic];
    float btnWidth = size.width > NAVBAR_HEIGHT ? size.width + 5 : NAVBAR_HEIGHT + 5;
    btn.frame = CGRectMake(0, 0, btnWidth, NAVIGATIONBAR_BUTTON_HEIGHT);
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:NAVIGATIONBAR_BUTTON_FONT_SIZE]];
    
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (UIBarButtonItem *)createTopLeftBack{
    
    return [self createCustomizedItemWithSEL:@selector(back) image:@"back"];
}
- (UIBarButtonItem *)createTopLeftBack:(SEL)sel{
    
    return [self createCustomizedItemWithSEL:sel image:@"back"];
}


#pragma mark -
#pragma mark - alertMessage
- (void)alertMessage:(NSString *)message completion:(void (^)(void))completion{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"
                                                                mode:AlertMessageTypeAlert
                                                             message:message
                                                            delegate:self
                                                   confirmCompletion:completion
                                                    cancelCompletion:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
    [_alertMessage show];
}
- (void)alertMessageWithSelectable:(NSString *)message completion:(void (^)(void))completion cancel:(void (^)(void))cancel{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"
                                                                mode:AlertMessageTypeAlert
                                                             message:message
                                                            delegate:self
                                                   confirmCompletion:completion
                                                    cancelCompletion:cancel
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:@"取消"];
    [_alertMessage show];
}
- (void)alertMessage:(NSString *)message delayForAutoComplete:(float)delay completion:(void(^)(void))completion{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"
                                                                mode:AlertMessageTypeAlert
                                                             message:message
                                                            delegate:self
                                                   confirmCompletion:completion
                                                    cancelCompletion:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil];
    [_alertMessage showForSeconds:delay];
}
- (void)alertMessage:(NSString *)message completeSelector:(SEL)sel{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"                                                                mode:AlertMessageTypeAlert
                                                             message:message
                                                            delegate:self
                                             confirmCompleteSelector:sel
                                              cancelCompleteSelector:NULL
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
    [_alertMessage show];
}
- (void)alertMessage:(NSString *)message delayForAutoComplete:(float)delay completeSelector:(SEL)sel{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"
                                                                mode:AlertMessageTypeAlert
                                                             message:message
                                                            delegate:self
                                             confirmCompleteSelector:sel
                                              cancelCompleteSelector:NULL
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil];
    [_alertMessage showForSeconds:delay];
}
- (void)decisionMessage:(NSString *)message confirmCompletion:(void(^)(void))completion cancelCompletion:(void(^)(void))completion2{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"
                                                                mode:AlertMessageTypeDecision
                                                             message:message
                                                            delegate:self
                                                   confirmCompletion:completion
                                                    cancelCompletion:completion2
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil];
    [_alertMessage show];
}
- (void)decisionMessage:(NSString *)message confirmTitle:(NSString *)title1 confirmCompletion:(void(^)(void))completion cancelTitle:(NSString *)title2 cancelCompletion:(void(^)(void))completion2 {
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"
                                                                mode:AlertMessageTypeDecision
                                                             message:message
                                                            delegate:self
                                                   confirmCompletion:completion
                                                    cancelCompletion:completion2
                                                   cancelButtonTitle:title2
                                                   otherButtonTitles:title1, nil];
    [_alertMessage show];
}
- (void)callPromptMessage:(NSString *)message confirmCompletion:(void(^)(void))completion cancelCompletion:(void(^)(void))completion2{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:message
                                                                mode:AlertMessageTypeDecision
                                                             message:@""
                                                            delegate:self
                                                   confirmCompletion:completion
                                                    cancelCompletion:completion2
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"呼叫", nil];
    [_alertMessage show];
}
- (void)decisionMessage:(NSString *)message confirmCompletion:(void(^)(void))completion cancelCompletion:(void(^)(void))completion2 continueCompletion:(void(^)(void))completion3{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"
                                                                mode:AlertMessageTypeDecision
                                                             message:message
                                                            delegate:self
                                                   confirmCompletion:completion
                                                    cancelCompletion:completion2
                                                  continueCompletion:completion3
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitle1:@"繼續"
                                                   otherButtonTitle2:@"保存", nil];
    [_alertMessage show];
}
- (void)decisionMessage:(NSString *)message confirmTitle:(NSString *)title1 confirmCompletion:(void(^)(void))completion1 cancelTitle:(NSString *)title2 cancelCompletion:(void(^)(void))completion2 continueTitle:(NSString *)title3 continueCompletion:(void(^)(void))completion3;{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc] initWithTitle:@"温馨提示"
                                                                 mode:AlertMessageTypeDecision
                                                              message:message
                                                             delegate:self
                                                    confirmCompletion:completion1
                                                     cancelCompletion:completion2
                                                   continueCompletion:completion3
                                                    cancelButtonTitle:title2
                                                    otherButtonTitle1:title3
                                                    otherButtonTitle2:title1, nil];
    [_alertMessage show];
}
- (void)decisionMessage:(NSString *)message confirmCompleteSelector:(SEL)sel cancelCompleteSelector:(SEL)sel2{
    
    AlertMessage *_alertMessage = [[AlertMessage alloc]initWithTitle:@"温馨提示"
                                                                mode:AlertMessageTypeDecision
                                                             message:message
                                                            delegate:self
                                             confirmCompleteSelector:sel
                                              cancelCompleteSelector:sel2
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil];
    [_alertMessage show];
}

- (void)alertMessage:(NSString *)message delayFordisimissComplete:(float)delay{
    if (delay<=0) {
        delay = 2.0f;
    }
    if ([message isEqualToString:@""]) {
        
        return;
    }
    
    CGFloat gapHeight = hundredLenthForIPhone6s;
    __block UIView *alertDefineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.25 * 0.5, self.view.frame.size.height - gapHeight - _keyBoardHeight, SCREEN_WIDTH * 0.75, 30)];
    alertDefineView.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    alertDefineView.alpha = 0;
    alertDefineView.layer.cornerRadius = 6;
    
    __block UILabel *alertLabel = [[UILabel alloc]initWithFrame:alertDefineView.frame];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.numberOfLines = 0;
    alertLabel.alpha = 0;
    
    alertLabel.text = message;
    CGRect alterRect_0 = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, alertLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    alertDefineView.frame = CGRectMake((SCREEN_WIDTH-alterRect_0.size.width-30)*0.5, self.view.frame.size.height-gapHeight-_keyBoardHeight, alterRect_0.size.width+30, 30);
    alertDefineView.layer.cornerRadius = 6;
    alertLabel.frame = alertDefineView.frame;
    
    if (alterRect_0.size.width >= SCREEN_WIDTH*0.75) {
        CGRect alterRect_1 = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        alertDefineView.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH*0.75-30)*0.5, self.view.frame.size.height-gapHeight-(alterRect_1.size.height+30-30)-_keyBoardHeight, SCREEN_WIDTH*0.75+20, alterRect_1.size.height+20);
        alertDefineView.layer.cornerRadius = 6;
        alertLabel.frame = alertDefineView.frame;
    }
    [self.view addSubview:alertDefineView];
    [self.view addSubview:alertLabel];
    [self.view bringSubviewToFront:alertDefineView];
    [self.view bringSubviewToFront:alertLabel];
    
    [UIView animateWithDuration:0.2f animations:^{
        alertDefineView.alpha = 0.8;
        alertLabel.alpha =1;
    }completion:^(BOOL finished) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2f animations:^{
                alertDefineView.alpha = 0;
                alertLabel.alpha = 0;
            }completion:^(BOOL finished) {
                alertDefineView = nil;
                alertLabel =nil;
                [alertDefineView removeFromSuperview];
                [alertLabel removeFromSuperview];
            }];
        });
    }];
}
- (void)alertMessage:(NSString *)message delayFordisimissComplete:(float)delay Completion:(void(^)(void))completion{
    if (delay<=0) {
        delay = 2.0f;
    }
    
    if ([message isEqualToString:@""]) {
        
        return;
    }
    CGFloat gapHeight = hundredLenthForIPhone6s;
    
    __block UIView *alertDefineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.25*0.5, self.view.frame.size.height-gapHeight-_keyBoardHeight, SCREEN_WIDTH*0.75, 30)];
    alertDefineView.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    alertDefineView.alpha = 0;
    alertDefineView.layer.cornerRadius = 6;
    
    __block UILabel *alertLabel = [[UILabel alloc]initWithFrame:alertDefineView.frame];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.numberOfLines = 0;
    alertLabel.alpha = 0;
    alertLabel.text = message;
    
    CGRect alterRect_0 = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, alertLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    alertDefineView.frame = CGRectMake((SCREEN_WIDTH-alterRect_0.size.width-30)*0.5, self.view.frame.size.height-gapHeight-_keyBoardHeight, alterRect_0.size.width+30, 30);
    alertDefineView.layer.cornerRadius = 6;
    alertLabel.frame = alertDefineView.frame;
    
    if (alterRect_0.size.width>=SCREEN_WIDTH*0.75) {
        CGRect alterRect_1 = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH*0.75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        alertDefineView.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH*0.75-30)*0.5, self.view.frame.size.height-gapHeight-(alterRect_1.size.height+30-30)-_keyBoardHeight, SCREEN_WIDTH*0.75+20, alterRect_1.size.height+20);
        alertDefineView.layer.cornerRadius = 6;
        alertLabel.frame = alertDefineView.frame;
    }
    [self.view addSubview:alertDefineView];
    [self.view addSubview:alertLabel];
    [self.view bringSubviewToFront:alertDefineView];
    [self.view bringSubviewToFront:alertLabel];
    [UIView animateWithDuration:0.2f animations:^{
        alertDefineView.alpha = 0.8;
        alertLabel.alpha =1;
    }completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:delay repeats:NO block:^(NSTimer * _Nonnull timer) {
            [UIView animateWithDuration:0.2f animations:^{
                alertDefineView.alpha = 0;
                alertLabel.alpha = 0;
            }completion:^(BOOL finished) {
                alertDefineView = nil;
                alertLabel =nil;
                [alertDefineView removeFromSuperview];
                [alertLabel removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
        }];
    }];
}
- (void)keyBoardShow:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    _keyBoardHeight = keyboardRect.size.height;
    
}
- (void)KeyBoardHidden:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    //    _keyBoardHeight = keyboardRect.size.height;
    _keyBoardHeight = 0;
    
}


#pragma mark
#pragma mark - alertView
- (void)alertMessage:(AlertMessage *)alertMessage clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //keep this here to response alertMessage block or selector action
}



#pragma mark -
#pragma mark - emptyShow
- (void)emptyShowWithBoolIsDataAvailabel:(BOOL)isDataAvailable andMessage:(NSString *)message andInteraction:(BOOL)Ture{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    if (_whiteView != nil) {
    //        [_whiteView removeFromSuperview];
    //        _whiteView = nil;
    //    }
    //    if (_emptyView != nil) {
    //        [_emptyView removeFromSuperview];
    //        _emptyView = nil;
    //    }
    
    if (_whiteView == nil) {
        
        _whiteView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_whiteView];
    }
    
    //    CGRect windowRect = window.frame;
    if (_emptyView == nil) {
        
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 64)];
        _emptyView.center = CGPointMake(window.center.x, window.center.y-64);
        _emptyView.backgroundColor = [UIColor clearColor];
        _emptyView.userInteractionEnabled = Ture;
        UIImageView *emptyBoxImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, hundredLenthForIPhone6s*2.4, hundredLenthForIPhone6s*1.5)];
        emptyBoxImageView.image = [UIImage imageNamed:@"4-6"];
        emptyBoxImageView.center = CGPointMake(_emptyView.center.x, _emptyView.center.y-_emptyView.frame.origin.y);
        emptyBoxImageView.backgroundColor = [UIColor clearColor];
        [_emptyView addSubview:emptyBoxImageView];
        if (message) {
            
            UILabel *massageLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - hundredLenthForIPhone6s *2.40) * 0.5, emptyBoxImageView.frame.origin.y+emptyBoxImageView.frame.size.height+hundredLenthForIPhone6s * 0.2, hundredLenthForIPhone6s* 2.40, 30)];
            massageLabel.numberOfLines = 0;
            massageLabel.font = [UIFont systemFontOfSize:4];
            massageLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
            massageLabel.textAlignment = NSTextAlignmentCenter;
            massageLabel.backgroundColor = [UIColor clearColor];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 6;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:message];
            [attributeString addAttribute:NSParagraphStyleAttributeName
                                    value:paragraphStyle
                                    range:NSMakeRange(0, message.length)];
            
            [attributeString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:hundredLenthForIPhone6s *0.15]
                                    range:NSMakeRange(0, message.length)];
            
            massageLabel.attributedText = attributeString;
            
            CGRect massageRect = [attributeString boundingRectWithSize:CGSizeMake(massageLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            emptyBoxImageView.center = CGPointMake(_emptyView.center.x, _emptyView.center.y-_emptyView.frame.origin.y-(massageRect.size.height+hundredLenthForIPhone6s * 0.2) * 0.5);
            massageLabel.frame = CGRectMake((SCREEN_WIDTH - hundredLenthForIPhone6s *2.40) * 0.5, emptyBoxImageView.frame.origin.y + emptyBoxImageView.frame.size.height + hundredLenthForIPhone6s * 0.2, hundredLenthForIPhone6s *2.40, massageRect.size.height);
            
            if (massageLabel.frame.origin.y+massageLabel.frame.size.height > _emptyView.frame.size.height) {
                
                _emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, massageLabel.frame.origin.y+massageLabel.frame.size.height);
                _emptyView.center = CGPointMake(window.center.x, window.center.y - 64);
                emptyBoxImageView.center = CGPointMake(_emptyView.center.x, _emptyView.center.y - _emptyView.frame.origin.y - (massageRect.size.height + hundredLenthForIPhone6s * 0.2) * 0.5);
                massageLabel.frame = CGRectMake((SCREEN_WIDTH - hundredLenthForIPhone6s *2.40) * 0.5, emptyBoxImageView.frame.origin.y + emptyBoxImageView.frame.size.height + hundredLenthForIPhone6s * 0.2,  hundredLenthForIPhone6s *2.40, massageRect.size.height);
            }
            [_emptyView addSubview:massageLabel];
        }
        [self.view addSubview:_emptyView];
    }
    _emptyView.hidden = isDataAvailable;
    _whiteView.hidden = isDataAvailable;
    if (isDataAvailable) {
        
        [_emptyView removeFromSuperview];
        _emptyView = nil;
        [_whiteView removeFromSuperview];
        _whiteView = nil;
    }
}


#pragma mark -
#pragma mark - Loading
- (void)startLoading{
    
    if (!_loadingView) {
        
        _loadingView = [[FreshLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    if ([[NSThread mainThread] isMainThread]) {
        
        [_loadingView startAnimating];
        [self.view addSubview:_loadingView];
        [self.view bringSubviewToFront:_loadingView];
        @try {
            // 可能会出现崩溃的代码
            self.view.userInteractionEnabled = NO;
            
        }
        @catch (NSException *exception) {
            // 捕获到的异常exception
        }
        @finally {
            // 结果处理
        }
        
    }
    else{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [_loadingView startAnimating];
            [self.view addSubview:_loadingView];
            [self.view bringSubviewToFront:_loadingView];
            @try {
                // 可能会出现崩溃的代码
                self.view.userInteractionEnabled = NO;
                
            }
            @catch (NSException *exception) {
                // 捕获到的异常exception
            }
            @finally {
                // 结果处理
            }
        });
    }
}
- (void)stopLoading{
    
    
    if ([[NSThread mainThread] isMainThread]) {
        
        [_loadingView stopAnimating];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
        @try {
            // 可能会出现崩溃的代码
            self.view.userInteractionEnabled = YES;
            
        }
        @catch (NSException *exception) {
            // 捕获到的异常exception
        }
        @finally {
            // 结果处理
        }
    }
    else{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [_loadingView stopAnimating];
            [_loadingView removeFromSuperview];
            _loadingView = nil;
            @try {
                // 可能会出现崩溃的代码
                self.view.userInteractionEnabled = YES;
                
            }
            @catch (NSException *exception) {
                // 捕获到的异常exception
            }
            @finally {
                // 结果处理
            }
        });
    }
}


#pragma mark -
#pragma mark - 判断输入字符串字节数
- (int)stringLengthWithTextStr:(NSString *)str{
    
    int i,n=(int)[str length],num=0;
    for (i=0; i<n; i++) {
        
        NSRange range=NSMakeRange([str length] - i - 1,1);
        NSString *subString=[str substringWithRange:range];
        const unichar hs = [str characterAtIndex:i];
        const char *cString=[subString UTF8String];
        if (cString) {
            
            if (strlen(cString)==3){//如果是中文
                
                num+=2;
            }
            else{
                
                num++;
            }
        }
        else if (hs){
            
            num += 2;
        }
    }
    return num;
}


- (void)netWorkMonitoring{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            
            [self netWorkFailureAlter];
        }
        else if (status == AFNetworkReachabilityStatusNotReachable){
            
            [self netWorkFailureAlter];
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
        }
        else{
            
        }
    }];
    [manager startMonitoring];
    
}
- (void)netWorkFailureAlter{
    
    [self alertMessage:@"网络连接中断" delayFordisimissComplete:2];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"missNetworkConnection" object:nil];
}

- (NSString *)createQRCodeContenWithDictionary:(NSDictionary *)dic{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *text = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *type = [dic objectForKey:@"type"];
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *baseStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return [NSString stringWithFormat:@"%@?params=%@",URL_TOURWAY_DOWNLOAD, baseStr];
}
- (NSDictionary *)decodeQRCodeContenWithText:(NSString *)text{
    
    NSRange range = [text rangeOfString:@"?params="];
    
    if (range.length > 0) {
        
        NSString *base64Str = [text substringFromIndex:range.location + range.length];
        
        NSData *base64data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *decodeStr = [[NSString alloc] initWithData:base64data encoding:NSUTF8StringEncoding];
        NSData *data = [decodeStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        return dic;
    }
    return nil;
}

- (id)getObjectFromDict:(NSDictionary *)dict withKey:(NSString *)key{
    id object = @"";
    if (key == nil) {
        return object;
    }
    
    if (dict == nil || dict.count == 0 || [dict isKindOfClass:[NSNull class]]) {
        object = @"";
    }
    else if ([dict[key] isKindOfClass:[NSNull class]] || !dict[key]){
        object = @"";
    }
    else{
        object = dict[key];
    }
    return object;
}
- (BOOL)isDictionaryAvailable:(NSDictionary *)dict withKey:(NSString *)key{
    BOOL object = NO;
    if (key == nil) {
        if (dict == nil || dict.count == 0 || [dict isKindOfClass:[NSNull class]]) {
            object = NO;
        }else{
            object = YES;
        }
        return object;
    }
    
    if (dict == nil || dict.count == 0 || [dict isKindOfClass:[NSNull class]]) {
        object = NO;
    }
    else if ([dict[key] isKindOfClass:[NSNull class]] || !dict[key]){
        object = NO;
    }
    else{
        object = YES;
    }
    return object;
    
}

#pragma mark - 滑动开始触发事件
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    //只有导航的根控制器不需要右滑的返回的功能。
    //    if (self.navigationController.viewControllers.count <= 1) {
    //        return NO;
    //    }
    //    return YES;
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
}


@end









