//
//  YGJAlertView.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedArrButtonBlock)(NSMutableArray *buttonTitleArr,NSMutableArray *buttonTagArr);
typedef void(^SelectedButtonBlock)(NSString *buttonTitle);
@interface YGJAlertView : UIView

/**
 titleStr              提示框标题
 titleArr              按钮标题数组
 */
- (id)initWithButtonTitleArr:(NSArray *)titleArr withTitle:(NSString *)titleStr isLogin:(BOOL)isLogin;
@property (nonatomic, copy) SelectedButtonBlock selectedButtonBlock;
@property (nonatomic, copy) SelectedArrButtonBlock selectedArrButtonBlock;

- (void)show;
@end

NS_ASSUME_NONNULL_END
