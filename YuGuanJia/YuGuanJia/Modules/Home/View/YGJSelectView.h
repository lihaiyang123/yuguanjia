//
//  YGJSelectView.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  YGJSelectViewDelegate <NSObject>

- (void)selectButtonItemClickedIndex:(UIButton *)sender;

@end


@interface YGJSelectView : UIView

@property (nonatomic, assign) id<YGJSelectViewDelegate>delegate;

@property (nonatomic, strong) UIButton *selectItemButton;
@property (nonatomic, weak)   UIView *selectView;
@property (nonatomic, assign) NSUInteger selectIndex;

- (id)initWithFrame:(CGRect)frame byButtonTitleNameArr:(NSArray *)nameArr;

@end

NS_ASSUME_NONNULL_END
