//
//  DocStatusCollectionViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YGJDocItemModel;

@interface DocStatusCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UILabel *statusLabel;//
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UILabel *wuliuLabel;//
@property (nonatomic, strong) UILabel *tempTypeLabel;//

- (void)setupDocItemModel:(YGJDocItemModel *)itemModel;

- (void)setColorDoc;

@end

NS_ASSUME_NONNULL_END
