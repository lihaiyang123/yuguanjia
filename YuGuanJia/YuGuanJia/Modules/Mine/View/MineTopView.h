//
//  MineTopView.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static inline CGFloat kTopViewHieght() {
    return 155.0;
}

@interface MineTopView : UIView

- (void)setupDictionary:(NSDictionary *)dict;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)contentOffset;
@end

NS_ASSUME_NONNULL_END
