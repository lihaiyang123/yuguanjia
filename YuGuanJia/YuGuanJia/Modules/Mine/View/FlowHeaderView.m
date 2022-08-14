//
//  FlowHeaderView.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/14.
//

#import "FlowHeaderView.h"

@interface FlowHeaderView ()

@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) QMUITextField *nameTextField;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) CDStringBlock stringBlock;
@property (nonatomic, copy) CDBlock editBlock;
@property (nonatomic, strong) QMUIButton *editBtn;
@end

@implementation FlowHeaderView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithEdit:(BOOL)isEdit withName:(NSString *)name withBlock:(CDStringBlock)block withEditBlock:(CDBlock)editBlock {

    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kScale_W(145))]) {
        
        _nameString = name;
        _isEdit = isEdit;
        _stringBlock = block;
        _editBlock = editBlock;
        [self setupView];
    }
    return self;
}
#pragma mark - Intial Methods
- (void)setupView {
    
    self.backgroundColor = UIColorMakeWithHex(@"#F2F4F5");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.nameTextField];

    [self addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).mas_offset(kScale_W(14));
        make.right.equalTo(self).mas_offset(-100);
    }];
    
    [self addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).mas_offset(-14);
        make.width.mas_offset(86);
    }];
}
#pragma mark - Target Methods
- (void)editButtonMethod:(QMUIButton *)btn {
    if (self.editBlock) {
        self.editBlock();
    }
}
#pragma mark - Public Methods

#pragma mark - Private Method
- (void)textFieldChanged:(NSNotification *)noti {
    
    UITextField *tField = (UITextField *)noti.object;
    NSString *trimString = [tField.text qmui_trimAllWhiteSpace];
    if (self.stringBlock) {
        self.stringBlock(trimString);
    }
}

#pragma mark - Setter Getter Methods
- (QMUITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[QMUITextField alloc] initWithFrame:CGRectZero];
        _nameTextField.placeholder = @"请输入流程名字";
        _nameTextField.placeholderColor = UIColorMakeWithHex(@"#B0B3BA");
        _nameTextField.font = UIFontBoldMake(16);
        _nameTextField.textColor = UIColorMakeWithHex(@"#333333");
        // 改变位置
        _nameTextField.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _nameTextField.enabled = self.isEdit;
        _nameTextField.text = self.nameString;
        _nameTextField.maximumTextLength = 9;
    }
    return _nameTextField;
}
- (QMUIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[QMUIButton alloc] qmui_initWithImage:nil title:@"编辑"];
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_editBtn addTarget:self action:@selector(editButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setTitleColor:UIColorMakeWithHex(@"#4581EB") forState:UIControlStateNormal];
//        _editBtn.spacingBetweenImageAndTitle = 6.0;
        _editBtn.titleLabel.font = UIFontBoldMake(16);
//        _editBtn.imagePosition = QMUIButtonImagePositionRight;
        _editBtn.frame = CGRectMake(0, 0, 80, 40);
        _editBtn.hidden = self.isEdit;
    }
    return _editBtn;
}
@end
