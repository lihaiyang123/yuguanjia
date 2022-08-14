//
//  GoodsDetailBottomView.h
//  YuGuanJia
//
//  Created by Yang on 2021/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GoodsDetailBottomViewDelegate <NSObject>

- (void)pushEditGoodsViewController;
- (void)popGoodsListViewController;

@optional

@end

@interface GoodsDetailBottomView : UIView

@property (nonatomic, assign) YGJGoodsStatus goodsStatus;
@property (nonatomic, copy) NSString *rejectReason;
@property (nonatomic, assign) NSInteger goodsID;

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<GoodsDetailBottomViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
