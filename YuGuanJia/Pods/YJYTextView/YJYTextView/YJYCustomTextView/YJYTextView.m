//
//  YJYTextView.m
//  YJYBrokerageCloud
//
//  Created by lihaiyang on 2020/04/07.
//  Copyright © 2020 YJY. All rights reserved.
//

#import "YJYTextView.h"
//通知中心
#define LXNotificationCenter [NSNotificationCenter defaultCenter]
@implementation YJYTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self initilize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initilize];
        
    }
    return self;
}

-(void)initilize{
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    // 通知
    // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
    [LXNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    self.placePoint = CGPointMake(5, 0);
    self.tintColor = [UIColor blackColor];
}
- (void)dealloc
{
    [LXNotificationCenter removeObserver:self];
}

/**
 * 监听文字改变
 */
- (void)textDidChange
{
    // 重绘（重新调用）
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}
-(void)setPlacePoint:(CGPoint)placePoint{
    _placePoint = placePoint;
    [self setNeedsDisplay];
}
-(void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
}
- (void)drawRect:(CGRect)rect
{
    //    [HWRandomColor set];
    //    UIRectFill(CGRectMake(20, 20, 30, 30));
    // 如果有输入文字，就直接返回，不画占位文字
    if (self.hasText) return;
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = _placeholderFont ? _placeholderFont : self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    // 画文字
    CGFloat x = self.placePoint.x;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = self.placePoint.y;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}

@end
