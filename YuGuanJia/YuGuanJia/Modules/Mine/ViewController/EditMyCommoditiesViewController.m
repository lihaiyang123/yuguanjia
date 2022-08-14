//
//  EditMyCommoditiesViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/5.
//

#import "EditMyCommoditiesViewController.h"
#import "AddMyGoodsViewController.h"
#import "EditMyGoodsViewController.h"
#import "GoodsDetailViewController.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

//views
#import "CommoditiesCollectionViewCell.h"
#import "AddCommoditiesCollectionViewCell.h"

@interface EditMyCommoditiesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;//
@property (nonatomic, strong) UICollectionView *commoditiesCollectionView;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation EditMyCommoditiesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pageNo = 1;
    [self enterpriseServicesListRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.isEdit = YES;
    self.title = self.commoditiesName;
    [self.view addSubview:self.commoditiesCollectionView];
}

// 下拉刷新
- (void)downRefresh:(id)sender {
    self.pageNo = 1;
    [self enterpriseServicesListRequest];
}
// 上提加载
- (void)upRefresh:(id)sender {
    [self enterpriseServicesListRequest];
}

#pragma mark - Network Methods
- (void)enterpriseServicesListRequest {
    
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
        [self.commoditiesCollectionView.mj_footer endRefreshing];
        [self.commoditiesCollectionView.mj_header endRefreshing];
    }];
}
- (void)deleteGoodsRequestByID:(NSString *)idStr {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/delete" parameter:@{@"id":idStr} requestType:UDARequestTypeDelete isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            [self enterpriseServicesListRequest];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(kScale_W(168), kScale_W(197));
}
/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kScale_W(19.5f), kScale_W(12.5f), kScale_W(20), kScale_W(12.5f));
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
    if (indexPath.row == self.dataArr.count) {
        
        AddCommoditiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AddCommoditiesCollectionViewCell className] forIndexPath:indexPath];
        return cell;
    } else {
        
        CommoditiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CommoditiesCollectionViewCell className] forIndexPath:indexPath];
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row][@"goodPic"]]];
        cell.proNameLabel.text = self.dataArr[indexPath.row][@"goodName"];
        //编辑按钮触发
        if (self.isEdit) {
            if (indexPath.row != self.dataArr.count) {
                cell.deleteButton.hidden = NO;
            }else{
                cell.deleteButton.hidden = YES;
            }
        }else{
            cell.deleteButton.hidden = YES;
        }
        @weakify(self);
        cell.deleteBlock = ^{
            
            @strongify(self);
            NSString *idStr = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"id"]];
            [self deleteGoodsRequestByID:idStr];
        };
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.dataArr.count) {
        
        AddMyGoodsViewController *vc = [[AddMyGoodsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
//        NSInteger goodsState = [self.dataArr[indexPath.row][@"state"] integerValue];
        [self.navigationController pushViewController:[[GoodsDetailViewController alloc] initWithId:self.dataArr[indexPath.row][@"id"]] animated:true];
    }
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
        [_commoditiesCollectionView registerClass:[AddCommoditiesCollectionViewCell class] forCellWithReuseIdentifier:[AddCommoditiesCollectionViewCell className]];
        _commoditiesCollectionView.mj_header = [YGJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
        _commoditiesCollectionView.mj_footer = [YGJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
        [_commoditiesCollectionView.mj_header beginRefreshing];

    }
    return _commoditiesCollectionView;
}
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
