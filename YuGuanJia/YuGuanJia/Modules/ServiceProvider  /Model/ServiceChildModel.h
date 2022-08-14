//
//  ServiceChildModel.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceChildModel : NSObject

@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *serDesc;
@property (nonatomic, copy) NSString *serId;
@property (nonatomic, copy) NSString *serLogo;
@property (nonatomic, copy) NSString *serName;
@property (nonatomic, copy) NSString *serType;
@property (nonatomic, copy) NSString *platCert;//是否通过平台验证
@property (nonatomic, copy) NSString *serCert;//是否通过商户验证
@property (nonatomic, copy) NSString *serID;
@property (nonatomic, copy) NSString *idcardCert;//是否通过法人认证
@property (nonatomic, copy) NSString *coopStatus;//是否合作


@end

NS_ASSUME_NONNULL_END
