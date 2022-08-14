//
//  MineTopView.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/22.
//

#import "MineTopView.h"

#import "YGJPersonMessageVC.h"

#import "UIView+WhenTappedBlocks.h"

@interface MineTopView ()

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) QMUIButton *managerButton;
@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, strong) UILabel *nikeNameLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *introductionLabel;//简介

@property (nonatomic, strong) NSMutableArray *authenMutaArray;

@end

@implementation MineTopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
#pragma mark - Intial Methods
- (void)setupView {
    
    [self addSubview:self.topImageView];
    [self.topImageView addSubview:self.headImageView];
    [self.topImageView addSubview:self.nikeNameLabel];
    [self.topImageView addSubview:self.companyLabel];
    [self.topImageView addSubview:self.managerButton];
    [self.topImageView addSubview:self.introductionLabel];
    [self.topImageView addSubview:self.arrowImgView];
    for (int i = 0; i < 3; i ++) {
        QMUIButton *authenticationButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"renzheng") title:@""];
        authenticationButton.frame = CGRectMake(self.nikeNameLabel.right+7+60*i, 70, 55, 10);
        authenticationButton.hidden = YES;
        authenticationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [authenticationButton setTitleColor:UIColorMakeWithHex(@"#ffffff") forState:UIControlStateNormal];
        authenticationButton.spacingBetweenImageAndTitle = 1.0;
        authenticationButton.titleLabel.font = UIFontMake(10.0);
        authenticationButton.imagePosition = QMUIButtonImagePositionRight;
        [self.topImageView addSubview:authenticationButton];
        [self.authenMutaArray addObject:authenticationButton];
    }

    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    @weakify(self);
    [self.topImageView whenCancelTapped:^{
        
        @strongify(self);
        [self.ygj_viewController.navigationController pushViewController:[YGJPersonMessageVC new] animated:true];
    }];
}
#pragma mark - Events

#pragma mark - Public Methods
- (void)setupDictionary:(NSDictionary *)dict {
    
    [self.headImageView setImageURL:[NSURL URLWithString:dict[@"serLogo"]]];
    self.nikeNameLabel.text = dict[@"realName"];
    self.companyLabel.text = dict[@"fullName"];
    [self.companyLabel sizeToFit];
    self.managerButton.frame = CGRectMake(self.companyLabel.right+5, self.nikeNameLabel.bottom+11, 30, 11.5f);
    if ([dict[@"userType"] integerValue] == 0) {
        //管理者
        [self.managerButton setTitle:@"管理者" forState:UIControlStateNormal];
    } else {
        //经办
        [self.managerButton setTitle:@"经办" forState:UIControlStateNormal];
    }
    NSMutableArray *certMutaArray = [NSMutableArray array];
    NSMutableArray *certNameMutaArray = [NSMutableArray array];
    if ([dict[@"serCert"] integerValue] == 1) {
        [certMutaArray addObject:dict[@"serCert"]];
        [certNameMutaArray addObject:@"商户认证"];
    }
    if ([dict[@"idcardCert"] integerValue] == 1) {
        [certMutaArray addObject:dict[@"idcardCert"]];
        [certNameMutaArray addObject:@"法人认证"];
    }
    if ([dict[@"platCert"] integerValue] == 1) {
        [certMutaArray addObject:dict[@"platCert"]];
        [certNameMutaArray addObject:@"平台认证"];
    }
    for (int i = 0; i < certMutaArray.count; i ++) {
        QMUIButton *authenticationButton = self.authenMutaArray[i];
        [authenticationButton setTitle:certNameMutaArray[i] forState:UIControlStateNormal];
        authenticationButton.hidden = NO;
    }
    
    self.introductionLabel.text = [NSString stringWithFormat:@"简介：%@",dict[@"serDesc"]];
}
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)contentOffset {
    
    CGFloat offsetY = contentOffset.y;
    if (offsetY > 0) {
        self.frame = CGRectMake(0, -offsetY, SCREEN_WIDTH, kTopViewHieght());
        return;
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopViewHieght() - offsetY);
}
#pragma mark - Private Method

#pragma mark - External Delegate

#pragma mark – Getters and Setters
-(UIViewController *)ygj_viewController {
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.clipsToBounds = true;
        _topImageView.userInteractionEnabled = true;
        _topImageView.image = UIImageMake(@"mineTopBG");
    }
    return _topImageView;
}
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 59, 57, 57)];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headImageView.userInteractionEnabled = true;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 57/2.0;
        [_headImageView setBackgroundColor:UIColorMakeWithHex(@"#EEEEEE")];
    }
    return _headImageView;
}
- (UILabel *)nikeNameLabel {
    if (!_nikeNameLabel) {
        _nikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImageView.right+10, 66, 80, 16.5f)];
        _nikeNameLabel.font = UIFontBoldMake(12);
        _nikeNameLabel.textColor = UIColorMakeWithHex(@"#FFFFFF");
    }
    return _nikeNameLabel;
}
- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImageView.right+10, self.nikeNameLabel.bottom+11, 0, 10.5f)];
        _companyLabel.font = UIFontMake(11);
        _companyLabel.textColor = UIColorMakeWithHex(@"#E2ECFF");
    }
    return _companyLabel;
}
- (QMUIButton *)managerButton {
    if (!_managerButton) {
        _managerButton = [[QMUIButton alloc] initWithFrame:CGRectMake(self.companyLabel.right+5, self.nikeNameLabel.bottom+10.5f, 30, 11.5f)];
        [_managerButton setBackgroundImage:UIImageMake(@"manager") forState:UIControlStateNormal];
        _managerButton.titleLabel.font = UIFontMake(7);
        [_managerButton setTitleColor:UIColorMakeWithHex(@"#672000") forState:UIControlStateNormal];
    }
    return _managerButton;
}

- (UILabel *)introductionLabel {
    if (!_introductionLabel) {
        _introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, self.headImageView.bottom+14, SCREEN_WIDTH - 34, 11.5f)];
        _introductionLabel.font = UIFontMake(11);
        _introductionLabel.textColor = UIColorMakeWithHex(@"#C3D7FF");
    }
    return _introductionLabel;
}
- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-22.5f, 78, 6.5f, 14)];
        _arrowImgView.image = UIImageMake(@"xiayiji");
    }
    return _arrowImgView;
}

- (NSMutableArray *)authenMutaArray {
    
    if (!_authenMutaArray) {
        _authenMutaArray = [NSMutableArray array];
    }
    return _authenMutaArray;
}
@end
