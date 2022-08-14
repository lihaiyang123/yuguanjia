//
//  RevisionHistoryTableViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RevisionHistoryTableViewCell : UITableViewCell


@property (nonatomic, strong) UIView  *bigView;
@property (nonatomic, strong) UILabel *docTempTypeLabel;
@property (nonatomic, strong) UILabel *serLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *editTimeLabel;

- (void)setDataDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
