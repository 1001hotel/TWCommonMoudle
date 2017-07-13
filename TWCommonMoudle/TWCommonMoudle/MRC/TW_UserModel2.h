//
//  TW_UserModel2.h
//  TourWay
//
//  Created by luomeng on 2015/12/11.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TW_UserModel2 : NSObject<NSCoding>

@property (nonatomic, strong) NSString *ausUserid;
@property (nonatomic, strong) NSString *ausGender;
@property (nonatomic, strong) NSString *ausNickname;
@property (nonatomic, strong) NSString *ausProfilephoto;
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, assign) BOOL isCreateCommunity;
@property (nonatomic, strong) NSString *abpBackgroundPicture;
@property (nonatomic, strong) NSString *ausStatemessage;
@property (nonatomic, strong) NSString *ausLoginaccount;
@property (nonatomic, strong) NSString *levelRuleUrl;
@property (nonatomic, assign) long myCommunitiesCount;
@property (nonatomic, assign) long myFansCount;
@property (nonatomic, assign) long myFollowCount;
@property (nonatomic, assign) long photoworksTotal;
@property (nonatomic, assign) int ausLevel;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) BOOL isFriend;





@end













