//
//  SideslipView.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/6.
//

#import "SideslipView.h"

@interface SideslipView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *documentTypetitleArr;
@property (nonatomic, strong) NSArray *documentPropertiesTitleArr;
@property (nonatomic, strong) NSMutableArray *selectedDocumentTypeArray;
@property (nonatomic, strong) NSMutableArray *selectedPropertiesArray;
@property (nonatomic, assign) BOOL isShowBottomButton;

@property (nonatomic, strong) UIView  *bigView;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView  *leftLitteView;
@property (nonatomic, strong) UILabel *docTipsLabel;

@property (nonatomic, strong) UIView  *propertiesLeftLitteView;
@property (nonatomic, strong) UILabel *propertiesDocTipsLabel;

@property(nonatomic, strong) QMUIFloatLayoutView *typeFloatLayoutView;
@property(nonatomic, strong) QMUIFloatLayoutView *propertiesFloatLayoutView;

@property(nonatomic, strong) UIButton *resetButton;
@property(nonatomic, strong) UIButton *sureButton;

@property (nonatomic, copy) NSString *selectedTitle;
@end

@implementation SideslipView


- (id)initWithButtonTDocumentTypeTitleArr:(NSArray *)documentTypetitleArr withDocumentPropertiesTitleArr:(NSArray *)documentPropertiesTitleArr byIsShowBottomButton:(BOOL)isShow {
    self = [super init];
    if (self) {
        self.documentTypetitleArr = documentTypetitleArr;
        self.documentPropertiesTitleArr = documentPropertiesTitleArr;
        self.isShowBottomButton = isShow;
        [self showHUD];
    }
    return self;
}

