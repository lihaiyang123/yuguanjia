//
//  MyProductViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import "MyProductViewController.h"
#import "EditMyCommoditiesViewController.h"
#import "GoodsDetailViewController.h"
#import "EnterpriseGoodsListViewController.h"

//views
#import "CommoditiesCollectionViewCell.h"

@interface MyProductViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *enterpriseServicesArr;//
@property (nonatomic, strong) NSArray *enterpriseCommoditiesArr;//
@property (nonatomic, strong) UICollectionView *commoditiesCollectionView;
@end

@implementation MyProductViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self enterpriseServicesListRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的商品";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self createBar];
    [self.view addSubview:self.commoditiesCollectionView];
}

#pragma mark - Network Methods
- (void)enterpriseServicesListRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/mylist" parameter:@{@"goodAttr":@"0",@"pageNo":@"1",@"pageSize":@"10"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            self.enterpriseServicesArr = requestModel.result[@"records"];
            [self enterpriseCommoditiesListRequest];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

//企业商品
- (void)enterpriseCommoditiesListRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/mylist" parameter:@{@"goodAttr":@"1",@"pageNo":@"1",@"pageSize":@"10"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            self.enterpriseCommoditiesArr = requestModel.result[@"records"];
            
            [self.commoditiesCollectionView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}
#pragma mark - Intial Methods
- (void)createBar {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10.0, 0.0, 64.0, 44.0);
    [rightButton addTarget:self action:@selector(rightButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightButton.titleLabel.font = SYSTEMFONT(16);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 44.0)];
    [view addSubview:rightButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - UICollectionView Delegate&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.enterpriseServicesArr.count;
    }
    return self.enterpriseCommoditiesArr.count;
}
/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScale_W(168), kScale_W(197));
}

/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.enterpriseServicesArr count] > 0 && section == 0) {
        return UIEdgeInsetsMake(kScale_W(19.5f), kScale_W(12.5f), kScale_W(20), kScale_W(12.5f));
    } else if ([self.enterpriseCommoditiesArr count] > 0 && section == 1){
        return UIEdgeInsetsMake(kScale_W(19.5f), kScale_W(12.5f), kScale_W(20), kScale_W(12.5f));
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kScale_W(9.5f);
}
/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kScale_W(9.5f);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CommoditiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CommoditiesCollectionViewCell className] forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.enterpriseServicesArr[indexPath.row][@"goodPic"]]];
        cell.proNameLabel.text = self.enterpriseServicesArr[indexPath.row][@"goodName"];
    }else {
        
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.enterpriseCommoditiesArr[indexPath.row][@"goodPic"]]];
        cell.proNameLabel.text = self.enterpriseCommoditiesArr[indexPath.row][@"goodName"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        [self.navigationController pushViewController:[[GoodsDetailViewController alloc] initWithId:self.enterpriseServicesArr[indexPath.row][@"id"]] animated:true];
    }else {
        
        [self.navigationController pushViewController:[[GoodsDetailViewController alloc] initWithId:self.enterpriseCommoditiesArr[indexPath.row][@"id"]] animated:true];
    }
}
/**
 区尾大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.enterpriseServicesArr count] == 0 && section == 0) {
        return CGSizeMake(kScreenWidth, 100);
    } else if ([self.enterpriseCommoditiesArr count] == 0 && section == 1){
        return CGSizeMake(kScreenWidth, 100);
    }
    return CGSizeZero;
}
/**
 区头大小
 */
