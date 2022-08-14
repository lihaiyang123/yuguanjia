//
//  YJYCustomTextView.h
//  YJYBrokerageCloud
//
//  Created by lihaiyang on 2020/04/07.
//  Copyright © 2020 YJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJYCustomTextView;
@class YJYTextView;
@protocol YJYCustomTextViewDelegate <NSObject>

@optional

-(void)customTextViewDidChange:(YJYCustomTextView *)textView;

-(void)customTextViewDidEndEditing:(YJYCustomTextView *)textView;

@end

@interface YJYCustomTextView : UIView
@property(nonatomic,assign)CGFloat v_margin;//竖直方向上下间距 默认为8；
@property(nonatomic,assign)CGFloat h_margin;//水平方向上下间距 默认为0；
@property(nonatomic,assign)NSInteger initiLine;//初始需要展示的行数 默认为1；
@property(nonatomic,assign)NSInteger maxLine;//最大行数 默认为无穷大；
@property (assign, nonatomic) NSInteger maxLength;
@property(nonatomic,strong)NSString *placeholder;//占位文字
@property(assign, nonatomic)NSTextAlignment textAlignment;
@property(nonatomic,strong)UIFont *font;//默认为17
@property(nonatomic,assign)CGPoint placePoint;//设置占位符的位置，竖直方向设置v_margin即可  CGPointMake(5, 0);//占位文字的起始位置；
@property (strong, nonatomic) UIColor *placeholderColor;//占位符颜色
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;//设置textView lineBreakMode
@property (assign, nonatomic) NSInteger maximumNumberOfLines;//设置textView maximumNumberOfLines
@property (strong, nonatomic) UIColor *textViewTintColor;
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) BOOL setTextReturnDelegate;//YES为设置text代理会执行,NO为不执行  默认为YES
@property (weak, nonatomic) id<YJYCustomTextViewDelegate> delegate;
@property(nonatomic,strong)YJYTextView *textView;
@property(nonatomic,copy)void (^textHeightChangeBlock)(CGFloat height);
@end
