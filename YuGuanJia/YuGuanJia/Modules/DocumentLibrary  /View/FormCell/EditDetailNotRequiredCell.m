//
//  EditDetailNotRequiredCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/6.
//

#import "EditDetailNotRequiredCell.h"

@interface EditDetailNotRequiredCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation EditDetailNotRequiredCell

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return kScale_W(56);
}

-(void)configure {
    [super configure];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_offset(1.0);
    }];
}

-(void)update {
    [super update];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    self.textLabel.textColor = UIColorMakeWithHex(@"#333333");
    self.textLabel.font = UIFontMake(16);

    self.detailTextLabel.textColor = UIColorMakeWithHex(@"#333333");
    self.detailTextLabel.font = UIFontMake(16);
    
    self.textLabel.text = self.rowDescriptor.title;
        
}
-(NSString *)valueDisplayText {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat: @"YYYY-MM-dd"];

    if (self.rowDescriptor.value) {
        NSDate *date = self.rowDescriptor.value;
        return [dateFormatter stringFromDate:date];
    }
    return @"选择时间";
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {
    [self becomeFirstResponder];
    [super formDescriptorCellDidSelectedWithFormController:controller];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
-(BOOL)formDescriptorCellBecomeFirstResponder {
    return true;
}

#pragma mark - Setter Getter Methods
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorMakeWithHex(@"#F2F2F2");
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
