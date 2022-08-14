//
//  UDARequestRoute.h
//  uda-mail-ios
//
//  Created by 刘权 on 2019/8/26.
//  Copyright © 2019 YunDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDANetwortConfig.h"

NS_ASSUME_NONNULL_BEGIN


@interface UDARequestRoute : NSObject

/**
 组建URL
 
 @param url 半路径
 @return URL
 */
+ (NSString *)compnentUrl:(NSString *)url;



#pragma mark 默认方法

/**
 获取时时间戳
*/
+ (NSString *)getTimeStamp;


/**
 获取用户ID
*/
+ (NSString *)getUserID;


/**
 获取Token
*/
//+ (NSString *)getToken;


/**
 获取sign
*/
+ (NSString *)getSign;

@end

NS_ASSUME_NONNULL_END