- (void)showHUD {
    
    self.backgroundColor = [KBlackColor colorWithAlphaComponent:0.5];
    [self addSubview:self.bigView];
    [self.bigView addSubview:self.bigScrollView];
    [self.bigScrollView addSubview:self.leftLitteView];
    [self.bigScrollView addSubview:self.docTipsLabel];
    [self.bigScrollView addSubview:self.typeFloatLayoutView];
    if (self.documentPropertiesTitleArr.count != 0) {
        
        [self.bigScrollView addSubview:self.propertiesLeftLitteView];
        [self.bigScrollView addSubview:self.propertiesDocTipsLabel];
        [self.bigScrollView addSubview:self.propertiesFloatLayoutView];
    }
    if (self.isShowBottomButton) {
        
        self.bigView.frame = CGRectMake(kScale_W(254)+kScreenWidth, 0, kScale_W(254), kScreenHeight);
        self.bigScrollView.frame = CGRectMake(0, 0, kScale_W(254), kScreenHeight-45-28);
        [self.bigView addSubview:self.resetButton];
        [self.bigView addSubview:self.sureButton];
        
    }else {
        self.bigView.frame = CGRectMake(kScale_W(254)+kScreenWidth, 0, kScale_W(254), kScreenHeight);
        self.bigScrollView.frame = CGRectMake(0, 0, kScale_W(254), kScreenHeight);
    }
    
    self.leftLitteView.frame = CGRectMake(kScale_W(12.5), kScale_W(42.5), 3, 20);
    self.docTipsLabel.frame =  CGRectMake(_leftLitteView.right + kScale_W(4.5f), kScale_W(44.5), 100, 15);
    for (NSInteger i = 0; i < self.documentTypetitleArr.count; i++) {
        QMUIGhostButton *button = [[QMUIGhostButton alloc] init];
        button.tag = i + 2000;
//        button.ghostColor = UIColorMakeWithHex(@"#F1F6FF");
        if (i == 0) {
            button.selected = YES;
            button.backgroundColor = CNavBgColor;

        }else {
            button.selected = NO;
            button.backgroundColor = UIColorMakeWithHex(@"#F1F6FF");
        }
        button.borderWidth = 0;
        button.ghostColor = KClearColor;
        [button setTitleColor:CNavBgColor forState:UIControlStateNormal];
        [button setTitleColor:KWhiteColor forState:UIControlStateSelected];
        [button setTitle:self.documentTypetitleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(12);
        button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
        [button addTarget:self action:@selector(docBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.typeFloatLayoutView addSubview:button];
        [self.selectedDocumentTypeArray addObject:button];
    }
    self.typeFloatLayoutView.frame = CGRectMake(kScale_W(12.5), self.docTipsLabel.bottom+18.5f, CGRectGetWidth(self.bigView.bounds)-kScale_W(12.5)*2, QMUIViewSelfSizingHeight);
    
    if (self.documentPropertiesTitleArr.count != 0) {
        
        self.propertiesLeftLitteView.frame = CGRectMake(kScale_W(12.5), _typeFloatLayoutView.bottom+kScale_W(26), 3, 20);
        self.propertiesDocTipsLabel.frame =  CGRectMake(_leftLitteView.right + kScale_W(4.5f), _typeFloatLayoutView.bottom+kScale_W(28), 100, 15);

        for (NSInteger i = 0; i < self.documentPropertiesTitleArr.count; i++) {
            QMUIGhostButton *button = [[QMUIGhostButton alloc] init];
            button.tag = i + 2000;
            if (i == 0) {
                button.selected = YES;
                button.backgroundColor = CNavBgColor;

            }else {
                button.selected = NO;
                button.backgroundColor = UIColorMakeWithHex(@"#F1F6FF");
            }
            button.borderWidth = 0;
            button.ghostColor = KClearColor;
            [button setTitle:self.documentPropertiesTitleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:CNavBgColor forState:UIControlStateNormal];
            [button setTitleColor:KWhiteColor forState:UIControlStateSelected];
            button.titleLabel.font = UIFontMake(12);
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
            [button addTarget:self action:@selector(proBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            [self.propertiesFloatLayoutView addSubview:button];
            [self.selectedPropertiesArray addObject:button];
        }
        _propertiesFloatLayoutView.frame = CGRectMake(kScale_W(12.5), self.propertiesDocTipsLabel.bottom+18.5f, CGRectGetWidth(self.bigView.bounds)-kScale_W(12.5)*2, QMUIViewSelfSizingHeight);

    }
    
    if (self.isShowBottomButton) {
        
        self.resetButton.frame = CGRectMake(11, kScreenHeight-45-28, 85, 45);
        self.sureButton.frame = CGRectMake(_resetButton.right+10, kScreenHeight-45-28, 135, 45);
        _bigScrollView.contentSize = CGSizeMake(kScale_W(254), _propertiesFloatLayoutView.bottom+20);
        
    }else {
        _bigScrollView.contentSize = CGSizeMake(kScale_W(254), _propertiesFloatLayoutView.bottom+20);
    }

}

- (void)showWithTempType:(NSUInteger)tag withTitle:(NSString *)title {
    
    self.docTipsLabel.text = title;
    if (tag >= 0) {
        UIButton *btn = (UIButton *)[self.typeFloatLayoutView viewWithTag:tag + 2000];
        [self selecteButtonByArr:self.selectedDocumentTypeArray byButton:btn];
    }

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bigView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.bigView.alpha = 1;
        self.bigView.frame = CGRectMake(kScreenWidth-kScale_W(254), 0, kScale_W(254), kScreenHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissView
{
    [UIView animateWithDuration:0.2 animations:^{
            self.bigView.alpha = 0;
        self.bigView.frame = CGRectMake(kScreenWidth+kScale_W(254), 0, kScale_W(254), kScreenHeight);

        } completion:^(BOOL finished) {
            [self removeFromSuperview];
    }];
}
- (void)selectButtonEvent:(UIButton *)sender {

    [self dismissView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}

- (UIView *)bigView{

    if (!_bigView) {

        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = KWhiteColor;
        _bigView.layer.masksToBounds = YES;
        _bigView.layer.shadowColor = [UIColor colorWithRed:94/255.0 green:101/255.0 blue:112/255.0 alpha:0.35].CGColor;
        _bigView.layer.shadowOffset = CGSizeMake(0,1);
        _bigView.layer.shadowOpacity = 1;
        _bigView.layer.shadowRadius = 8;
        _bigView.layer.cornerRadius = 15;

    }
    return _bigView;
}

- (UIScrollView *)bigScrollView{
    
    if (!_bigScrollView) {
        
        _bigScrollView = [[UIScrollView alloc] init];
        _bigScrollView.backgroundColor = KWhiteColor;
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.delegate = self;
    }
    return _bigScrollView;
}
- (UIView *)leftLitteView{
    
    if (!_leftLitteView) {
        _leftLitteView = [[UIView alloc] init];
        _leftLitteView.backgroundColor = UIColorMakeWithHex(@"4581EB");
        _leftLitteView.layer.cornerRadius = 1.5f;

    }
    return _leftLitteView;
}

- (UILabel *)docTipsLabel{
    
    if (!_docTipsLabel) {
        
        _docTipsLabel = [[UILabel alloc] init];
        _docTipsLabel.textColor = CBlackgColor;
        _docTipsLabel.font = SYSTEMFONT(16);
        _docTipsLabel.textAlignment = NSTextAlignmentLeft;
        _docTipsLabel.text = @"单据类型";
    }
    return _docTipsLabel;
}

- (UIView *)propertiesLeftLitteView{
    
    if (!_propertiesLeftLitteView) {
        _propertiesLeftLitteView = [[UIView alloc] init];
        _propertiesLeftLitteView.backgroundColor = UIColorMakeWithHex(@"4581EB");
        _propertiesLeftLitteView.layer.cornerRadius = 1.5f;

    }
    return _propertiesLeftLitteView;
}

- (UILabel *)propertiesDocTipsLabel{
    
    if (!_propertiesDocTipsLabel) {
        
        _propertiesDocTipsLabel = [[UILabel alloc] init];
        _propertiesDocTipsLabel.textColor = CBlackgColor;
        _propertiesDocTipsLabel.font = SYSTEMFONT(16);
        _propertiesDocTipsLabel.textAlignment = NSTextAlignmentLeft;
        _propertiesDocTipsLabel.text = @"单据类型";
    }
    return _propertiesDocTipsLabel;
}

- (QMUIFloatLayoutView *)typeFloatLayoutView {
    
    if (!_typeFloatLayoutView) {
        
        _typeFloatLayoutView = [[QMUIFloatLayoutView alloc] init];
        _typeFloatLayoutView.padding = UIEdgeInsetsMake(12, 0, 12, 12);
        _typeFloatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        _typeFloatLayoutView.minimumItemSize = CGSizeMake(kScale_W(69), 28);// 以2个字的按钮作为最小宽度
//        _typeFloatLayoutView.layer.borderWidth = PixelOne;
//        _typeFloatLayoutView.layer.borderColor = UIColorSeparator.CGColor;

    }
    return _typeFloatLayoutView;
    
}

- (QMUIFloatLayoutView *)propertiesFloatLayoutView {
    
    if (!_propertiesFloatLayoutView) {
        
        _propertiesFloatLayoutView = [[QMUIFloatLayoutView alloc] init];
        _propertiesFloatLayoutView.padding = UIEdgeInsetsMake(12, 0, 12, 12);
        _propertiesFloatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        _propertiesFloatLayoutView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
//        _propertiesFloatLayoutView.layer.borderWidth = PixelOne;
//        _propertiesFloatLayoutView.layer.borderColor = UIColorSeparator.CGColor;

    }
    return _propertiesFloatLayoutView;
    
}

- (UIButton *)resetButton {
    
    if (!_resetButton) {
        
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        _resetButton.backgroundColor = KWhiteColor;
        [_resetButton setTitleColor:UIColorMakeWithHex(@"999999") forState:UIControlStateNormal];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _resetButton.layer.cornerRadius = 22;
        _resetButton.layer.borderWidth = 0.5;
        _resetButton.layer.borderColor = UIColorMakeWithHex(@"999999").CGColor;
        [_resetButton addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _resetButton;
}

- (UIButton *)sureButton {
    
    if (!_sureButton) {
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"查看结果" forState:UIControlStateNormal];
        _sureButton.backgroundColor = CNavBgColor;
        [_sureButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _sureButton.layer.cornerRadius = 22;
        [_sureButton addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sureButton;
}



- (NSArray *)documentTypetitleArr {
    
    if (!_documentTypetitleArr) {
        
        _documentTypetitleArr = [NSArray array];
    }
    
    return _documentTypetitleArr;
}

- (NSArray *)documentPropertiesTitleArr {
    
    if (!_documentPropertiesTitleArr) {
        
        _documentPropertiesTitleArr = [NSArray array];
    }
    
    return _documentPropertiesTitleArr;
}

- (NSMutableArray *)selectedDocumentTypeArray {
    
    if (!_selectedDocumentTypeArray) {
        
        _selectedDocumentTypeArray = [NSMutableArray array];
    }
    
    return _selectedDocumentTypeArray;
}

- (NSMutableArray *)selectedPropertiesArray {
    
    if (!_selectedPropertiesArray) {
        
        _selectedPropertiesArray = [NSMutableArray array];
    }
    
    return _selectedPropertiesArray;
}

- (void)resetBtnClick {
    
    [self selecteButtonByArr:self.selectedDocumentTypeArray byButton:nil];
}

- (void)sureBtnClick {
    if (self.selectedTitle.length == 0) {
        
        NSString *text = [NSString stringWithFormat:@"请选择%@", self.docTipsLabel.text];
        [YGJToast showToast:text];
        return;
    }
    
    if (self.sureButtonBlock) {
        self.sureButtonBlock(self.selectedTitle);
    }
    [self dismissView];
}

- (void)docBtnClick:(UIButton *)sender {
    [self selecteButtonByArr:self.selectedDocumentTypeArray byButton:sender];
    
    if (!self.isShowBottomButton) {
        
        if (self.sureButtonBlock) {
            self.sureButtonBlock(self.selectedTitle);
        }
        [self dismissView];
    }
}

- (void)proBtnClick:(UIButton *)sender
{
    [self selecteButtonByArr:self.selectedPropertiesArray byButton:sender];
}

- (void)selecteButtonByArr:(NSMutableArray *)arr byButton:(UIButton *)sender{
    
    self.selectedTitle = sender.titleLabel.text;
    YDZYLog(@"--点击了-->%@",sender.titleLabel.text);
    for (NSInteger j = 0; j < [arr count]; j++) {
        UIButton *btn = arr[j];
        if (!sender) {
            btn.selected = NO;
            btn.backgroundColor = [UIColor colorWithHexString:@"#F1F6FF"];
            continue;
        }
        if (sender.tag - 2000 == j) {
            btn.selected = YES;
            btn.backgroundColor = CNavBgColor;
        } else {
            btn.selected = NO;
            btn.backgroundColor = [UIColor colorWithHexString:@"#F1F6FF"];
        }
    }
}
@end
