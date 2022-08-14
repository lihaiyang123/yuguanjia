//
//  DocStatusCollectionViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/25.
//

#import "DocStatusCollectionViewCell.h"

// mdoels
#import "YGJDocModel.h"

@implementation DocStatusCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
    }
    return self;
}

- (void)showUI {
    [self.contentView addSubview:self.bigView];
    [self.bigView addSubview:self.numberLabel];
    [self.bigView addSubview:self.leftLineView];
    [self.bigView addSubview:self.statusLabel];
    [self.bigView addSubview:self.rightLineView];
    [self.bigView addSubview:self.wuliuLabel];
    [self.bigView addSubview:self.tempTypeLabel];
    
    self.bigView.frame = CGRectMake(0, 0, kScale_W(145), kScale_W(75));
    self.numberLabel.frame = CGRectMake(0, 0, kScale_W(145), 24);
    self.leftLineView.frame = CGRectMake(kScale_W(29), _numberLabel.bottom+21, kScale_W(14), 1);
    self.statusLabel.frame = CGRectMake(_leftLineView.right+5, _numberLabel.bottom+13, kScale_W(55), 16);
    self.rightLineView.frame = CGRectMake(_statusLabel.right+5, _numberLabel.bottom+21, kScale_W(14), 1);
    self.wuliuLabel.frame = CGRectMake(kScale_W(145)-kScale_W(75), 75-14, kScale_W(70), 10);
    self.tempTypeLabel.frame = CGRectMake(kScale_W(5), 75-14, kScale_W(70), 10);
}
- (void)setupDocItemModel:(YGJDocItemModel *)itemModel {
    
    NSArray *tempTypeArray = @[@"进仓单",@"出仓单",@"发货通知单",@"收货通知单", @"委托加工单",@"承揽加工通知单",@"派车通知单",@"委托派车单",@"付款凭证", @"收款凭证"];
    NSArray *statusArr = @[@"待新建", @"待录入", @"待确认", @"待修改", @"待取消", @"待驳回"];
    NSString *statusString = @"";
    if (itemModel.status >= 0 && itemModel.status < [statusArr count]) {
        statusString = statusArr[itemModel.status];
    }
    NSString *tempTypeString = @"";
    if (itemModel.tempType >= 0 && itemModel.tempType < [statusArr count]) {
        tempTypeString = tempTypeArray[itemModel.tempType];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", itemModel.id];
    self.statusLabel.text = statusString;
    self.tempTypeLabel.text = tempTypeString;
    self.wuliuLabel.text = itemModel.name;
}
- (void)setColorDoc {
    
    if ([self.statusLabel.text isEqualToString:@"待新建"] || [self.statusLabel.text isEqualToString:@"待修改"]) {
        [self changeColorByColors:@[UIColorMakeWithHex(@"#FFC000"), UIColorMakeWithHex(@"#FFC000")]];
    } else if ([self.statusLabel.text isEqualToString:@"待确认"] || [self.statusLabel.text isEqualToString:@"待录入"]) {
        [self changeColorByColors:@[UIColorMakeWithHex(@"#4581EB"), UIColorMakeWithHex(@"#45ABEB")]];
    } else {
        [self changeColorByColors:@[UIColorMakeWithHex(@"#9C6CFF"), UIColorMakeWithHex(@"#C1A3FF")]];
    }
}

- (void)changeColorByColors:(NSArray *)colors {
    
    _numberLabel.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:_numberLabel.frame andColors:colors];
    _statusLabel.textColor = _numberLabel.backgroundColor;
    _tempTypeLabel.textColor = _numberLabel.backgroundColor;
    _leftLineView.backgroundColor = _numberLabel.backgroundColor;
    _rightLineView.backgroundColor = _numberLabel.backgroundColor;
    _bigView.layer.borderColor = _numberLabel.backgroundColor.CGColor;
}

- (UIView *)bigView {
    
    if (!_bigView) {
        
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = KWhiteColor;
        _bigView.layer.masksToBounds = YES;
        _bigView.layer.cornerRadius = 6;
        _bigView.layer.borderWidth = 1.5f;
    }
    return _bigView;
}

- (UILabel *)numberLabel {
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = SYSTEMFONT(11);
        _numberLabel.textAlignment = 1;
        _numberLabel.textColor = KWhiteColor;
    }
    return _numberLabel;
}
- (UIView *)leftLineView {
    
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
    }
    return _leftLineView;
}

- (UILabel *)statusLabel {
    
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = FONTSIZEBOLD(15);
        _statusLabel.textAlignment = 1;
    }
    return _statusLabel;
}

- (UIView *)rightLineView {
    
    if (!_rightLineView) {
        
        _rightLineView = [[UIView alloc] init];
    }
    return _rightLineView;
}

- (UILabel *)wuliuLabel {
    
    if (!_wuliuLabel) {
        _wuliuLabel = [[UILabel alloc] init];
        _wuliuLabel.font = SYSTEMFONT(10);
        _wuliuLabel.textAlignment = NSTextAlignmentRight;
        _wuliuLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    }
    return _wuliuLabel;
}

- (UILabel *)tempTypeLabel {
    
    if (!_tempTypeLabel) {
        _tempTypeLabel = [[UILabel alloc] init];
        _tempTypeLabel.font = SYSTEMFONT(10);
        _tempTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tempTypeLabel;
}
@end
