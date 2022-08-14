//
//  YGJPopupMenuButtonItem.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/27.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YGJPopupMenuButtonItemDelegate <NSObject>

@optional
- (void)didSelectRowAtIndex:(NSUInteger)index isProcess:(BOOL)isProcess;

- (void)didSelectRowAtIndex:(NSUInteger)index withTitle:(NSString *)title;
@end

@interface YGJPopupMenuButtonItem : QMUIPopupMenuButtonItem

@property (nonatomic, assign) BOOL isProcess; // 是否是流程
+ (instancetype)itemTitle:(nullable NSString *)title index:(NSUInteger)index delegate:(id<YGJPopupMenuButtonItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
