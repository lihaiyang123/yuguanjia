//
//  EditSelectImageCollectionViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DeleteBlock)(void);
@interface EditSelectImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIImageView *bigImageView;
@property (nonatomic, strong) UIButton *deleteButton;//删除按钮
@property (nonatomic, copy) DeleteBlock deleteBlock;


@end

NS_ASSUME_NONNULL_END
