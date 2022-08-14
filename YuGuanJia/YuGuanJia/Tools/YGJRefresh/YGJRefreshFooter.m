//
//  YGJRefreshFooter.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/18.
//

#import "YGJRefreshFooter.h"

@interface YGJRefreshFooter ()

@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSMutableDictionary *stateDict;
@property (strong, nonatomic) UILabel *textTipLabel;

@end

@implementation YGJRefreshFooter

#pragma mark - Intial Methods


#pragma mark - Private Method
- (void)prepare {
    [super prepare];
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.textTipLabel];
    [self addSubview:self.loadingView];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    [self.textTipLabel sizeToFit];
    
    CGFloat centerX = self.mj_w * 0.5;
    CGFloat centerY = self.mj_h * 0.5;
    self.textTipLabel.center = CGPointMake(centerX, centerY);
    self.loadingView.center = CGPointMake(centerX - self.textTipLabel.mj_w * 0.5 - 10, centerY);
}
- (void)settingTheRefreshStatus:(NSInteger)arrayCount {
    
    if (arrayCount > 0) {
        self.state = MJRefreshStateIdle;
    } else {
        self.state = MJRefreshStateNoMoreData;
    }
}
- (void)setState:(MJRefreshState)state {
    
    MJRefreshCheckState;
    
    self.textTipLabel.text = self.stateDict[@(state)];
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self.loadingView stopAnimating];
        }
            break;
        case MJRefreshStatePulling:
        {
            [self.loadingView stopAnimating];
        }
            break;
        case MJRefreshStateRefreshing:
        {
            
            [self.loadingView startAnimating];
        }
            break;
        case MJRefreshStateNoMoreData:
        {
            
            [self.loadingView stopAnimating];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Setter Getter Methods
- (NSMutableDictionary *)stateDict {
    if (!_stateDict) {
        _stateDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"上拉加载更多...", @(MJRefreshStateIdle),
                      @"释放加载更多...", @(MJRefreshStatePulling),
                      @"正在加载更多数据...", @(MJRefreshStateRefreshing),
                      @"没有更多啦～", @(MJRefreshStateNoMoreData),nil];
    }
    return _stateDict;
}
- (UIActivityIndicatorView *)loadingView {
    
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.hidesWhenStopped = YES;
        _loadingView.color = [UIColor grayColor];
    }
    return _loadingView;
}

- (UILabel *)textTipLabel {
    if (_textTipLabel == nil) {
        _textTipLabel = [[UILabel alloc] init];
        _textTipLabel.font = UIFontMake(12);
        _textTipLabel.textColor = UIColorMakeWithHex(@"#999999");
        _textTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textTipLabel;
}
@end
