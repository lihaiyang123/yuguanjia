//
//  YGJSelectView.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/25.
//

#import "YGJSelectView.h"

@implementation YGJSelectView

- (id)initWithFrame:(CGRect)frame byButtonTitleNameArr:(NSArray *)nameArr {
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat buttonW = kScreenWidth/2.0;
        for (int i = 0; i < nameArr.count; i ++) {
            self.selectItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.selectItemButton.tag = 1000 + i;
            self.selectItemButton.frame = CGRectMake(buttonW*i, 0, buttonW, 55);
            [self.selectItemButton setTitle:nameArr[i] forState:UIControlStateNormal];
            [self.selectItemButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            [self.selectItemButton setTitleColor:[UIColor colorWithHexString:@"#4581EB"] forState:UIControlStateSelected];
            self.selectItemButton.titleLabel.font = FONTSIZEBOLD(18);
            self.selectItemButton.adjustsImageWhenHighlighted = NO;
            self.selectItemButton.adjustsImageWhenDisabled = NO;
            [self.selectItemButton addTarget:self action:@selector(selectItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.selectItemButton];
        }
        
        UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 30 ,3)];
        self.selectView = selectView;
        selectView.backgroundColor = [UIColor colorWithHexString:@"#4581EB"];
        selectView.center = CGPointMake(0, self.height - 3 - selectView.height / 2.0);
        [self addSubview:selectView];
        
        UIView *underLineView = [[UIView alloc] init];
        underLineView.backgroundColor = UNDERLINECOLOR;
        underLineView.frame = CGRectMake(0, 54, kScreenWidth, 1);
        [self addSubview:underLineView];

    }
    return self;
}

- (void)setSelectIndex:(NSUInteger)selectIndex {
    _selectIndex = selectIndex;
    UIButton *btn = [self viewWithTag:selectIndex];
    btn.selected = YES;

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag != selectIndex) {
                btn.selected = NO;
            }
        }
    }
    
    if (_selectView.center.x == 0) {
        _selectView.center = CGPointMake(btn.center.x, self.selectView.center.y);
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.selectView.center = CGPointMake(btn.center.x, self.selectView.center.y);
        }];
    }
}

- (void)selectItemButtonClick:(UIButton *)sender {
//    if (sender.tag == 1001) {
//        [YGJToast showToast:@"功能待开发"];
//        return;
//    }
    if ([self.delegate respondsToSelector:@selector(selectButtonItemClickedIndex:)]) {
        [self.delegate selectButtonItemClickedIndex:sender];
    }
}
@end
