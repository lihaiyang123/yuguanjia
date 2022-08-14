//
//  YGJSQLiteManager.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YYKit/YYCache.h>

NS_ASSUME_NONNULL_BEGIN

#define YGJSQLITE_MANAGER  [YGJSQLiteManager manager]

@class UserModel;
@interface YGJSQLiteManager : NSObject

@property (nonatomic, strong, readonly) YYCache *cache;

/// 登录后的token
@property (nonatomic, copy, readonly) NSString *token;
/// 登录后把身份信息存到本地
@property (nonatomic, copy, readonly) NSString *identity;

@property (nonatomic, copy, readonly) NSString *cityName;

@property (nonatomic, assign) UIInterfaceOrientationMask makeOrientation;

/// 是否有弹框弹起, false 无, true 有
@property (nonatomic, assign) BOOL isCommonPopup;

+ (instancetype)manager;

/**
 是否登录
 @return true登录、false未登录
*/
- (BOOL)isLogin;

/// 更新用户信息
- (void)updateLoginToken:(NSString *)token;

///清除用户信息
- (void)clearLoginToken;

/// 更新用户身份
- (void)updateLoginIdentity:(NSMutableArray *)identityArr;

/// 清除本地用户身份
- (void)clearLoginIdentity;

/// 更新后台返回的用户身份
- (void)updateLoginRequestIdentity:(NSMutableArray *)requestIdentityArr;

/// 清除后台返回的用户身份
- (void)clearLoginRequestIdentity;

/// 获取用户身份
- (NSMutableArray *)getUserIdentity;

/// 是否需要去认证
- (BOOL)isShouldToAuthentication;

/// 更新用户信息
- (void)updateUserInfoModel:(UserModel *)model;

/// 清除用户信息
- (void)clearUserInfoModel;

/// 获取用户信息
- (UserModel *)getUserInfoModel;

/// 更新我的待办第一条数据的eventId
- (void)updateEventId:(NSInteger)eventId;

/// 清除我的待办第一条数据的eventId
- (void)clearEventId;

/// 获取我的待办第一条数据的eventId
- (NSString *)getEventId;


/// 开始定位
- (void)startUpdatingLocation;
@end

NS_ASSUME_NONNULL_END
