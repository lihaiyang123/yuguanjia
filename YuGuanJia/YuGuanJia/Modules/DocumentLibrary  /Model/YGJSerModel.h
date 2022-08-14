//
//  YGJSerModel.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YGJSerItemModel;
@interface YGJSerModel : NSObject

@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, copy)   NSArray<YGJSerItemModel *> *serviceProviderVoList;
@property (nonatomic, assign) BOOL isSearchCount;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger total;

@end

@interface YGJSerItemModel : NSObject

@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, assign) NSInteger creater;
@property (nonatomic, assign) NSInteger del;
@property (nonatomic, copy)   NSString *fullName;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) NSInteger idcardCert;
@property (nonatomic, copy)   NSString *idcardPicx;
@property (nonatomic, copy)   NSString *idcardPicy;
@property (nonatomic, copy)   NSString *idcardno;
@property (nonatomic, assign) NSInteger platCert;
@property (nonatomic, copy)   NSString *serAddr;
@property (nonatomic, assign) NSInteger serCert;
@property (nonatomic, copy)   NSString *serDesc;
@property (nonatomic, copy)   NSString *serLogo;
@property (nonatomic, copy)   NSString *serName;
@property (nonatomic, copy)   NSString *serNo;
@property (nonatomic, copy)   NSString *serPhone;
@property (nonatomic, copy)   NSString *serPic;
@property (nonatomic, copy)   NSArray *serTypes;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, assign) NSInteger updater;
@property (nonatomic, copy)   NSString *username;

@end

NS_ASSUME_NONNULL_END
