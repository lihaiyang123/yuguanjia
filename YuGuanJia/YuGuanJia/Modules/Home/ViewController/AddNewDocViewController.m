//
//  AddNewDocViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/29.
//

#import "AddNewDocViewController.h"
#import "MineDocLibViewController.h"
#import "DocLibViewController.h"
#import "TemplatePreviewViewController.h"

//views
#import "PublicTemCollectionViewCell.h"
//models
#import "YGJDocModel.h"

@interface AddNewDocViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    CGFloat _collectionViewHeight;
    CGFloat _bottomCollectionViewHeight;
}
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UICollectionView *topCollectionView;
@property (nonatomic, strong) NSMutableArray *topCollArray;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *seeMoreView;
@property (nonatomic, strong) NSMutableArray *bottomCollArray;
@property (nonatomic, strong) UICollectionView *bottomCollectionView;

@property (nonatomic, strong) QMUIEmptyView *topEmptyView;
@property (nonatomic, strong) QMUIEmptyView *bottomEmptyView;

@property (nonatomic, strong) JXYButton *diyButton;
@property (nonatomic, strong) JXYButton *zuijinButton;

@property (nonatomic, strong) UIView *seeMoreTopView;
@end

@implementation AddNewDocViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self diyButtonMethod:self.diyButton];
    [self templatesListRequest];
    [self publicTemListRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建单据";
    [self creatTopView];
    [self createBottomUI];
}

#pragma mark - Network Methods
/// 公共模板
- (void)publicTemListRequest {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":@"1", @"pubPri": @"0", @"pageSize": @"10"}];
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/templates/list" parameter:paramDict requestType:UDARequestTypeGet isShowHUD:false progressBlock:^(CGFloat value) {
     } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
             @strongify(self);
             if (requestModel.success) {
             YGJDocModel *model = [YGJDocModel modelWithDictionary:requestModel.result];
             if ([model.records count] > 0) [self.bottomCollArray addObjectsFromArray:model.records];
             if ([model.records count] == 0) {
                 [self.bottomCollectionView addSubview:self.bottomEmptyView];
             } else {
                 [self.bottomEmptyView removeFromSuperview];
             }
             [self.bottomCollectionView reloadData];
         }
     } errorBlock:^(NSError * _Nullable error) {
     }];
}

/// 自定义模板
- (void)templatesListRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/templates/custom/list" parameter:@{@"pageNo":@"1",@"pageSize":@"10"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
                
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            if (self.topCollArray.count != 0) {
                [self.topCollArray removeAllObjects];
            }
            YGJDocModel *model = [YGJDocModel modelWithDictionary:requestModel.result];
            if ([model.records count] > 0) [self.topCollArray addObjectsFromArray:model.records];
            if ([model.records count] == 0) {
                [self.topCollectionView addSubview:self.topEmptyView];
            } else {
                [self.topEmptyView removeFromSuperview];
            }
            [self.topCollectionView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}

/// 最近使用
- (void)mylatelylistRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/documents/mylatelylist" parameter:@{@"pageNo":@"1",@"pageSize":@"10"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
                
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            if (self.topCollArray.count != 0) {
                [self.topCollArray removeAllObjects];
            }
            YGJDocModel *model = [YGJDocModel modelWithDictionary:requestModel.result];
            if ([model.records count] > 0) [self.topCollArray addObjectsFromArray:model.records];
            
            if ([model.records count] == 0) {
                [self.topCollectionView addSubview:self.topEmptyView];
            } else {
                [self.topEmptyView removeFromSuperview];
            }
            [self.topCollectionView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}
