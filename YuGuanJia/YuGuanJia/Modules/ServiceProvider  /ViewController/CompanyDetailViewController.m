//
//  CompanyDetailViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import "CompanyDetailViewController.h"
#import "ServiceDocViewController.h"

#import "UIButton+ClickRange.h"

//views
#import "QiYeCollectionViewCell.h"
#import "UserListCollectionViewCell.h"

//models
#import "YGJSerModel.h"

@interface CompanyDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *topInfoView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UICollectionView *companyCollectionView;
@property (nonatomic, strong) UICollectionView *userListCollectionView;
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *userMutaArray;
@property (nonatomic, strong) NSArray *qiyeFuWuArray;
@property (nonatomic, strong) NSArray *qiyeSPArray;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *companyLabel;

@property (nonatomic, strong) NSMutableArray *authenMutaArray;
@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) UILabel *jianjieLabel;
@property (nonatomic, strong) UIButton *telButton;
@property (nonatomic, strong) YGJSerItemModel *model;

@end

@implementation CompanyDetailViewController

#pragma mark - Life Cycle Methods
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self serviceProviderRequest];
    [self userRequestList];
    [self xuNiGoodsListRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.companyName;
    [self.view addSubview:self.companyCollectionView];
    [self createUI];
}


#pragma mark - Network Methods
- (void)serviceProviderRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/serviceProvider/queryById" parameter:@{@"id":self.serID} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            self.model = [YGJSerItemModel modelWithDictionary:requestModel.result];
            [self refreshUIByModel];
            
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}
//用户列表
- (void)userRequestList {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/users/list" parameter:@{@"pageNo":@"1",@"pageSize":@"50"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            if ([self.userMutaArray count] != 0) {
                [self.userMutaArray removeAllObjects];
            }
            [self.userMutaArray addObjectsFromArray:requestModel.result[@"records"]];
            [self.userListCollectionView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}
//虚拟服务
- (void)xuNiGoodsListRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/list" parameter:@{@"goodAttr":@"0",@"pageNo":@"1",@"pageSize":@"10"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        @strongify(self);
        if (requestModel.success) {
            
            [self.totalArray addObject:requestModel.result[@"records"]];
            [self shiWuGoodsListRequest];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}
//实物
- (void)shiWuGoodsListRequest {
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/list" parameter:@{@"goodAttr":@"1",@"pageNo":@"1",@"pageSize":@"10"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            [self.totalArray addObject:requestModel.result[@"records"]];
            [self.companyCollectionView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

#pragma mark - Intial Methods
- (void)createUI {
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,-(218+65), kScreenWidth, 218+65)];
    headerView.backgroundColor = UIColorMakeWithHex(@"#F2F4F5");
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.topInfoView = [[UIView alloc] init];
    self.topInfoView.frame = CGRectMake(0, 0, kScreenWidth, 218);
    self.topInfoView.backgroundColor = KWhiteColor;
    [headerView addSubview:self.topInfoView];
    
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.frame = CGRectMake(12.5f, 17.5f, 60, 60);
    self.logoImageView.layer.cornerRadius = 30;
    [_topInfoView addSubview:self.logoImageView];
    
    self.companyLabel = [[UILabel alloc] init];
    self.companyLabel.frame = CGRectMake(self.logoImageView.right+10, 22, 300, 15);
    self.companyLabel.textColor = KBlackColor;
    self.companyLabel.font = FONTSIZEBOLD(16);
    [_topInfoView addSubview:self.companyLabel];
    
    
    for (int i = 0; i < 3; i ++) {
        QMUIButton *authenticationButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"renzheng") title:@""];
        authenticationButton.frame = CGRectMake(self.logoImageView.right+10+60*i, 70, 55, 10);
        authenticationButton.hidden = YES;
        authenticationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [authenticationButton setTitleColor:UIColorMakeWithHex(@"#ffffff") forState:UIControlStateNormal];
        authenticationButton.spacingBetweenImageAndTitle = 1.0;
        authenticationButton.titleLabel.font = UIFontMake(10.0);
        authenticationButton.imagePosition = QMUIButtonImagePositionRight;
        [_topInfoView addSubview:authenticationButton];
        [self.authenMutaArray addObject:authenticationButton];
    }

