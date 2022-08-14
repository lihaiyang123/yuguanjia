//
//  UDANetwortConfig.h
//  uda-mail-ios
//
//  Created by 刘权 on 2019/8/26.
//  Copyright © 2019 YunDa. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking-umbrella.h"

/**
 xxxxx：测试环境域名
 xxxxx：正式环境域名
 */
//正式
//#define URL_ROOT @"http://47.96.178.186"
#define URL_ROOT [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ServiceWebserviceUrl"]
//测试
//#define URL_ROOT @""


#if UDA_RELEASE

#define unionpay_mode @"00"

#elif ADHOC_DEBUG

#define unionpay_mode @"00"

#else

#define unionpay_mode @"01"

#endif

// 请求超时时间
#define Request_Time 30.0f
// 服务器环境标记
#define HostFlag     ([[NSUserDefaults standardUserDefaults]integerForKey:@"HOST"]-100)

#pragma mark--网络请求类型
typedef NS_ENUM(NSInteger , UDARequestType){
    UDARequestTypeGet            = 0,
    UDARequestTypePost           = 1,
    UDARequestTypePut            = 2,
    UDARequestTypeDelete         = 3,
};

#pragma mark--网络请求响应状态
typedef NS_ENUM(NSInteger , UDAResponseState){
    UDAResponseStateFail    = 0,/** 接口请求失败 eg : 0 */
    UDAResponseStateSuccess = 1,/** 接口请求成功 eg : 1 */
};

#pragma mark--服务器环境切换
typedef NS_ENUM(NSInteger , UDAHost) {
    /** 生产 */
    UDAHostRelease = 0,
    /** 内网 */
    UDAHostInternal = 1,
    /** 外网 */
    UDAHostOutside = 2,
};


