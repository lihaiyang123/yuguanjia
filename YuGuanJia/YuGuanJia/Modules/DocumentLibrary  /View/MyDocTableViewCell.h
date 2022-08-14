//
//  MyDocTableViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YGJDocItemModel;
@interface MyDocTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView  *bigView;
@property (nonatomic, strong) UILabel *docNumLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *companyLabel;

- (void)setupDocItemModel:(YGJDocItemModel *)itemModel;
@end

NS_ASSUME_NONNULL_END