//    self.shanghuLabel = [[UILabel alloc] init];
//    self.shanghuLabel.frame = CGRectMake(self.ptRenZhengImageView.right+10, self.companyLabel.bottom+6.5f, 150, 13);
//    self.shanghuLabel.textColor = [UIColor colorWithHexString:@"999999"];
//    self.shanghuLabel.font = SYSTEMFONT(13);
//    [_topInfoView addSubview:self.shanghuLabel];

    self.telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.telButton.frame = CGRectMake(kScreenWidth-35-13, 26.5f, 35, 35);
    [self.telButton setImage:[UIImage imageNamed:@"tel"] forState:UIControlStateNormal];
    [self.telButton addTarget:self action:@selector(telButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_topInfoView addSubview:self.telButton];
    
    UIImageView *adressImageView = [[UIImageView alloc] init];
    adressImageView.frame = CGRectMake(self.logoImageView.right + 10, self.companyLabel.bottom+26, 10, 11.5f);
    adressImageView.image = [UIImage imageNamed:@"adress_pro"];
    adressImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_topInfoView addSubview:adressImageView];
    
    self.adressLabel = [[UILabel alloc] init];
    self.adressLabel.frame = CGRectMake(adressImageView.right+5, self.companyLabel.bottom+28, 53, 10);
    self.adressLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.adressLabel.font = SYSTEMFONT(10);
    [_topInfoView addSubview:self.adressLabel];

    self.jianjieLabel = [[UILabel alloc] init];
    self.jianjieLabel.frame = CGRectMake(15, self.logoImageView.bottom+24, kScreenWidth-30, 30);
    self.jianjieLabel.textColor = [UIColor colorWithHexString:@"CCCCCC"];
    self.jianjieLabel.font = SYSTEMFONT(11);
    self.jianjieLabel.numberOfLines = 0;
    [_topInfoView addSubview:self.jianjieLabel];
    
    [_topInfoView addSubview:self.userListCollectionView];
    self.userListCollectionView.frame = CGRectMake(0, self.jianjieLabel.bottom+23, kScreenWidth, 40);
    
    self.midView = [[UIView alloc] init];
    self.midView.frame = CGRectMake(0, _topInfoView.bottom+10, kScreenWidth, 55);
    self.midView.backgroundColor = KWhiteColor;
    [headerView addSubview:self.midView];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMidViewAction:)];
    [self.midView addGestureRecognizer:tap];

    
    UIImageView *danjuImageView = [[UIImageView alloc] init];
    danjuImageView.frame = CGRectMake(17, 17, 18, 21);
    danjuImageView.image = [UIImage imageNamed:@"danju_pro"];
    danjuImageView.contentMode = UIViewContentModeScaleAspectFit;
    danjuImageView.userInteractionEnabled = YES;
    [self.midView addSubview:danjuImageView];
    
    UILabel *midTipsLabel = [[UILabel alloc] init];
    midTipsLabel.frame = CGRectMake(danjuImageView.right+6, 0, 300, 55);
    midTipsLabel.text = @"与该企业的单据";
    midTipsLabel.textColor = KBlackColor;
    midTipsLabel.font = SYSTEMFONT(15);
    midTipsLabel.userInteractionEnabled = YES;
    [self.midView addSubview:midTipsLabel];

    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(kScreenWidth-20, 20.5f, 6.5, 14);
    [nextButton setBackgroundImage:UIImageMake(@"xiayiji") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setHitEdgeInsets:UIEdgeInsetsMake(-3, -4, -5, -6)];
    [self.midView addSubview:nextButton];
    [self.companyCollectionView addSubview:headerView];
}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.companyCollectionView) {
        return self.totalArray.count;
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.companyCollectionView) {
        NSArray *arr = self.totalArray[section];
        return arr.count;
    }
    return self.userMutaArray.count;
}
/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.companyCollectionView) {
        return CGSizeMake(kScale_W(168), kScale_W(200));
    }
    return CGSizeMake(130, 40);
}

/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (collectionView == self.companyCollectionView) {
        return UIEdgeInsetsMake(kScale_W(19), kScale_W(12), kScale_W(20), kScale_W(12));
    }
