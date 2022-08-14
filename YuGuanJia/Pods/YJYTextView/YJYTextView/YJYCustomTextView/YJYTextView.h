//
//  YJYTextView.h
//  YJYBrokerageCloud
//
//  Created by lihaiyang on 2020/04/07.
//  Copyright © 2020 YJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 占位文字的字体大小 */
@property (strong, nonatomic) UIFont *placeholderFont;

@property(nonatomic,assign)CGPoint placePoint;//占位符的文字位置
@end

