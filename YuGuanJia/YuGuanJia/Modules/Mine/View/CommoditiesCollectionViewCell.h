//
//  CommoditiesCollectionViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/5.
//

typedef void(^DeleteBlock)(void);
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommoditiesCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *proNameLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy) DeleteBlock deleteBlock;
@end

NS_ASSUME_NONNULL_END
