//
//  SideslipView.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResetButtonBlock)(void);
//typedef void(^SureButtonBlock)(void);

@interface SideslipView : UIView
/**
 documentTypetitleArr   单据类型按钮数组
 documentPropertiesTitleArr  单据属性按钮数组
 isShow    是否展示底部按钮
 */

- (id)initWithButtonTDocumentTypeTitleArr:(NSArray *)documentTypetitleArr withDocumentPropertiesTitleArr:(NSArray *)documentPropertiesTitleArr byIsShowBottomButton:(BOOL)isShow;

@property (nonatomic, copy) ResetButtonBlock resetButtonBlock;
@property (nonatomic, copy) CDStringBlock sureButtonBlock;


- (void)showWithTempType:(NSUInteger)tag withTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
