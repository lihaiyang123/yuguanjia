//
//  YGJNetworkReachability.h
//  YuGuanJia
//
//  Created by Yang on 2021/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YGJNetworkStatus) {
    
    YGJNetworkStatusNotReachable = 0,
    YGJNetworkStatusUnknown = 1,
    YGJNetworkStatusWWAN2G = 2,
    YGJNetworkStatusWWAN3G = 3,
    YGJNetworkStatusWWAN4G = 4,
    YGJNetworkStatusWiFi = 9,
};

typedef NS_ENUM(NSInteger, YGJNetworkAuthorizationStatus) {
    
    YGJNetworkAuthorizationChecking  = 0,
    YGJNetworkAuthorizationUnknown     ,
    YGJNetworkAuthorizationAccessible  , ///有权限
    YGJNetworkAuthorizationRestricted  , ///无授权
};

typedef void(^YGJNetworkPermissionsStatusHandel)(YGJNetworkAuthorizationStatus status);

FOUNDATION_EXTERN NSString *kNetworkReachabilityChangedNotification;
FOUNDATION_EXTERN NSString *kNetworkReachabilityStatusKey;

@interface YGJNetworkReachability : NSObject

//
+ (instancetype)manager;

/*!
* Use to check the reachability of a given host name.
*/
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
* Use to check the reachability of a given IP address.
*/
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
* Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
*/
+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;

- (void)setReachabilityStatusChangeBlock:(void  (^ _Nullable )(YGJNetworkStatus status))block;

- (YGJNetworkStatus)currentReachabilityStatus;

/**
检测网络数据是否授权
*/
- (void)checkNetworkPermissionsEvent:(void (^)(YGJNetworkAuthorizationStatus status))block;

/**
检测用户是否存在网络代理
     
@return true 是  false 否
 */
-(BOOL)configureProxies;
@end

NS_ASSUME_NONNULL_END
