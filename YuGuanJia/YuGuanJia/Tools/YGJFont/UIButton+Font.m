//
//  UIButton+Font.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/11.
//

#import "UIButton+Font.h"
#import "YGJFontUtils.h"
#import <objc/runtime.h>

@implementation UIButton (Font)

+ (void)load {
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(fontInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)fontInitWithCoder:(NSCoder *)aDecode {
    
    [self fontInitWithCoder:aDecode];
    if (self) {
        
        if (self.tag != YGJFontTag) {
            
            NSArray *nameArray = @[@"PingFangSC-Semibold",
                                   @".SFUIDisplay-Bold",
                                   @".SFUIDisplay-Semibold",
                                   @".SFUIText-Semibold",
                                   @".SFUIText-Bold"];
            
            CGFloat fontSize = self.titleLabel.font.pointSize;
            if ([nameArray containsObject:self.titleLabel.font.fontName]) {

                self.titleLabel.font = YGJUIFontBoldMake(fontSize);
            } else if ([self.titleLabel.font.fontName isEqualToString:@".SFUIDisplay-Medium"] ||
                       [self.titleLabel.font.fontName isEqualToString:@".SFUIText-Medium"]) {
    
                self.titleLabel.font = YGJUIFontMediumMake(fontSize);
            } else {
 
                self.titleLabel.font = YGJUIFontMake(fontSize);
            }
        }
    }
    return self;
}
@end