#pragma mark - Intial Methods
- (void)creatTopView {
    
    [self.view addSubview:self.bigScrollView];
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    self.topView.backgroundColor = KWhiteColor;
    [_bigScrollView addSubview:self.topView];
    
    self.buttonView = [[UIView alloc] init];
    self.buttonView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    self.buttonView.backgroundColor = KWhiteColor;
    [self.topView addSubview:self.buttonView];
    
    self.diyButton = [[JXYButton alloc] initWithFrame:CGRectMake(53, 28, 60, 72) withNomalTitle:@"自定义" withSelectTilel:@"" withFont:15 withImageNomal:@"custom_normal" withImageSelected:@"custom_seleted"];
    self.diyButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.diyButton setImagePosition:JXYUIButtonImagePositionTop spacing:13];
    [self.diyButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.buttonView addSubview:self.diyButton];
    [self.diyButton addTarget:self action:@selector(diyButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.diyButton.selected = YES;
    
    self.zuijinButton = [[JXYButton alloc] initWithFrame:CGRectMake(self.diyButton.right+70, 28, 80, 72) withNomalTitle:@"最近使用" withSelectTilel:@"" withFont:15 withImageNomal:@"recentlyUsed" withImageSelected:@"recentlyUsed_seleted"];
    self.zuijinButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.zuijinButton setImagePosition:JXYUIButtonImagePositionTop spacing:13];
    [self.zuijinButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.buttonView addSubview:self.zuijinButton];
    [self.zuijinButton addTarget:self action:@selector(zuijinButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.topCollectionView];
    
    self.seeMoreTopView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topCollectionView.bottom, kScreenWidth, 40)];
    self.seeMoreTopView.hidden = YES;
    [self.topView addSubview:self.seeMoreTopView];
    
    JXYButton *seeMoreButton = [[JXYButton alloc] initWithFrame:CGRectMake(kScreenWidth-110, 0, 100, 40) withNomalTitle:@"查看更多" withSelectTilel:@"" withFont:15 withImageNomal:@"seemore" withImageSelected:@""];
    seeMoreButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [seeMoreButton setImagePosition:JXYUIButtonImagePositionRight spacing:4];
    [seeMoreButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.seeMoreTopView addSubview:seeMoreButton];
    [seeMoreButton addTarget:self action:@selector(seeMoreTopButtonMethod:) forControlEvents:UIControlEventTouchUpInside];

    self.topView.frame = CGRectMake(0, 0, kScreenWidth, self.topCollectionView.bottom);

}
- (void)createBottomUI {
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, self.topView.bottom+10, kScreenWidth, 0);
    self.bottomView.backgroundColor = KWhiteColor;
    [_bigScrollView addSubview:self.bottomView];
    
    self.seeMoreView = [[UIView alloc] init];
    self.seeMoreView.frame = CGRectMake(0, 0, kScreenWidth, 55);
    self.seeMoreView.backgroundColor = KWhiteColor;
    [self.bottomView addSubview:self.seeMoreView];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(kScale_W(14.5f),19.5f,3,20);
    leftView.backgroundColor = [UIColor colorWithHexString:@"#4581EB"];
    leftView.layer.cornerRadius = 1.5f;
    [self.seeMoreView addSubview:leftView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftView.right+5, 20.5f, 200, 17.5f)];
    titleLabel.font = FONT(@"PingFang-SC-Heavy", 18);
    titleLabel.textColor = CBlackgColor;
    titleLabel.text = @"使用模板库";
    [self.seeMoreView addSubview:titleLabel];
    
    JXYButton *seeMoreButton = [[JXYButton alloc] initWithFrame:CGRectMake(kScreenWidth-70, 0, 60, 55) withNomalTitle:@"更多" withSelectTilel:@"" withFont:15 withImageNomal:@"seemore" withImageSelected:@""];
    seeMoreButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [seeMoreButton setImagePosition:JXYUIButtonImagePositionRight spacing:4];
    [seeMoreButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.seeMoreView addSubview:seeMoreButton];
    [seeMoreButton addTarget:self action:@selector(seeMoreButtonMethod:) forControlEvents:UIControlEventTouchUpInside];

    [self.bottomView addSubview:self.bottomCollectionView];
    self.bottomView.frame = CGRectMake(0, self.topView.bottom+10, kScreenWidth, _bottomCollectionView.bottom);
    [self setBigScrollViewContentSize];

}

#pragma mark - UICollectionViewDelegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 5000) {
        return self.topCollArray.count;
    }
    return self.bottomCollArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScale_W(107.5f), kScale_W(98));
}
/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kScale_W(14.5f), kScale_W(13.5f), kScale_W(44), kScale_W(14.5f));
}

/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kScale_W(12);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 5000) {
        PublicTemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topTem" forIndexPath:indexPath];
        [cell setupDocItemModel:self.topCollArray[indexPath.row]];
        return cell;
    }else{
        PublicTemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bottomTem" forIndexPath:indexPath];
        [cell setupDocItemModel:self.bottomCollArray[indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YGJDocItemModel *model = nil;
    if (collectionView.tag == 5000) {
        model = self.topCollArray[indexPath.row];
    } else {
        model = self.bottomCollArray[indexPath.row];
    }
    [self.navigationController pushViewController:[[TemplatePreviewViewController alloc] initWithId:@(model.id).stringValue] animated:true];
}

#pragma mark - Private Method
- (void)setBigScrollViewContentSize {
    
    _bigScrollView.contentSize = CGSizeMake(kScreenWidth, _bottomView.bottom);
}

#pragma mark - Events
- (void)diyButtonMethod:(UIButton *)sender {
    
    sender.selected = YES;
    self.zuijinButton.selected = NO;
    self.seeMoreTopView.hidden = YES;
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, self.topCollectionView.bottom);
    self.bottomView.frame = CGRectMake(0, self.topView.bottom+10, kScreenWidth, _bottomCollectionView.bottom);
    [self setBigScrollViewContentSize];
    [self templatesListRequest];
}
- (void)zuijinButtonMethod:(UIButton *)sender {
    
    self.diyButton.selected = NO;
    sender.selected = YES;
    self.seeMoreTopView.hidden = NO;
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, self.seeMoreTopView.bottom);
    self.bottomView.frame = CGRectMake(0, self.topView.bottom+10, kScreenWidth, _bottomCollectionView.bottom);
    [self setBigScrollViewContentSize];
    [self mylatelylistRequest];
}
- (void)seeMoreButtonMethod:(UIButton *)sender {
    
    DocLibViewController *vc = [[DocLibViewController alloc] init];
    vc.isFromNewDoc = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)seeMoreTopButtonMethod:(UIButton *)sender {
    
    MineDocLibViewController *vc = [[MineDocLibViewController alloc] init];
    vc.isFromAddDoc = true;
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark – Getters and Setters
- (UIScrollView *)bigScrollView{
    
    if (!_bigScrollView) {
        _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight-kTabBarHeight)];
        _bigScrollView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _bigScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _bigScrollView;
}

