//
//  YGJPersonMessageModel.h
//  YuGuanJia
//
//  Created by 李海洋 on 2022/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGJPersonMessageModel : NSObject
//头像
@property (copy , nonatomic) NSString *serLogo;
//公司名称
@property (copy , nonatomic) NSString *fullName;
//简介
@property (copy , nonatomic) NSString *serDesc;
//商户电话
@property (copy , nonatomic) NSString *serPhone;
//商户身份属性列表
@property (copy , nonatomic) NSArray *serTypes;
//商户认证状态
@property (assign, nonatomic) BOOL serCert;
//法人认证状态
@property (assign, nonatomic) BOOL idcardCert;
//平台认证状态
@property (assign, nonatomic) BOOL platCert;
@end

NS_ASSUME_NONNULL_END
