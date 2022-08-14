//
//  PublicTemCollectionViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YGJDocItemModel;

@interface PublicTemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *temImageView;
@property (nonatomic, strong) UILabel *temNameLabel;

- (void)setupDocItemModel:(YGJDocItemModel *)itemModel;
@end

NS_ASSUME_NONNULL_END
