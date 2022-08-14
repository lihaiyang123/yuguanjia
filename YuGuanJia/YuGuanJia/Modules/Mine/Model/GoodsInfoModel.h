//
//  GoodsInfoModel.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsPicsListModel;
@class GoodsVoModel;
@interface GoodsInfoModel : NSObject

@property (nonatomic, strong) GoodsVoModel *goodsVo;
@property (nonatomic, copy)   NSArray <GoodsPicsListModel *> *goodsPicsList;

@end

@interface GoodsPicsListModel : NSObject

@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, assign) NSInteger creater;
@property (nonatomic, assign) NSInteger del;
@property (nonatomic, assign) NSInteger goodId;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger picType;
@property (nonatomic, copy)   NSString *picUrl;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, assign) NSInteger updater;

@end

@interface GoodsVoModel : NSObject

@property (nonatomic, assign) NSInteger goodAttr;
@property (nonatomic, copy)   NSString *goodCount;
@property (nonatomic, assign) NSInteger goodName;
@property (nonatomic, assign) NSInteger goodPara;
@property (nonatomic, copy)   NSString *goodPic;
@property (nonatomic, assign) NSInteger goodPrice;
@property (nonatomic, assign) NSInteger goodType;
@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger industryType;
@property (nonatomic, copy)   NSString *remark;
@property (nonatomic, copy)   NSString *serId;
@property (nonatomic, copy)   NSString *serLogo;
@property (nonatomic, assign) NSInteger *state;

@end

NS_ASSUME_NONNULL_END
