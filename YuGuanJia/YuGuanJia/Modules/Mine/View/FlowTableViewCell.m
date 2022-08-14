//
//  FlowTableViewCell.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/14.
//

#import "FlowTableViewCell.h"

#import "FlowEditViewController.h"

#import "LiuChengButtonView.h"

@interface FlowTableViewCell()

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSMutableArray *valueMutaArray;
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) JXYButton *addButton;
@property (nonatomic, strong) LiuChengButtonView *firstButton;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) LiuChengButtonView *secButton;

@property MASConstraint *leftConstraint;
@end

@implementation FlowTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
#pragma mark - Intial Methods
- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");

    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScale_W(13.0));
        make.width.mas_offset(kScale_W(40));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        self.leftConstraint = make.left.equalTo(self.nameLabel.mas_right).offset(kScale_W(25.0));
        make.width.mas_offset(kScale_W(102));
        make.height.mas_offset(kScale_W(28));
        make.centerY.equalTo(self.contentView);
    }];

    [self.contentView addSubview:self.firstButton];
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLabel.mas_right).offset(kScale_W(25.0));
        make.width.mas_offset(kScale_W(104));
        make.height.mas_offset(kScale_W(32));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.firstButton.mas_right).offset(kScale_W(17.0));
        make.width.mas_offset(kScale_W(16));
        make.height.mas_offset(kScale_W(11));
        make.centerY.equalTo(self.contentView);
    }];

    [self.contentView addSubview:self.secButton];
    [self.secButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.arrowImageView.mas_right).offset(kScale_W(25.0));
        make.width.mas_offset(kScale_W(104));
        make.height.mas_offset(kScale_W(32));
        make.centerY.equalTo(self.contentView);
    }];

    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_offset(1.0);
    }];
}
#pragma mark - Target Methods
- (void)addButtonMethod {
    
    NSArray *titleArr = @[@"管理员",@"经办"];
    YGJAlertView *alertView = [[YGJAlertView alloc] initWithButtonTitleArr:titleArr withTitle:@"请选择" isLogin:NO];
    alertView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [alertView show];
    @weakify(self);
    alertView.selectedButtonBlock = ^(NSString * _Nonnull buttonTitle) {
        
        @strongify(self);
        [self.valueMutaArray addObject:[buttonTitle isEqualToString:@"管理员"] ? @"0" : @"1"];
        [(FlowEditViewController *)self.cd_viewController setupIndexPath:self.indexPath withKey:[[self.dict allKeys] firstObject] withArray:self.valueMutaArray];
        [self.cd_parentTableView reloadRow:self.indexPath.row inSection:self.indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    };
}

- (void)deleteMethod:(NSUInteger)idx {
    
    [self.valueMutaArray removeObjectAtIndex:idx];
    [(FlowEditViewController *)self.cd_viewController setupIndexPath:self.indexPath withKey:[[self.dict allKeys] firstObject] withArray:self.valueMutaArray];
    [self.cd_parentTableView reloadRow:self.indexPath.row inSection:self.indexPath.section withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Public Methods
- (void)setupName:(NSDictionary *)dict withValue:(NSArray *)valueArray withIsEdit:(BOOL)isEdit
    withIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"oooo: %@", [[dict allValues] firstObject]);
    self.indexPath = indexPath;
    self.dict = dict;
    self.isEdit = isEdit;
    self.valueMutaArray = [NSMutableArray arrayWithArray:valueArray];

    self.nameLabel.text = [[dict allValues] firstObject];
    
//    NSArray *arrayM = @[@"管理员", @"经办"];
//    NSLog(@"---: %@", StringFromBOOL(isEdit));

    if ([self.valueMutaArray count] == 0) {
        
        self.addButton.hidden = isEdit ? false : true;
        self.firstButton.hidden = true;
        self.arrowImageView.hidden = true;
        self.secButton.hidden = true;
        
        [self.leftConstraint uninstall];
        [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
            self.leftConstraint = make.left.equalTo(self.nameLabel.mas_right).offset(kScale_W(25.0));
        }];
    } else if ([self.valueMutaArray count] == 1) {
        [self isShowButtonByIsEdit:isEdit];
    } else if ([self.valueMutaArray count] == 2) {
        if ([self.valueMutaArray[1] isEqualToString:self.valueMutaArray[0]]) {
            [YGJToast showToast:@"已存在管理员身份"];
            [self.valueMutaArray removeLastObject];
            [self isShowButtonByIsEdit:isEdit];
            return;
        }
        self.addButton.hidden = true;
        self.firstButton.hidden = false;
        self.arrowImageView.hidden = false;
        self.secButton.hidden = false;
        self.firstButton.isEdit = isEdit;
        self.secButton.isEdit = isEdit;
        self.firstButton.titleLabel.text = [[self.valueMutaArray firstObject]  isEqualToString: @"0"] ? @"管理员" : @"经办";
        self.secButton.titleLabel.text = [[self.valueMutaArray lastObject]  isEqualToString: @"0"] ? @"管理员" : @"经办";
    } else {
        self.addButton.hidden = true;
        self.firstButton.hidden = true;
        self.arrowImageView.hidden = true;
        self.secButton.hidden = true;
    }
}

