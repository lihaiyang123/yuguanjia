//
//  LiuChengButtonView.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/3.
//

#import "LiuChengButtonView.h"

@implementation LiuChengButtonView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self showUI];
    }
    
    return self;
}


- (void)showUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.deleteButton];
    
    self.titleLabel.frame = CGRectMake(0, 4, 102, 28);
    self.deleteButton.frame = CGRectMake(104-15, 0, 15, 15);
    
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CNavBgColor;
        _titleLabel.font = SYSTEMFONT(12);
        _titleLabel.textAlignment = 1;
        _titleLabel.backgroundColor = [UIColor colorWithHexString:@"#F1F6FF"];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = 14;
        _titleLabel.userInteractionEnabled = YES;
    }
    
    return _titleLabel;
}

- (UIButton *)deleteButton {
    
    if (!_deleteButton) {
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.hidden = YES;
        [_deleteButton setImage:[UIImage imageNamed:@"delete_liucheng"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(delteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteButton;
}

- (void)delteButtonClick {
    
    NSString *superTagStr = [NSString stringWithFormat:@"%ld",(long)self.superview.tag];
    NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)self.tag];

    NSDictionary *dict = @{@"superTag":superTagStr,@"tag":tagStr};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETE_BUTTON" object:nil userInfo:dict];

    if (self.deleteButtonBlock) {
        self.deleteButtonBlock();
    }
    
}

- (void)setIsEdit:(BOOL)isEdit
{
    if (isEdit) {
        _deleteButton.hidden = NO;
    }else {
        _deleteButton.hidden = YES;
    }
}

@end
