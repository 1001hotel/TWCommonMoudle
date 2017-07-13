//
//  TextFontFit.m
//  TourWay
//
//  Created by WuTongAlvin on 11/4/15.
//  Copyright © 2015 OneThousandandOneNights. All rights reserved.
//

#import "TextFontFit.h"

#define CURRENT_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@implementation TextFontFit
/**
 *让字体大小(UIFont)以iPhone6Plus的屏幕尺寸(屏幕高度)为基准，按照当前屏幕尺寸进行放缩，例如:[UIFont systemFontOfSize:[TextFontFit fontWithiPhone6PlusFont:20]];
 *而原本的写法是:[UIFont systemFontOfSize:20];
 *注：本方法只能粗略的缩放字体大小，不能保证精确适配.
 */
//+ (CGFloat)fontWithiPhone6PlusFont:(CGFloat)myFont{
//    int font;
//    if (CURRENT_SCREEN_HEIGHT==480) {
//        font=(int)myFont*480/736;
//    }else if (CURRENT_SCREEN_HEIGHT==568){
//        font=(int)myFont*568/736;
//    }else if (SCREEN_HEIGHT==667){
//        font=(int)myFont*677/736;
//    }else if (SCREEN_HEIGHT==736){
//        font=(int)myFont*736/736;
//    }else{
//    
//    }
//    myFont=font*1.0;
//    return myFont;
//}

+ (CGFloat)fontWithiPhone6PlusFont:(CGFloat)myFont{
    
//    int font;
//    if (CURRENT_SCREEN_WIDTH==320) {
//        font=(int)myFont*320/414;
//    }else if (CURRENT_SCREEN_WIDTH==375){
//        font=(int)myFont*375/414;
//    }else if (CURRENT_SCREEN_WIDTH==414){
//        font=(int)myFont*1;
//    }else{
//        
//    }
//    myFont=font*1.0;
    return myFont;
}


@end
