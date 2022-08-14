//
//  FlowHeaderView.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/14.
//

#import <UIKit/UIKit.h>

@interface FlowHeaderView : UIView

- (instancetype)initWithEdit:(BOOL)isEdit withName:(NSString *)name withBlock:(CDStringBlock)block withEditBlock:(CDBlock)editBlock;
@end