-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 50);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        [header removeAllSubviews];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = [UIColor colorWithHexString:@"#4581EB"];
        leftView.layer.cornerRadius = 1.5f;
        leftView.frame = CGRectMake(12.5f,17.5f, 3, 17);
        [header addSubview:leftView];
        
        UILabel *midTipsLabel = [[UILabel alloc] init];
        midTipsLabel.frame = CGRectMake(leftView.right+6, 0, 200, 50);
        if (indexPath.section == 0) {
            midTipsLabel.text = @"企业服务";
        }else {
            midTipsLabel.text = @"企业商品";
        }
        midTipsLabel.textColor = KBlackColor;
        midTipsLabel.font = SYSTEMFONT(15);
        midTipsLabel.userInteractionEnabled = YES;
        [header addSubview:midTipsLabel];

        UIView *underLineView = [[UIView alloc] init];
        underLineView.frame = CGRectMake(0, 49, kScreenWidth, 5);
        underLineView.backgroundColor = UNDERLINECOLOR;
        [header addSubview:underLineView];
        
        UILabel *leftTipsLabel = [[UILabel alloc] init];
        leftTipsLabel.frame = CGRectMake(kScreenWidth-80, 0, 70, 50);
        leftTipsLabel.text = @"查看更多";
        leftTipsLabel.textColor = KBlackColor;
        leftTipsLabel.userInteractionEnabled = YES;
        leftTipsLabel.font = SYSTEMFONT(15);
        [header addSubview:leftTipsLabel];
        if (indexPath.section == 0 && self.enterpriseServicesArr.count == 0) {
            leftTipsLabel.hidden = YES;
        }else if(indexPath.section == 1 && self.enterpriseCommoditiesArr.count == 0) {
            leftTipsLabel.hidden = YES;
        }else {
            leftTipsLabel.hidden = NO;
            UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderViewAction:)];
            [header addGestureRecognizer:tap];
           tap.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.section],@"section", nil];
        }
        return header;

    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MyCollectionViewFooterView" forIndexPath:indexPath];
        [footerView removeAllSubviews];
        QMUIEmptyView *emptyView = [[QMUIEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        [emptyView setImage:nil];
        [emptyView setLoadingViewHidden:true];
        [emptyView setTextLabelText:@"暂无数据"];
        [emptyView setDetailTextLabelText:@""];
        [emptyView setActionButtonTitle:@""];
        [emptyView.actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        emptyView.textLabelInsets = UIEdgeInsetsMake(kScale_W(-20), 0, 0, 0);
        emptyView.textLabelTextColor = UIColorMakeWithHex(@"#333333");
        emptyView.textLabelFont = UIFontMake(13.0);
        emptyView.verticalOffset = kScale_W(10.0);
        [footerView addSubview:emptyView];
        return footerView;
    }
    return nil;
}

#pragma mark - Events
- (void)tapHeaderViewAction:(UITapGestureRecognizer *)sender {
    NSString *sectionStr = [sender.userInfo objectForKey:@"section"];
    EnterpriseGoodsListViewController *vc = [[EnterpriseGoodsListViewController alloc] init];
    if ([sectionStr isEqualToString:@"0"]) {
        vc.titleStr = @"企业服务";
        vc.goodAttr = @"0";
    }else {
        vc.titleStr = @"企业商品";
        vc.goodAttr = @"1";
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rightButtonOnClicked:(UIButton *)sender {
    
    @weakify(self);
    NSArray *titleArr = @[@"企业服务",@"企业商品"];
    YGJAlertView *alertView = [[YGJAlertView alloc] initWithButtonTitleArr:titleArr withTitle:@"选择编辑" isLogin:NO];
    alertView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [alertView show];
    alertView.selectedButtonBlock = ^(NSString * _Nonnull buttonTitle) {
      
        @strongify(self);
        YDZYLog(@"选择了--->>> %@",buttonTitle);
        EditMyCommoditiesViewController *vc = [[EditMyCommoditiesViewController alloc] init];
        vc.commoditiesName = buttonTitle;
        if ([buttonTitle isEqualToString:@"企业服务"]) {
            vc.goodAttr = @"0";
        }else {
            vc.goodAttr = @"1";
        }
        [self.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark – Getters and Setters
- (UICollectionView *)commoditiesCollectionView {
    
    if (!_commoditiesCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _commoditiesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-kStatusBarHeight-44) collectionViewLayout:layout];
        _commoditiesCollectionView.backgroundColor = KWhiteColor;
        _commoditiesCollectionView.delegate = self;
        _commoditiesCollectionView.dataSource = self;
        _commoditiesCollectionView.showsHorizontalScrollIndicator = NO;
        [_commoditiesCollectionView registerClass:[CommoditiesCollectionViewCell class] forCellWithReuseIdentifier:[CommoditiesCollectionViewCell className]];
        [_commoditiesCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
        [_commoditiesCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MyCollectionViewFooterView"];
    }
    return _commoditiesCollectionView;
}

- (NSArray *)enterpriseServicesArr {
    
    if (!_enterpriseServicesArr) {
        _enterpriseServicesArr = [NSArray array];
    }
    return _enterpriseServicesArr;;
}

- (NSArray *)enterpriseCommoditiesArr {
    
    if (!_enterpriseCommoditiesArr) {
        _enterpriseCommoditiesArr = [NSArray array];
    }
    return _enterpriseCommoditiesArr;;
}

@end
