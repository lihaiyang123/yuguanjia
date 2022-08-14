//
//  YGJToast.m
//  YuGuanJia
//
//  Created by ggzj on 2021/8/6.
//

#import "YGJToast.h"

static YGJToast *instancePrompt;

static CGFloat const delaySeconds = 3.f;

static CGFloat const edgeTop = 80.f;

#define  edgeBottom   (YGJ_IS_IPHONE_X ? kScale_W(205.0) : kScale_W(171.0))

@interface YGJToast ()

@property (nonatomic, strong) QMUIToastContentView *contentView;
//@property (nonatomic, strong) QMUIToastBackgroundView *backgroundView;
/**
 * ToastView距离上下左右的最小间距。
 */
@property (nonatomic, assign) UIEdgeInsets marginInsets UI_APPEARANCE_SELECTOR;

//@property (nonatomic, strong) CALayer *apperanceLayer;

@end

@implementation YGJToast

- (instancetype)initWithText:(NSString *)textString withImageName:(NSString *)imageName  hideAfterDelay:(NSTimeInterval)delay withPosition:(YGJToastPosition)position {
    
    self = [super init];
    if (self) {
        
        [self setDefaultAppearance];
        [self addSubview:self.contentView];
        
        _contentView.textLabelText = textString;
    
        if (imageName.length > 0) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:UIImageMake(imageName)];
            _contentView.customView = imageView;
            //            [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            UIImageView *customView = (UIImageView *)self.contentView.customView;
            //修改bug代码
            customView.image = [customView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        CGFloat limitWidth = SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.marginInsets);
        CGFloat limitHeight = SCREEN_HEIGHT - UIEdgeInsetsGetVerticalValue(self.marginInsets);
        CGSize contentViewSize = [self.contentView sizeThatFits:CGSizeMake(limitWidth, limitHeight)];
        
        if (contentViewSize.width < kScale_W(120.0)) {
            contentViewSize.width = kScale_W(120.0);
        }
        
        CGRect contentRect = CGRectFlatMake(0, 0, contentViewSize.width, contentViewSize.height);
//        CGRect contentRect = CGRectFlatMake(0, 0, contentViewSize.width, limitHeight);

        CGRect frame = CGRectApplyAffineTransform(contentRect, _contentView.transform);
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(frame) + 20.f, CGRectGetHeight(frame) + 10);
        _contentView.frame = CGRectMake(10, 5, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        switch (position) {
            case YGJToastViewPositionTop: {
                
                self.center = CGPointMake(SCREEN_WIDTH/2.f, CGRectGetHeight(self.frame)/2.f + edgeTop);
                break;
            }
                
            case YGJToastViewPositionCenter: {
                
                self.center = CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f);
                break;
            }

            case YGJToastViewPositionBottom: {
                
                self.center = CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT - CGRectGetHeight(self.frame)/2.f - edgeBottom);
                break;
            }

            default:
                break;
        }
        
    }
    return self;
}

#pragma mark - Intial Methods

#pragma mark - Target Methods

#pragma mark - Public Methods

#pragma mark - Private Method
- (void)setDefaultAppearance {
    
    self.marginInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    self.hidden = false;
    self.alpha = 1.0;
    self.windowLevel = UIWindowLevelAlert - 1;

//    self.windowLevel = UIWindowLevelStatusBar + 1.0f;
    //    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 8.0;
//    self.backgroundColor = UIColorMakeWithHex(@"#000000");
    self.backgroundColor = [UIColorMakeWithHex(@"#000000") colorWithAlphaComponent:0.6];
}
- (void)setShadowPathMethod {
    //    self.layer.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.7f].CGColor;//shadowColor阴影颜色
    //    self.layer.shadowOffset = CGSizeMake(-2,2);
    //    self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    //    self.layer.shadowRadius = 3;//阴影半径，默认3
    //
    //    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
    //    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    
//    self.contentCustomView = [[UIImageView alloc] initWithImage:[QMUIHelper imageWithName:@"QMUI_tips_done"]];

}
- (void)setTheImageViewMethodsWith:(NSString *)nameString {
    
}

#pragma mark - Setter Getter Methods
- (QMUIToastContentView *)contentView {
    if (!_contentView) {
        _contentView =  [[QMUIToastContentView alloc] init];
        _contentView.backgroundColor = UIColorClear;
        _contentView.textLabelAttributes = @{NSFontAttributeName:UIFontMake(14.0),NSForegroundColorAttributeName:UIColorMakeWithHex(@"#FFFFFF")};
        _contentView.insets = UIEdgeInsetsMake(kScale_W(8), kScale_W(20), kScale_W(8), kScale_W(20));
//        _contentView.customViewMarginBottom = 18;
    }
    return _contentView;
}
//- (QMUIToastBackgroundView *)backgroundView {
//    if (!_backgroundView) {
//        _backgroundView = [[QMUIToastBackgroundView alloc] init];
//    }
//    return _backgroundView;
//}

// MARK: 类方法
+ (void)settingToastServiceWithText:(NSString *)textString withImageName:(NSString *)nameString
                     hideAfterDelay:(NSTimeInterval)delay withPosition:(YGJToastPosition)position {
    
    instancePrompt.alpha = 0;
    instancePrompt = nil;
    
    instancePrompt = [[YGJToast alloc] initWithText:textString withImageName:nameString hideAfterDelay:delay withPosition:position];
    instancePrompt.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        
        instancePrompt.alpha = 1;
    }];
    [instancePrompt performSelector:@selector(animationHide) withObject:nil afterDelay:delay];
}

+ (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    
    [[self class] settingToastServiceWithText:toast withImageName:@"" hideAfterDelay:delay withPosition:YGJToastViewPositionBottom];
}
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString hideAfterDelay:(NSTimeInterval)delay {
    
    [[self class] settingToastServiceWithText:toast withImageName:nameString hideAfterDelay:delay withPosition:YGJToastViewPositionBottom];
}
+ (void)showToast:(NSString *)toast {
    
    [[self class] settingToastServiceWithText:toast withImageName:@"" hideAfterDelay:delaySeconds withPosition:YGJToastViewPositionBottom];
}

+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString {
    
    [[self class] settingToastServiceWithText:toast withImageName:nameString hideAfterDelay:delaySeconds withPosition:YGJToastViewPositionBottom];
}
- (void)animationHide {
    
    [UIView animateWithDuration:.35 animations:^{
        
        instancePrompt.alpha = 0;
    } completion:^(BOOL finished) {
        
        //        [instancePrompt removeAllSubviews];
        instancePrompt = nil;
    }];
}

//MARK: 自定义显示位置
+ (void)showToast:(NSString *)toast withPosition:(YGJToastPosition)position {
    
    [[self class] settingToastServiceWithText:toast withImageName:@"" hideAfterDelay:delaySeconds withPosition:position];
}
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString withPosition:(YGJToastPosition)position {
    
    [[self class] settingToastServiceWithText:toast withImageName:nameString hideAfterDelay:delaySeconds withPosition:position];
}

+ (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withPosition:(YGJToastPosition)position {
    
    [[self class] settingToastServiceWithText:toast withImageName:@"" hideAfterDelay:delay withPosition:position];
}
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString hideAfterDelay:(NSTimeInterval)delay withPosition:(YGJToastPosition)position {
    
    [[self class] settingToastServiceWithText:toast withImageName:nameString hideAfterDelay:delay withPosition:position];
}
@end