//    return UIEdgeInsetsMake(kScale_W(0), kScale_W(0), kScale_W(0), kScale_W(0));
    return UIEdgeInsetsZero;
}
/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kScale_W(10);
}
/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.companyCollectionView) {
        
        QiYeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[QiYeCollectionViewCell className] forIndexPath:indexPath];
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.totalArray[indexPath.section][indexPath.row][@"goodPic"]]];
        cell.nameLabel.text = self.totalArray[indexPath.section][indexPath.row][@"goodName"];
        return cell;
    } else {
        
        UserListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UserListCollectionViewCell className] forIndexPath:indexPath];
        [cell setDataDict:self.userMutaArray[indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    if (collectionView == self.companyCollectionView) {
        return CGSizeMake(kScreenWidth, 60);
    }
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
        
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && collectionView == self.companyCollectionView) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];

        UIView *headView = [[UIView alloc] init];
        headView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        headView.backgroundColor = KWhiteColor;
        
        UIView *topGrayView = [[UIView alloc] init];
        topGrayView.frame = CGRectMake(0, 0, kScreenWidth, 10);
        topGrayView.backgroundColor = UNDERLINECOLOR;
        [headView addSubview:topGrayView];

        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = [UIColor colorWithHexString:@"#4581EB"];
        leftView.layer.cornerRadius = 1.5f;
        leftView.frame = CGRectMake(12.5f, topGrayView.bottom+17.5f, 3, 17);
        [headView addSubview:leftView];
        
        UILabel *midTipsLabel = [[UILabel alloc] init];
        midTipsLabel.frame = CGRectMake(leftView.right+6, 10, 200, 50);
        
        if (indexPath.section == 0) {
            midTipsLabel.text = @"企业服务";
        } else {
            midTipsLabel.text = @"企业商品";
        }
        midTipsLabel.textColor = KBlackColor;
        midTipsLabel.font = SYSTEMFONT(15);
        [headView addSubview:midTipsLabel];

        UIView *underLineView = [[UIView alloc] init];
        underLineView.frame = CGRectMake(0, 59, kScreenWidth, 5);
        underLineView.backgroundColor = UNDERLINECOLOR;
        [headView addSubview:underLineView];
        
        [header addSubview:headView];
        return header;
    }
    return nil;
}
#pragma mark - Private Method
- (void)refreshUIByModel {
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.model.serLogo]];
    self.companyLabel.text = self.model.serName;
    if ([NSString isBlankString:self.model.serPhone]) {
        self.telButton.hidden = YES;
    }
    NSMutableArray *certMutaArray = [NSMutableArray array];
    NSMutableArray *certNameMutaArray = [NSMutableArray array];
    if (self.model.serCert == 1) {
        [certMutaArray addObject:[NSString stringWithFormat:@"%ld",self.model.serCert]];
        [certNameMutaArray addObject:@"商户认证"];
    }
    if (self.model.idcardCert == 1) {
        [certMutaArray addObject:[NSString stringWithFormat:@"%ld",self.model.idcardCert]];
        [certNameMutaArray addObject:@"法人认证"];
    }
    if (self.model.platCert == 1) {
        [certMutaArray addObject:[NSString stringWithFormat:@"%ld",self.model.platCert]];
        [certNameMutaArray addObject:@"平台认证"];
    }
    for (int i = 0; i < certMutaArray.count; i ++) {
        QMUIButton *authenticationButton = self.authenMutaArray[i];
        [authenticationButton setTitle:certNameMutaArray[i] forState:UIControlStateNormal];
        authenticationButton.hidden = NO;
    }

//            NSArray *arr = @[@"*商品商户",@"*仓储储加工户",@"*物流商户",@"*个体商户"];
//            if ([self.model.serTypes count] > 0) {
//                if ([self.model.serTypes count] == 1) {
//                    self.shanghuLabel.text = arr[0];
//                } else {
//                    self.shanghuLabel.text = [NSString stringWithFormat:@"%@,%@",arr[0],arr[1]];
//                }
//            }
    self.adressLabel.text = self.model.serAddr;
    self.jianjieLabel.text = self.model.serDesc;
}

#pragma mark - Events
- (void)nextButtonClick {
    
    ServiceDocViewController *vc = [[ServiceDocViewController alloc] init];
    vc.idInteger = self.model.id;
    [self.navigationController pushViewController:vc animated:true];
}
- (void)telButtonClick {
    
 NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.serPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)tapMidViewAction:(UITapGestureRecognizer *)sender {
    ServiceDocViewController *vc = [[ServiceDocViewController alloc] init];
    vc.idInteger = self.model.id;
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark – Getters and Setters
- (UICollectionView *)companyCollectionView {
    
    if (!_companyCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _companyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight) collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _companyCollectionView.backgroundColor =  KWhiteColor;
        layout.minimumInteritemSpacing = 0;
        _companyCollectionView.contentInset = UIEdgeInsetsMake(218+65, 0.0f, 0.0f, 0.0f);
        _companyCollectionView.delegate = self;
        _companyCollectionView.dataSource = self;
        _companyCollectionView.showsHorizontalScrollIndicator = NO;
        _companyCollectionView.showsVerticalScrollIndicator = NO;
        _companyCollectionView.scrollsToTop = NO;
        [_companyCollectionView registerClass:[QiYeCollectionViewCell class] forCellWithReuseIdentifier:[QiYeCollectionViewCell className]];
        [_companyCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    }
    return _companyCollectionView;
}

- (UICollectionView *)userListCollectionView {
    
    if (!_userListCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _userListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _userListCollectionView.backgroundColor =  KWhiteColor;
        layout.minimumInteritemSpacing = 0;
        _userListCollectionView.delegate = self;
        _userListCollectionView.dataSource = self;
        _userListCollectionView.showsHorizontalScrollIndicator = NO;
        _userListCollectionView.showsVerticalScrollIndicator = NO;
        _userListCollectionView.scrollsToTop = NO;
        [_userListCollectionView registerClass:[UserListCollectionViewCell class] forCellWithReuseIdentifier:[UserListCollectionViewCell className]];
    }
    return _userListCollectionView;
}

- (NSArray *)qiyeFuWuArray {
    
    if (!_qiyeFuWuArray) {
        
        _qiyeFuWuArray = [NSArray array];
    }
    return _qiyeFuWuArray;
}

- (NSArray *)qiyeSPArray {
    
    if (!_qiyeSPArray) {
        
        _qiyeSPArray = [NSArray array];
    }
    return _qiyeSPArray;
}

- (NSMutableArray *)totalArray {
    
    if (!_totalArray) {
        
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}

- (NSMutableArray *)userMutaArray {
    
    if (!_userMutaArray) {
        
        _userMutaArray = [NSMutableArray array];
    }
    return _userMutaArray;
}
@end
