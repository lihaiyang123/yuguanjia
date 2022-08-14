//
//  UITextField+Font.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/11.
//

#import "UITextField+Font.h"
#import "YGJFontUtils.h"
#import <objc/runtime.h>

@implementation UITextField (Font)

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
            
            CGFloat fontSize = self.font.pointSize;
            if ([nameArray containsObject:self.font.fontName]) {

                self.font = YGJUIFontBoldMake(fontSize);
            } else if ([self.font.fontName isEqualToString:@".SFUIDisplay-Medium"] ||
                       [self.font.fontName isEqualToString:@".SFUIText-Medium"]) {
                
                self.font = YGJUIFontMediumMake(fontSize);
            } else {
                self.font = YGJUIFontMake(fontSize);
            }
        }
    }
    return self;
}
@end
