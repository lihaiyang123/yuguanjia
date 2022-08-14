//
//  PreviewTopView.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PreviewTopViewDelegate <NSObject>

- (void)leftButtonEventWithTitle:(NSString *)title;

@optional
@end

@interface PreviewTopView : UIView

- (instancetype)initWithDelegate:(id<PreviewTopViewDelegate>)delegate;

- (void)setupLeftButtons:(NSArray *)buttons withMsg:(NSString *)msg;

- (void)setupDeviceOrientation;
@end

NS_ASSUME_NONNULL_END
