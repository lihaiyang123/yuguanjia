//
//  EditDetailSeizeASeatCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/4.
//

#import "EditDetailSeizeASeatCell.h"

NSString *const EditDetailSeizeASeatEdit = @"EditDetailSeizeASeatEdit";

@implementation EditDetailSeizeASeatCell

+(void)load {

}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    return kScale_W(48);
}

- (void)configure {
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
}

-(void)update {
    [super update];
    self.textLabel.font = FONTSIZEBOLD(16);
    NSString *titleString = self.rowDescriptor.title;
    if (self.rowDescriptor.required) {
        
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",titleString]];
        NSRange range0 = [[hintString string]rangeOfString:@"*"];
        NSRange range1 = [[hintString string]rangeOfString:titleString];
        
        [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#F42481") range:range0];
        [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#333333") range:range1];
        self.textLabel.attributedText = hintString;
        
    }else {
        
        self.textLabel.text = titleString;

    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
