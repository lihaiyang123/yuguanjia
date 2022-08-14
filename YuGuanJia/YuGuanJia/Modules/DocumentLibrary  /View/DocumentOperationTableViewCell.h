//
//  DocumentOperationTableViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentOperationTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView   *bigView;
@property (nonatomic, strong) UILabel  *timeLabel;
@property (nonatomic, strong) UILabel  *messageLabel;
- (void)setUpDict:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