#pragma mark - Private Method
- (void)isShowButtonByIsEdit:(BOOL)isEdit {
    self.addButton.hidden = isEdit ? false : true;
    self.firstButton.hidden = false;
    self.arrowImageView.hidden = isEdit ? false : true;
    self.secButton.hidden = true;
    [self.leftConstraint uninstall];
    [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
        self.leftConstraint = make.left.equalTo(self.arrowImageView.mas_right).offset(kScale_W(19.0));
    }];
    self.firstButton.isEdit = isEdit;
    self.firstButton.titleLabel.text = [[self.valueMutaArray firstObject]  isEqualToString: @"0"] ? @"管理员" : @"经办";
}
- (UIViewController *)cd_viewController {
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}
- (QMUITableView *)cd_parentTableView {
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[QMUITableView class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

//MARK: -处理cell被点击事件
- (void)cellSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark - Setter Getter Methods
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorMakeWithHex(@"#F2F2F2");
    }
    return _lineView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CBlackgColor;
        _nameLabel.font = SYSTEMFONT(16);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
- (JXYButton *)addButton {
    if (!_addButton) {
        _addButton = [[JXYButton alloc] initWithFrame:CGRectZero withNomalTitle:@"添加" withSelectTilel:@"" withFont:12 withImageNomal:@"liuchengAdd" withImageSelected:@""];
        _addButton.hidden = YES;
        _addButton.titleLabel.textAlignment = 1;
        [_addButton setImagePosition:JXYUIButtonImagePositionRight spacing:5];
        [_addButton setTitleColor:CNavBgColor forState:UIControlStateNormal];
        _addButton.layer.masksToBounds = YES;
        _addButton.layer.cornerRadius = 14;
        _addButton.layer.borderColor = CNavBgColor.CGColor;
        _addButton.layer.borderWidth = 0.5f;
        [_addButton addTarget:self action:@selector(addButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (LiuChengButtonView *)firstButton {
    if (!_firstButton) {
        _firstButton = [[LiuChengButtonView alloc] init];
        _firstButton.hidden = YES;
        _firstButton.tag = 20000;
        @weakify(self);
        _firstButton.deleteButtonBlock = ^{
            @strongify(self);
            [self deleteMethod:0];
        };
    }
    return _firstButton;
}
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.hidden = YES;
        _arrowImageView.image = [UIImage imageNamed:@"jiantou"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}
- (LiuChengButtonView *)secButton {
    if (!_secButton) {
        _secButton = [[LiuChengButtonView alloc] init];
        _secButton.tag = 20001;
        _secButton.hidden = YES;
        @weakify(self);
        _secButton.deleteButtonBlock = ^{
            @strongify(self);
            [self deleteMethod:1];
        };
    }
    return _secButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
