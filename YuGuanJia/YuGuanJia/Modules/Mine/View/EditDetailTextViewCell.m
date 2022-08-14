//
//  EditDetailTextViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/4.
//

#import "EditDetailTextViewCell.h"

NSString *const EditDetailTextViewEdit = @"EditDetailTextViewEdit";


@implementation EditDetailTextViewCell

+(void)load {

}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    return kScale_W(67);
}

- (void)configure {
    [super configure];
    
    self.textView.textAlignment = NSTextAlignmentLeft;
}

-(void)update {
    [super update];
    
    self.textView.placeholder = self.rowDescriptor.noValueDisplayText;
    self.textView.textColor = UIColorMakeWithHex(@"#666666");
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = UIFontMake(14);
    self.textLabel.font = UIFontMake(16);
    
    NSString *titleString = self.rowDescriptor.title;

    self.textLabel.text = titleString;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
