//
//  UDAResponseDataModel.h
//  uda-mail-ios
//
//  Created by 刘权 on 2019/8/26.
//  Copyright © 2019 YunDa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 网络数据模型
@interface UDAResponseDataModel : NSObject

@property (strong, nonatomic)  id data;

@property (assign, nonatomic)  NSInteger  code;

@property (assign, nonatomic)  BOOL success;
@property (strong, nonatomic)  NSString *message;
@property (strong, nonatomic)  NSDictionary *result;
@property (strong, nonatomic)  NSString *timestamp;


@end

NS_ASSUME_NONNULL_END
