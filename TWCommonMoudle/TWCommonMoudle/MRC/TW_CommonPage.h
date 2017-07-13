//
//  TW_CommonPage.h
//  TourWay
//
//  Created by luomeng on 15/11/3.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FreshLoadingView;
@interface TW_CommonPage : UIViewController

{
    FreshLoadingView *_loadingView;
}


- (BOOL)identifyTourWayInputContent:(NSString *)str;
- (BOOL)identifyTourWayName:(NSString *)str;
- (BOOL)identifyTourWayPassword:(NSString *)str;
- (BOOL)valiMobile:(NSString *)mobile;

- (UIBarButtonItem *)createCustomizedItemWithSEL:(SEL)sel image:(NSString *)imgName;
- (UIBarButtonItem *)createCustomizedItemWithSEL:(SEL)sel image:(NSString *)imgName titleStr:(NSString *)title titleColor:(UIColor *)titleColor;
- (UIBarButtonItem *)createCustomizedItemWithSEL:(SEL)sel image:(NSString *)imgName highlightedImg:(NSString *)imgName2;
- (UIBarButtonItem *)createCustomizedItemWithSEL:(SEL)sel titleStr:(NSString*)title titleColor:(UIColor *)titleColor;
- (UIBarButtonItem *)createTopLeftBack;
- (UIBarButtonItem *)createTopLeftBack:(SEL)sel;
- (void)back;
//- (void)alertMessage:(NSString *)message completion:(void(^)(void))completion;//
- (void)alertMessageWithSelectable:(NSString *)message completion:(void(^)(void))completion cancel:(void(^)(void))cancel;
//- (void)alertMessage:(NSString *)message delayForAutoComplete:(float)delay completion:(void(^)(void))completion;//
//- (void)alertMessage:(NSString *)message completeSelector:(SEL)sel;//
//- (void)alertMessage:(NSString *)message delayForAutoComplete:(float)delay completeSelector:(SEL)sel;//
- (void)decisionMessage:(NSString *)message confirmCompletion:(void(^)(void))completion cancelCompletion:(void(^)(void))completion2;
- (void)decisionMessage:(NSString *)message confirmTitle:(NSString *)title1 confirmCompletion:(void(^)(void))completion cancelTitle:(NSString *)title2 cancelCompletion:(void(^)(void))completion2;
- (void)callPromptMessage:(NSString *)message confirmCompletion:(void(^)(void))completion cancelCompletion:(void(^)(void))completion2;
- (void)decisionMessage:(NSString *)message confirmCompletion:(void(^)(void))completion cancelCompletion:(void(^)(void))completion2 continueCompletion:(void(^)(void))completion3;
- (void)decisionMessage:(NSString *)message confirmTitle:(NSString *)title1 confirmCompletion:(void(^)(void))completion1 cancelTitle:(NSString *)title2 cancelCompletion:(void(^)(void))completion2 continueTitle:(NSString *)title3 continueCompletion:(void(^)(void))completion3;
- (void)decisionMessage:(NSString *)message confirmCompleteSelector:(SEL)sel cancelCompleteSelector:(SEL)sel2;
- (void)alertMessage:(NSString *)message delayFordisimissComplete:(float)delay;
- (void)alertMessage:(NSString *)message delayFordisimissComplete:(float)delay Completion:(void(^)(void))completion;
- (void)emptyShowWithBoolIsDataAvailabel:(BOOL)isDataAvailable andMessage:(NSString *)message  andInteraction:(BOOL)Ture;
- (void)startLoading;
- (void)stopLoading;

- (void)netWorkFailureAlter;
- (void)netWorkMonitoring;
- (id)getObjectFromDict:(NSDictionary *)dict withKey:(NSString *)key;
- (BOOL)isDictionaryAvailable:(NSDictionary *)dict withKey:(NSString *)key;

/**
 判断输入字符串字节数
 */
- (int)stringLengthWithTextStr:(NSString *)str;
- (NSString *)createQRCodeContenWithDictionary:(NSDictionary *)dic;
- (NSDictionary *)decodeQRCodeContenWithText:(NSString *)text;

@end














