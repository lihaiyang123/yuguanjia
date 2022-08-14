//
//  RevisionHistoryTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/29.
//

#import "RevisionHistoryTableViewCell.h"

@implementation RevisionHistoryTableViewCell

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
    [self.bigView addSubview:self.docTempTypeLabel];
    [self.bigView addSubview:self.serLabel];
    [self.bigView addSubview:self.createTimeLabel];
    [self.bigView addSubview:self.editTimeLabel];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(106);
    }];
        
    [self.docTempTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(14);
        make.left.equalTo(self.bigView.mas_left).offset(20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(150);
    }];
    
    [self.serLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(14);
        make.right.equalTo(self.bigView.mas_right).offset(-13);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(200);
    }];

    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.docTempTypeLabel.mas_bottom).offset(15);
        make.left.equalTo(self.bigView.mas_left).offset(20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(300);
    }];
    
    [self.editTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createTimeLabel.mas_bottom).offset(15);
        make.left.equalTo(self.bigView.mas_left).offset(20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(300);
    }];

}
- (void)setDataDic:(NSDictionary *)dic {
    
    NSArray *arr = @[@"进仓单",@"出仓单",@"发货通知单",@"收货通知单", @"委托加工单",@"承揽加工通知单",@"派车通知单",@"委托派车单",@"付款凭证", @"收款凭证"];
    NSInteger tempType = [dic[@"tempType"] integerValue];
    _docTempTypeLabel.text = [NSString stringWithFormat:@"单据性质：%@",arr[tempType]];
    _serLabel.text = [NSString stringWithFormat:@"%@",dic[@"serName"]];
    _createTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",dic[@"createTime"]];
    _editTimeLabel.text = [NSString stringWithFormat:@"修改时间：%@",dic[@"updateTime"]];

}
#pragma mark - 懒加载
- (UIView *)bigView{
    
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = KWhiteColor;
    }
    return _bigView;
}

- (UILabel *)docTempTypeLabel{
    
    if (!_docTempTypeLabel) {
        
        _docTempTypeLabel = [[UILabel alloc] init];
        _docTempTypeLabel.textColor = UIColorMakeWithHex(@"999999");
        _docTempTypeLabel.font = SYSTEMFONT(14);
        _docTempTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _docTempTypeLabel;
}

- (UILabel *)serLabel{
    
    if (!_serLabel) {
        
        _serLabel = [[UILabel alloc] init];
        _serLabel.textColor = UIColorMakeWithHex(@"999999");
        _serLabel.font = SYSTEMFONT(14);
        _serLabel.textAlignment = NSTextAlignmentRight;
    }
    return _serLabel;
}

- (UILabel *)createTimeLabel{
    
    if (!_createTimeLabel) {
        
        _createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel.textColor = KBlackColor;
        _createTimeLabel.font = SYSTEMFONT(16);
        _createTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _createTimeLabel;
}

- (UILabel *)editTimeLabel{
    
    if (!_editTimeLabel) {
        
        _editTimeLabel = [[UILabel alloc] init];
        _editTimeLabel.textColor = KBlackColor;
        _editTimeLabel.font = SYSTEMFONT(16);
        _editTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _editTimeLabel;
}

@end
