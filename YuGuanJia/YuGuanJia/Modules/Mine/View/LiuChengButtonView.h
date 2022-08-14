//
//  LiuChengButtonView.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/3.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
typedef void(^DeleteButtonBlock)(void);

@interface LiuChengButtonView : UIView


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy)   DeleteButtonBlock deleteButtonBlock;

@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
