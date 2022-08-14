//
//  FlowTableViewCell.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/14.
//

#import "QMUITableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlowTableViewCell : QMUITableViewCell

- (void)setupName:(NSDictionary *)dict withValue:(NSArray *)valueArray withIsEdit:(BOOL)isEdit
    withIndexPath:(NSIndexPath *)indexPath;

- (void)cellSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
