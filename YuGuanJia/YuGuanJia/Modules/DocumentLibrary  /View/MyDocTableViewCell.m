//
//  MyDocTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/27.
//

#import "MyDocTableViewCell.h"
// mdoels
#import "YGJDocModel.h"

@implementation MyDocTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self showUIHUD];
    }
    return self;
}
- (void)showUIHUD
{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self.contentView addSubview:self.bigView];
    [self.bigView addSubview:self.docNumLabel];
    [self.bigView addSubview:self.createTimeLabel];
    [self.bigView addSubview:self.endTimeLabel];
    [self.bigView addSubview:self.companyLabel];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(125);
    }];
    
    [self.docNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(14.5f);
        make.left.equalTo(self.bigView.mas_left).offset(12);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(300);
    }];
        
    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.docNumLabel.mas_bottom).offset(15);
        make.left.equalTo(self.bigView.mas_left).offset(12);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(300);
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createTimeLabel.mas_bottom).offset(11.5f);
        make.left.equalTo(self.bigView.mas_left).offset(12);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(300);
    }];

    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endTimeLabel.mas_bottom).offset(24);
        make.right.equalTo(self.bigView.mas_right).offset(-12.5f);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(200);
    }];
}
- (void)setupDocItemModel:(YGJDocItemModel *)itemModel {
    
    self.docNumLabel.text = [NSString stringWithFormat:@"单据编号：%ld", itemModel.id];
    self.createTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",itemModel.createTime];
    if (![NSString isBlankString:itemModel.updateTime]) {
        self.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",itemModel.updateTime];
    } else {
        self.endTimeLabel.text = @"";
    }

    self.companyLabel.text = [NSString stringWithFormat:@"%@", itemModel.serName];
}

#pragma mark - 懒加载
- (UIView *)bigView{
    
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = KWhiteColor;
        _bigView.layer.masksToBounds = YES;
        _bigView.layer.cornerRadius = 5;
    }
    return _bigView;
}

- (UILabel *)docNumLabel{
    
    if (!_docNumLabel) {
        
        _docNumLabel = [[UILabel alloc] init];
        _docNumLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _docNumLabel.font = SYSTEMFONT(13);
        _docNumLabel.textAlignment = NSTextAlignmentLeft;
        _docNumLabel.text = @"单据编号：99992102306";
    }
    return _docNumLabel;
}

- (UILabel *)createTimeLabel{
    
    if (!_createTimeLabel) {
        
        _createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel.textColor = CBlackgColor;
        _createTimeLabel.font = SYSTEMFONT(16);
        _createTimeLabel.textAlignment = NSTextAlignmentLeft;
        _createTimeLabel.text = @"创建时间：2021-4-17 16:02";
    }
    return _createTimeLabel;
}

- (UILabel *)endTimeLabel{
    
    if (!_endTimeLabel) {
        
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.textColor = CBlackgColor;
        _endTimeLabel.font = SYSTEMFONT(16);
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
        _endTimeLabel.text = @"结束时间：2021-4-18 16:02";
    }
    return _endTimeLabel;
}

- (UILabel *)companyLabel{
    
    if (!_companyLabel) {
        
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _companyLabel.font = SYSTEMFONT(13);
        _companyLabel.textAlignment = NSTextAlignmentRight;
        _companyLabel.text = @"上海鞍宝机电科技...";
    }
    return _companyLabel;
}

@end
