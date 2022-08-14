//
//  InformationTableViewCell.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/1.
//

#import <UIKit/UIKit.h>
#import <YJYTextView/YJYCustomTextView.h>
#import <YJYTextView/YJYTextView.h>
NS_ASSUME_NONNULL_BEGIN

@interface InformationTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView  *headImageView;
@property (nonatomic, strong) UILabel *leftTipsLabel;
@property (nonatomic, strong) YJYCustomTextView *rightInputTF;
//@property (nonatomic, strong) UILabel  *rightTipsLabel;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UILabel  *rightRenZhengLabel;
@property (nonatomic, strong) UIView  *underLineView;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;

@property (copy, nonatomic) void (^textChangeBlock) (NSString *text,NSIndexPath *cellIndexPath);

@property (copy, nonatomic) void (^heightBlock) (CGFloat height,NSIndexPath *cellIndexPath);

@end

NS_ASSUME_NONNULL_END
