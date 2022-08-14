//
//  YJYCustomTextView.m
//  YJYBrokerageCloud
//
//  Created by lihaiyang on 2020/04/07.
//  Copyright © 2020 YJY. All rights reserved.
//

#import "YJYCustomTextView.h"
#import "YJYTextView.h"
#import "NSString+Ex.h"
@interface YJYCustomTextView()<UITextViewDelegate>
@property (strong, nonatomic) NSString *lastText;
@property (assign, nonatomic) NSRange lastRange;
@end

@implementation YJYCustomTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder: aDecoder];
    if (self) {
        
        [self initilize];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initilize];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initilize];
    }
    return self;
}
//初始化
-(void)initilize{
    self.h_margin  = 0;
    self.v_margin = 10;
    self.initiLine = 1;
    self.maxLine = INT_MAX;
    self.setTextReturnDelegate = YES;
    self.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.textView];

}
-(void)textViewDidChange:(UITextView *)textView{
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxLength){
                NSString *newText = [self.lastText substringToIndex:self.lastText.length - (toBeString.length - self.maxLength)];
                textView.text = [toBeString stringByReplacingCharactersInRange:NSMakeRange(self.lastRange.location, self.lastText.length) withString:newText];
            }
        }
    } else {// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > self.maxLength) {
            NSString *newText   = [self.lastText substringToIndex:self.lastText.length - (toBeString.length - self.maxLength)];
            textView.text = [toBeString stringByReplacingCharactersInRange:NSMakeRange(self.lastRange.location, self.lastText.length) withString:newText];
        }
    }
    _text = textView.text;
    if ([self.delegate respondsToSelector:@selector(customTextViewDidChange:)]) {
        [self.delegate customTextViewDidChange:self];
    }
    //内容高度
    CGFloat contentSizeH = self.textView.contentSize.height;
    //最大高度
    CGFloat maxHeight = ceil(self.font.lineHeight * self.maxLine);
    //初始高度
    CGFloat initiTextViewHeight = ceilf(self.initiLine *self.font.lineHeight);
    if (contentSizeH <= maxHeight) {
        if (contentSizeH <= initiTextViewHeight) {
            [self setTextViewHeight:initiTextViewHeight];
        }else{
            [self setTextViewHeight:contentSizeH];
        }
    }else{
        [self setTextViewHeight:maxHeight];
    }
    CGRect frame = self.frame;
    frame.size.height = self.textView.frame.size.height + 2 * self.v_margin;
    [self setFrame: frame];
    if (self.textHeightChangeBlock) {
        self.textHeightChangeBlock(self.frame.size.height);
    }
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.lastText = text;
    self.lastRange = range;
    return YES ;
}

-(void)setTextViewHeight:(CGFloat)height{
    CGRect frame = self.textView.frame;
    frame.size.height = height;
    [self.textView setFrame:frame];
}

- (void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    self.textView.editable = enabled;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.textView.backgroundColor = backgroundColor;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(customTextViewDidEndEditing:)]) {
        [self.delegate customTextViewDidEndEditing:self];
    }
}

-(void)setMaxLine:(NSInteger)maxLine{
    _maxLine = maxLine;
    if (maxLine == 0) {
        _maxLine = INT_MAX;
    }
}
-(void)setH_margin:(CGFloat)h_margin{
    _h_margin = h_margin;
    [self updateTextViewFrame];
}
-(void)setV_margin:(CGFloat)v_margin{
    _v_margin = v_margin;
    [self updateTextViewFrame];

}
-(void)setInitiLine:(NSInteger)initiLine{
    _initiLine = initiLine;
    [self updateTextViewFrame];

}
-(void)setFont:(UIFont *)font{
    _font = font;
    self.textView.font = font;
    [self setPlaceTextAlignment:_textAlignment];
    [self updateTextViewFrame];
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _textView.placeholderColor = placeholderColor;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.textView.frame;
    frame.size.width = self.frame.size.width - 2 *self.h_margin;
    [self.textView setFrame:frame];
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _textView.placeholder = _placeholder;
    [self setPlaceTextAlignment:_textAlignment];
}
-(void)setText:(NSString *)text{
    if (!text) {
        return;
    }
    _text = text;
    _textView.text = text;
    if (self.setTextReturnDelegate) {
        [self textViewDidChange:_textView];
    }
}
-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    _lineBreakMode = lineBreakMode;
    self.textView.textContainer.lineBreakMode = lineBreakMode;
}
-(void)setMaximumNumberOfLines:(NSInteger)maximumNumberOfLines{
    _maximumNumberOfLines = maximumNumberOfLines;
    self.textView.textContainer.maximumNumberOfLines = maximumNumberOfLines;
}
-(void)setTextViewTintColor:(UIColor *)textViewTintColor{
    _textViewTintColor = textViewTintColor;
    self.textView.tintColor = textViewTintColor;
}

-(void)updateTextViewFrame{
    self.textView.frame =  CGRectMake(self.h_margin, self.v_margin, self.frame.size.width - 2 *self.h_margin, ceilf(self.initiLine *self.font.lineHeight));
    CGRect frame = self.frame;
    frame.size.height = self.v_margin *2 + ceilf(self.initiLine *self.font.lineHeight);
    [self setFrame:frame];
}
-(void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    _textView.textAlignment = textAlignment;
    [self setPlaceTextAlignment:_textAlignment];
}
-(void)setPlacePoint:(CGPoint)placePoint{
    _placePoint = placePoint;
    self.textView.placePoint = placePoint;
    [self setPlaceTextAlignment:_textAlignment];
}
-(void)setPlaceTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    if (textAlignment == NSTextAlignmentLeft) {
        _textView.placePoint = CGPointMake(5, _textView.placePoint.y);
    } else if (textAlignment == NSTextAlignmentCenter) {
        _textView.placePoint = CGPointMake((_textView.frame.size.width - [_textView.placeholder widthWithFont:self.font]) / 2 , _textView.placePoint.y);
    } else if (textAlignment == NSTextAlignmentRight){
        _textView.placePoint = CGPointMake(_textView.frame.size.width - [_textView.placeholder widthWithFont:self.font] - 2, _textView.placePoint.y);
    }
}

-(YJYTextView *)textView{
    if (!_textView) {
        _textView =[[YJYTextView alloc]initWithFrame:CGRectMake(self.h_margin, self.v_margin, self.frame.size.width - 2 *self.h_margin,  self.initiLine *self.font.lineHeight)];
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.delegate = self;
        _textView.textAlignment = self.textAlignment;
        _textView.placeholder = _placeholder && _placeholder.length ? _placeholder : @"请输入";
    }
    return _textView;
}

@end
