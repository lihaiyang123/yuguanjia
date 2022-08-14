//
//  DocumentOperationTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/7.
//

#import "DocumentOperationTableViewCell.h"

@interface DocumentOperationTableViewCell ()

@end

@implementation DocumentOperationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - Intial Methods
- (void)setupView {
    
    [self.contentView addSubview:self.bigView];
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(58);
    }];

    [self.bigView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(9);
        make.left.equalTo(self.bigView.mas_left).offset(6);
        make.height.mas_equalTo(10.5f);
        make.width.mas_equalTo(130);
    }];

    [self.bigView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(9);
        make.left.equalTo(self.bigView.mas_left).offset(6);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(300);
    }];
}
#pragma mark - Events

#pragma mark - Public Methods
- (void)setUpDict:(NSDictionary *)dic {
    self.timeLabel.text = dic[@"createTime"];
    self.messageLabel.text = dic[@"message"];
}
#pragma mark - Private Method

#pragma mark - External Delegate

#pragma mark – Getters and Setters
- (UIView *)bigView{
    
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = KWhiteColor;
    }
    return _bigView;
}

- (UILabel *)messageLabel{
    
    if (!_messageLabel) {
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = CBlackgColor;
        _messageLabel.font = FONTSIZEBOLD(15);
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _messageLabel;
}

- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.font = SYSTEMFONT(11);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _timeLabel;
}
@end
