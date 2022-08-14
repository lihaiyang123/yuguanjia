//
//  GoodsDetailViewController.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/9.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailViewController : RootViewController

- (instancetype)initWithId:(NSString *)idString;

//预览的时候传一个数据字典
@property (nonatomic, assign) BOOL isPreview;//是否是预览
@property (nonatomic, strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
