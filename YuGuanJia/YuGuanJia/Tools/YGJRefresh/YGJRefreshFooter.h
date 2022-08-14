//
//  YGJRefreshFooter.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/18.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGJRefreshFooter : MJRefreshBackFooter

//设置刷新状态
- (void)settingTheRefreshStatus:(NSInteger)arrayCount;

@end

NS_ASSUME_NONNULL_END
