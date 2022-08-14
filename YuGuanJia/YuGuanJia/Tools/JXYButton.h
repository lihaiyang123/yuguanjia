//
//  JXYButton.h
//  JXYView
//
//  Created by BaQi on 2017/10/21.
//  Copyright © 2017年 BaQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXYButton : UIButton

typedef NS_ENUM(NSUInteger, JXYUIButtonImagePosition) {
    JXYUIButtonImagePositionTop,             // imageView在titleLabel上面
    JXYUIButtonImagePositionLeft,            // imageView在titleLabel左边
    JXYUIButtonImagePositionBottom,          // imageView在titleLabel下面
    JXYUIButtonImagePositionRight,           // imageView在titleLabel右边
};



- (void)setImagePosition:(JXYUIButtonImagePosition)postion spacing:(CGFloat)spacing;



- (instancetype)initWithFrame:(CGRect)frame withNomalTitle:(NSString*)title withSelectTilel:(NSString*)selectTitile withFont:(CGFloat)font withImageNomal:(NSString *)imagaName withImageSelected:(NSString*)imageNameSelect;





@end
