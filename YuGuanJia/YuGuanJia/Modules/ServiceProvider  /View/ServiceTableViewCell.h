//
//  ServiceTableViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceTableViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView  *leftHeadImageView;
@property (nonatomic, strong) UILabel *companyTitleLabel;
@property (nonatomic, strong) UILabel *firStatusLabel;
@property (nonatomic, strong) UILabel *secStatusLabel;
@property (nonatomic, strong) UILabel *isHeZuoLabel;
@property (nonatomic, strong) UIView  *underLineView;



@end

NS_ASSUME_NONNULL_END
