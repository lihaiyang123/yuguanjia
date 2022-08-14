//
//  EditDetailContractTypeCell.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/4.
//

#import "EditDetailContractTypeCell.h"

@interface EditDetailContractTypeCell ()

@property (nonatomic, strong) UIView *lineView;
@end

@implementation EditDetailContractTypeCell

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return kScale_W(56);
}
-(void)configure {
    [super configure];
    //  self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    self.detailTextLabel.font = UIFontMake(16);
    if (self.rowDescriptor.value) {
        self.detailTextLabel.textColor = UIColorMakeWithHex(@"#333333");
    } else {
        self.detailTextLabel.text = self.rowDescriptor.noValueDisplayText;
        self.detailTextLabel.textColor = UIColorMakeWithHex(@"#CCCCCC");
    }
    
    NSString *titleString = self.rowDescriptor.title;
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",titleString]];
    NSRange range0 = [[hintString string]rangeOfString:@"*"];
    NSRange range1 = [[hintString string]rangeOfString:titleString];

    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#F42481") range:range0];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#333333") range:range1];

    self.textLabel.attributedText = hintString;
}
-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {
    [self becomeFirstResponder];
    [super formDescriptorCellDidSelectedWithFormController:controller];
}
#pragma mark - Private Method

-(void)unhighlight {
    [super unhighlight];
    self.detailTextLabel.textColor = UIColorMakeWithHex(@"#333333");
}

-(BOOL)formDescriptorCellBecomeFirstResponder {
    return false;
}
#pragma mark - Setter Getter Methods
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorMakeWithHex(@"#F2F2F2");
    }
    return _lineView;
}
@end
