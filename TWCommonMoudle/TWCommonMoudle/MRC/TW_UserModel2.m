//
//  TW_UserModel2.m
//  TourWay
//
//  Created by luomeng on 2015/12/11.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import "TW_UserModel2.h"
#import <objc/runtime.h>

@implementation TW_UserModel2

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        Class c = self.class;
        // 截取类和父类的成员变量
        while (c && c != [NSObject class]) {
            unsigned int count = 0;
            Ivar *ivars = class_copyIvarList(c, &count);
            for (int i = 0; i < count; i++) {
                
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
                
                if (key.length > 0) {
                    id value = [aDecoder decodeObjectForKey:key];
                    
                    if (value) {
                        [self setValue:value forKey:key];
                    }
                }
            }
            // 获得c的父类
            c = [c superclass];
            free(ivars);
        }
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    Class c = self.class;
    // 截取类和父类的成员变量
    while (c && c != [NSObject class]) {
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList(c, &count);
        
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            if (key.length > 0) {
                id value = [self valueForKey:key];
                if (value) {
                    [aCoder encodeObject:value forKey:key];
                }
            }

        }
        c = [c superclass];
        // 释放内存
        free(ivars);
    }
}


@end
