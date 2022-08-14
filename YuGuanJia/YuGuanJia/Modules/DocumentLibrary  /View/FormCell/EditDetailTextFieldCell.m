//
//  EditDetailTextFieldCell.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/3.
//

#import "EditDetailTextFieldCell.h"

NSString *const EditDetailTextFieldEdit = @"EditDetailTextFieldEdit";

//NSString *const YGJTextFieldContent = @"YGJTextFieldContent";
//NSString *const YGJTextFieldPlacehold = @"YGJTextFieldPlacehold";

@interface EditDetailTextFieldCell ()

@property (nonatomic, strong) UIView *lineView;
@end

@implementation EditDetailTextFieldCell

+(void)load {
    //  [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[ResponseUnitTextCell className] forKey:XLFormRowDescriptorTypeResponseUnitTextField];
    //    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([EditDetailTextFieldCell class]) forKey:EditDetailTextFieldEdit];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    return kScale_W(56);
}

- (void)configure {
    [super configure];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_offset(1.0);
    }];
}
-(void)update {
    [super update];
    self.textField.placeholder = self.rowDescriptor.noValueDisplayText;
    self.textField.textColor = UIColorMakeWithHex(@"#333333");
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.font = UIFontMake(16);
    
    self.textLabel.font = UIFontMake(16);
    
    NSString *titleString = self.rowDescriptor.title;
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",titleString]];
    NSRange range0 = [[hintString string]rangeOfString:@"*"];
    NSRange range1 = [[hintString string]rangeOfString:titleString];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#F42481") range:range0];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#333333") range:range1];

    self.textLabel.attributedText = hintString;
    
//    if ([self.rowDescriptor.tag isEqualToString:kUnderReviewGoodsName]) {
//        self.textField.text = self.rowDescriptor.value;
//    } else {
//
//    }

    
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self unhighlight];
//}

-(void)layoutSubviews{
    [super layoutSubviews];
//    CGRect textLabelFrame = self.textLabel.frame;
//    self.textLabel.frame = CGRectMake(kScale_W(12.5), CGRectGetMinY(textLabelFrame), CGRectGetWidth(textLabelFrame), CGRectGetHeight(textLabelFrame));
}

#pragma mark - Setter Getter Methods
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorMakeWithHex(@"#F2F2F2");
    }
    return _lineView;
}
@end