- (UICollectionView *)topCollectionView {
    
    if (!_topCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _topCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.buttonView.bottom, kScreenWidth, 3*kScale_W(98)+kScale_W(13.5f)+kScale_W(44)) collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _topCollectionView.backgroundColor = [UIColor whiteColor];
        _topCollectionView.tag = 5000;
        _topCollectionView.delegate = self;
        _topCollectionView.dataSource = self;
        _topCollectionView.showsVerticalScrollIndicator = NO;
        _topCollectionView.showsHorizontalScrollIndicator = NO;
        _topCollectionView.scrollsToTop = NO;
        _topCollectionView.scrollEnabled = NO;
        [_topCollectionView registerClass:[PublicTemCollectionViewCell class] forCellWithReuseIdentifier:@"topTem"];
    }
    return _topCollectionView;
}

- (UICollectionView *)bottomCollectionView {
    
    if (!_bottomCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.seeMoreView.bottom+1, kScreenWidth, 3*kScale_W(98)+kScale_W(13.5f)+kScale_W(44)) collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _bottomCollectionView.backgroundColor = [UIColor whiteColor];
        _bottomCollectionView.tag = 5001;
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.dataSource = self;
        _bottomCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomCollectionView.showsVerticalScrollIndicator = NO;
        _bottomCollectionView.scrollsToTop = NO;
        _bottomCollectionView.scrollEnabled = NO;
        [_bottomCollectionView registerClass:[PublicTemCollectionViewCell class] forCellWithReuseIdentifier:@"bottomTem"];
    }
    return _bottomCollectionView;
}

- (QMUIEmptyView *)topEmptyView {
    if (!_topEmptyView) {
        _topEmptyView = [[QMUIEmptyView alloc] initWithFrame:self.topCollectionView.bounds];
        [_topEmptyView setImage:nil];
        [_topEmptyView setLoadingViewHidden:true];
        [_topEmptyView setTextLabelText:@"暂无数据"];
        [_topEmptyView setDetailTextLabelText:@""];
        [_topEmptyView setActionButtonTitle:@""];
        [_topEmptyView.actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        _topEmptyView.textLabelInsets = UIEdgeInsetsMake(kScale_W(-20), 0, 0, 0);
        _topEmptyView.textLabelTextColor = UIColorMakeWithHex(@"#999999");
        _topEmptyView.textLabelFont = UIFontMake(13.0);
        _topEmptyView.verticalOffset = kScale_W(-80.0);
    }
    return _topEmptyView;
}

- (QMUIEmptyView *)bottomEmptyView {
    if (!_bottomEmptyView) {
        _bottomEmptyView = [[QMUIEmptyView alloc] initWithFrame:self.bottomCollectionView.bounds];
        [_bottomEmptyView setImage:nil];
        [_bottomEmptyView setLoadingViewHidden:true];
        [_bottomEmptyView setTextLabelText:@"暂无数据"];
        [_bottomEmptyView setDetailTextLabelText:@""];
        [_bottomEmptyView setActionButtonTitle:@""];
        [_bottomEmptyView.actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        _bottomEmptyView.textLabelInsets = UIEdgeInsetsMake(kScale_W(-20), 0, 0, 0);
        _bottomEmptyView.textLabelTextColor = UIColorMakeWithHex(@"#999999");
        _bottomEmptyView.textLabelFont = UIFontMake(13.0);
        _bottomEmptyView.verticalOffset = kScale_W(-80.0);
    }
    return _bottomEmptyView;
}

- (NSMutableArray *)topCollArray {
    
    if (!_topCollArray) {
        
        _topCollArray = [NSMutableArray array];
    }
    return _topCollArray;
}

- (NSMutableArray *)bottomCollArray {
    
    if (!_bottomCollArray) {
        
        _bottomCollArray = [NSMutableArray array];
    }
    return _bottomCollArray;
}
@end
