//
//  TW_WebPage.h
//  TourWay
//
//  Created by luomeng on 15/12/29.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import "TW_CommonPage.h"

@interface TW_WebPage : TW_CommonPage

@property(nonatomic, copy)NSString *webUrl;
@property(nonatomic, assign)BOOL isAlertModel;


- (void)cleanCacheAndCookie;

@end
