//
//  YGJRefreshNormalHeader.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/18.
//

#import "YGJRefreshNormalHeader.h"

@implementation YGJRefreshNormalHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = true;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.stateLabel.text = @"下拉更新";
            break;
        case MJRefreshStatePulling:
            self.stateLabel.text = @"松开更新";
            break;
        case MJRefreshStateRefreshing:
            self.stateLabel.text = @"更新中...";
            break;
        default:
            break;
    }
}
@end
