//
//  YGJPopupMenuButtonItem.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/27.
//

#import "YGJPopupMenuButtonItem.h"

@interface YGJPopupMenuButtonItem()

@property (nonatomic, weak) id <YGJPopupMenuButtonItemDelegate>delegate;
@property (nonatomic, assign) NSUInteger index;
@end

@implementation YGJPopupMenuButtonItem

+ (instancetype)itemTitle:(nullable NSString *)title index:(NSUInteger)index delegate:(id<YGJPopupMenuButtonItemDelegate>)delegate {
    YGJPopupMenuButtonItem *item = [[YGJPopupMenuButtonItem alloc] init];
    item.image = nil;
    item.title = title;
//    item.handler = handler;
    item.index = index;
    item.delegate = delegate;
    return item;
}

- (void)handleButtonEvent:(id)sender {
   
    [self.menuView hideWithAnimated:true];
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndex:isProcess:)]) {
        [self.delegate didSelectRowAtIndex:self.index isProcess:self.isProcess];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndex:withTitle:)]) {
        [self.delegate didSelectRowAtIndex:self.index withTitle:self.title];
    }
}
@end
