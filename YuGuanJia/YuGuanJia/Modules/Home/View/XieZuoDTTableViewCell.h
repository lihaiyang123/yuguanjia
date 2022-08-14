//
//  XieZuoDTTableViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/25.
//

//协作动态
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class CooperationModel;
@interface XieZuoDTTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIView  *leftGreenView;
@property (nonatomic, strong) UILabel *docTitleLabel;
@property (nonatomic, strong) UIView  *underLineView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *seeDetailLabel;

- (void)setUpCooperationModel:(CooperationModel *)model;

@end



NS_ASSUME_NONNULL_END
