//
//  UserModel.h
//  YuGuanJia
//
//  Created by Yang on 2021/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property (nonatomic, copy)   NSString *fullName;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy)   NSString *idcardPicx;
@property (nonatomic, assign) NSInteger idcardCert;
@property (nonatomic, copy)   NSString *idcardPicy;
@property (nonatomic, assign) NSInteger idcardno;
@property (nonatomic, assign) NSInteger phone;
@property (nonatomic, assign) NSInteger platCert;
@property (nonatomic, copy)   NSString *realName;
@property (nonatomic, copy)   NSString *serAddr;
@property (nonatomic, assign) NSInteger serCert;
@property (nonatomic, copy)   NSString *serDesc;
@property (nonatomic, copy)   NSString *serLogo;
@property (nonatomic, copy)   NSString *serName;
@property (nonatomic, copy)   NSString *serNo;
@property (nonatomic, copy)   NSString *serPhone;
@property (nonatomic, copy)   NSString *serPic;
@property (nonatomic, copy)   NSArray *serTypes;
@property (nonatomic, assign) NSInteger serId;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, copy)   NSString *username;

@end

NS_ASSUME_NONNULL_END
