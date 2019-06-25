//
//  TW_UserModel.h
//  TourWay
//
//  Created by luomeng on 15/11/26.
//  Copyright © 2015年 OneThousandandOneNights. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TW_UserModel : NSObject<NSCoding>


@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *loginAccount;//手机号码
@property (nonatomic, strong) NSString *loginPassword;
@property (nonatomic, strong) NSString *userSource;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *profilePhoto;
@property (nonatomic, strong) NSString *bgPhoto;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *integral;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *stateMessage;
@property (nonatomic, strong) NSString *likeNumber;
@property (nonatomic, strong) NSString *followerNumber;
@property (nonatomic, strong) NSString *followingNumber;
@property (nonatomic, strong) NSString *photoWorkNumber;
@property (nonatomic, strong) NSString *photoGalleryNumber;
@property (nonatomic, strong) NSString *activitiesNumber;
@property (nonatomic, strong) NSString *communityNumber;
@property (nonatomic, strong) NSString *commentNumber;
@property (nonatomic, strong) NSString *praiseNumber;
@property (nonatomic, strong) NSString *forwardNumber;
@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, assign) BOOL isExpert;
@property (nonatomic, assign) BOOL isHotel;
@property (nonatomic, strong) NSArray *productions;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) NSArray *circles;
@property (nonatomic, strong) NSArray *worksets;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL isCreateCommunity;
@property (nonatomic, strong) NSString *levelRuleUrl;
@property (nonatomic ,strong) NSString *userEmail;

@property (nonatomic ,strong) NSMutableArray *userThirdAccounts;

@property (nonatomic, strong) NSString*aasWebsite;

@property (nonatomic ,strong) NSString *openId;
@property (nonatomic ,strong) NSString *source;
@property (nonatomic ,strong) NSString *isBd;



@end
