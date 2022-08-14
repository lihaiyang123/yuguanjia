//
//  PreviewBottomView.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PreviewBottomViewDelegate <NSObject>

- (void)confirmNewExcelWithProcessID:(NSString *)processID withTeamworkID:(NSString *)teamworkID;
@optional
@end

@interface PreviewBottomView : UIView

- (instancetype)initWithDelegate:(id<PreviewBottomViewDelegate>)delegate;

- (void)setupHiddenTeamworkButtonWithBeingSerId:(NSString *)beingSerId;
@end

NS_ASSUME_NONNULL_END
