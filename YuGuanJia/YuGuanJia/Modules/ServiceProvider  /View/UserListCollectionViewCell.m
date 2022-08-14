//
//  UserListCollectionViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/9.
//

#import "UserListCollectionViewCell.h"

@interface UserListCollectionViewCell ()

@property (nonatomic, strong) UIImageView *menImageView;
@property (nonatomic, strong) UILabel *menNameLabel;
@property (nonatomic, strong) UILabel *menZhiWuLabel;

@end

@implementation UserListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
#pragma mark - Intial Methods
- (void)setupView {
    
    [self.contentView addSubview:self.menImageView];
    [self.contentView addSubview:self.menNameLabel];
    [self.contentView addSubview:self.menZhiWuLabel];
    
    self.menImageView.frame = CGRectMake(0, 0, 40, 40);
    self.menNameLabel.frame = CGRectMake(self.menImageView.right+8.5f, 6, 80, 16);
    self.menZhiWuLabel.frame = CGRectMake(self.menImageView.right+6.5f, self.menNameLabel.bottom+7, 50, 10);
}
#pragma mark - Events

#pragma mark - Public Methods
- (void)setDataDict:(NSDictionary *)dic {
    
//    [self.menImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@""]]] placeholderImage:UIImageMake(@"man")];
    self.menNameLabel.text = [NSString stringWithFormat:@"%@",dic[@"realName"]];
    if ([[NSString stringWithFormat:@"%@",dic[@"userType"]] isEqualToString:@"<null>"]) {
        self.menZhiWuLabel.text = @"-";
    } else if ([[NSString stringWithFormat:@"%@",dic[@"userType"]] isEqualToString:@"1"]) {
        self.menZhiWuLabel.text = @"经办";
    } else {
        self.menZhiWuLabel.text = @"管理员";
    }
}

#pragma mark - Private Method

#pragma mark - External Delegate

#pragma mark – Getters and Setters
- (UIImageView *)menImageView {
    
    if (!_menImageView) {
        _menImageView = [[UIImageView alloc] init];
        _menImageView.image = [UIImage imageNamed:@"man"];
        _menImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _menImageView;
}
- (UILabel *)menNameLabel {
    
    if (!_menNameLabel) {
        _menNameLabel = [[UILabel alloc] init];
        _menNameLabel.textColor = KBlackColor;
        _menNameLabel.font = FONTSIZEBOLD(14);
    }
    return _menNameLabel;
}

- (UILabel *)menZhiWuLabel {
    
    if (!_menZhiWuLabel) {
        _menZhiWuLabel =[[UILabel alloc] init];
        _menZhiWuLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _menZhiWuLabel.font = SYSTEMFONT(10);
    }
    return _menZhiWuLabel;
}
@end
