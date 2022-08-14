//
//  EnterpriseGoodsListViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/20.
//

#import "EnterpriseGoodsListViewController.h"
#import "GoodsDetailViewController.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

//views
#import "CommoditiesCollectionViewCell.h"

@interface EnterpriseGoodsListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UICollectionView *commoditiesCollectionView;
@property (nonatomic, strong) QMUIEmptyView *emptyView;
@property (nonatomic, assign) NSUInteger pageNo;
@end

@implementation EnterpriseGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self.view addSubview:self.commoditiesCollectionView];
}

//企业商品
- (void)enterpriseCommoditiesListRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/mylist" parameter:@{@"goodAttr":self.goodAttr,@"pageNo":@(self.pageNo),@"pageSize":@"10"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            if (self.pageNo == 1) [self.dataArr removeAllObjects];
            self.pageNo++;
            self.dataArr = [NSMutableArray arrayWithArray:requestModel.result[@"records"]];
            [self.commoditiesCollectionView reloadData];
            [self.commoditiesCollectionView.mj_footer endRefreshing];
            [self.commoditiesCollectionView.mj_header endRefreshing];
            if ([self.dataArr count] == [requestModel.result[@"total"] integerValue]) [self.commoditiesCollectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [YGJToast showToast:requestModel.message];
            [self.commoditiesCollectionView.mj_footer endRefreshing];
            [self.commoditiesCollectionView.mj_header endRefreshing];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
        @strongify(self);
        [self.commoditiesCollectionView.mj_footer endRefreshing];
        [self.commoditiesCollectionView.mj_header endRefreshing];
    }];
}
// 下拉刷新
- (void)downRefresh:(id)sender {
    self.pageNo = 1;
    [self enterpriseCommoditiesListRequest];
}

// 上提加载
- (void)upRefresh:(id)sender {
    [self enterpriseCommoditiesListRequest];
}
- (void)showHideAnAttempt:(NSArray *)array {
    if ([array count] == 0) {
        [self.commoditiesCollectionView addSubview:self.emptyView];
    } else {
        [_emptyView removeFromSuperview];
    }
}

#pragma mark - UICollectionView Delegate&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self showHideAnAttempt:self.dataArr];
    return self.dataArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScale_W(168), kScale_W(197));
}
/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([self.dataArr count] > 0) {
        return UIEdgeInsetsMake(kScale_W(19.5f), kScale_W(12.5f), kScale_W(20), kScale_W(12.5f));
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kScale_W(9.5f);
}
/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kScale_W(9.5f);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CommoditiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CommoditiesCollectionViewCell className] forIndexPath:indexPath];
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row][@"goodPic"]]];
    cell.proNameLabel.text = self.dataArr[indexPath.row][@"goodName"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.navigationController pushViewController:[[GoodsDetailViewController alloc] initWithId:self.dataArr[indexPath.row][@"id"]] animated:true];
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
        _commoditiesCollectionView.mj_header = [YGJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
        _commoditiesCollectionView.mj_footer = [YGJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
        [_commoditiesCollectionView.mj_header beginRefreshing];
    }
    return _commoditiesCollectionView;
}

- (QMUIEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[QMUIEmptyView alloc] initWithFrame:self.commoditiesCollectionView.bounds];
        [_emptyView setImage:nil];
        [_emptyView setLoadingViewHidden:true];
        [_emptyView setTextLabelText:@"暂无数据"];
        [_emptyView setDetailTextLabelText:@""];
        [_emptyView setActionButtonTitle:@""];
        [_emptyView.actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        _emptyView.textLabelInsets = UIEdgeInsetsMake(kScale_W(-20), 0, 0, 0);
        _emptyView.textLabelTextColor = UIColorMakeWithHex(@"#999999");
        _emptyView.textLabelFont = UIFontMake(13.0);
        _emptyView.verticalOffset = kScale_W(-80.0);
    }
    return _emptyView;
}

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;;
}
@end
