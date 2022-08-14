//
//  MineNeedToDoViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/26.
//

#import "MineNeedToDoViewController.h"
#import "ToDoHistoryViewController.h"
#import "PreviewDocViewController.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

//categorys
#import "UIButton+ClickRange.h"

//views
#import "DocStatusCollectionViewCell.h"
#import "SideslipView.h"

// mdoels
#import "YGJDocModel.h"
#import "YGJSerModel.h"

@interface MineNeedToDoViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) int tempType;
@property (nonatomic, assign) int serId;

@property (nonatomic, strong) UIView *firstUnderLineView;
@property (nonatomic, strong) QMUIButton *docButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *topButtonView;
@property (nonatomic, strong) NSArray *faultTopButtonArray;
@property (nonatomic, strong) UICollectionView *statusCollectionView;
@property (nonatomic, strong) NSMutableArray *selectedCodeArray;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UILabel *daibanNumLabel;
@property (nonatomic, strong) QMUIEmptyView *emptyView;

@property (nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property (nonatomic, strong) NSMutableArray *dataMutaArray;
@property (nonatomic, strong) NSArray *serRecordsArray;
@end

@implementation MineNeedToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的待办";
    self.pageNo = 1;
    _tempType = 0;
    _serId = -1;

    self.selectedCodeArray = [NSMutableArray array];
    self.faultTopButtonArray = @[@"进仓单",@"出仓单",@"发货通知单",@"收货通知单", @"委托加工单",@"承揽加工通知单",@"派车通知单",@"委托派车单",@"付款凭证", @"收款凭证"];
    self.serRecordsArray = @[];
    [self createBar];
    [self createTopUI];
}

#pragma mark - Intial Methods
- (void)createBar {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10.0, 0.0, 64.0, 44.0);
    [rightButton addTarget:self action:@selector(rightButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"待办历史" forState:UIControlStateNormal];
    rightButton.titleLabel.font = SYSTEMFONT(14);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 44.0)];
    [view addSubview:rightButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)createTopUI {
    
    //待办view
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = KWhiteColor;
    [self.view addSubview:self.topView];
    
    UIImageView *daibanImageview = [[UIImageView alloc] init];
    daibanImageview.frame = CGRectMake(10, 8, 28, 27);
    daibanImageview.contentMode = UIViewContentModeScaleAspectFit;
    daibanImageview.image = [UIImage imageNamed:@"daiban_home"];
    [self.topView addSubview:daibanImageview];
    
    UILabel *daibanLabel = [[UILabel alloc] init];
    daibanLabel.frame = CGRectMake(daibanImageview.right+6, 8, 36, 27);
    daibanLabel.text = @"待办";
    daibanLabel.font = [UIFont fontWithName:@"PingFang-SC-Heavy" size:18];
    daibanLabel.textColor = CBlackgColor;
    [self.topView addSubview:daibanLabel];
    
    _daibanNumLabel = [[UILabel alloc] init];
    _daibanNumLabel.frame = CGRectMake(daibanLabel.right, 8, 36, 27);
    _daibanNumLabel.text = @"(0)";
    _daibanNumLabel.font = [UIFont fontWithName:@"PingFang-SC-Heavy" size:18];
    _daibanNumLabel.textColor = [UIColor colorWithHexString:@"#FF4A4A"];
    [self.topView addSubview:_daibanNumLabel];

    [self.topView addSubview:self.docButton];
    self.popupByWindow.sourceView = self.docButton;

    [self.topView addSubview:self.firstUnderLineView];
    self.firstUnderLineView.frame = CGRectMake(0, daibanImageview.bottom+8, kScreenWidth, 1);
    
    [self createTopButtonByButtonArr:[self.faultTopButtonArray count] > 4 ? [self.faultTopButtonArray subarrayWithRange:NSMakeRange(0, 4)] : self.faultTopButtonArray];
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, self.topButtonView.bottom);
    
    [self.view addSubview:self.statusCollectionView];
    self.statusCollectionView.frame = CGRectMake(0,self.topView.bottom, kScreenWidth, kScreenHeight-self.topView.bottom);
}
- (void)createTopButtonByButtonArr:(NSArray *)arr {
    
    if (_topButtonView) {
        [_topButtonView removeFromSuperview];
        _topButtonView = nil;
    }
    if (self.selectedCodeArray.count != 0) {
        [self.selectedCodeArray removeAllObjects];
    }
    [self.topView addSubview:self.topButtonView];
    _topButtonView.frame = CGRectMake(0, self.firstUnderLineView.bottom+15, kScreenWidth, 40);

    CGFloat _margin_X = kScale_W(15); // 水平间距
    CGFloat _margin_Y = 0; // 数值间距
    CGFloat itemWidth = (KScreenWidth-25-_margin_X*3-35)/4.0;// 宽
    CGFloat itemHeight = 27; // 高
    NSUInteger totalColumns = 4; // 每行最大列数（影响到底几个换行）
    NSUInteger totalNum = [arr count] > 4 ? 4 : [arr count];
    
    for(NSUInteger index = 0; index < totalNum; index++) {
        
        NSUInteger row = index / totalColumns;
        NSUInteger col = index % totalColumns;
        UIButton *projectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat cellX =  col * (itemWidth + _margin_X);
        CGFloat cellY =  row * (itemHeight + _margin_Y);
        projectButton.frame = CGRectMake(12.5f+cellX,cellY, itemWidth, itemHeight);
        projectButton.tag = index + 4000;
        [projectButton setTitle:arr[index] forState:UIControlStateNormal];
        [projectButton setBackgroundColor:UIColorMakeWithHex(@"#F1F6FF")];
        [projectButton setTitleColor:CNavBgColor forState:UIControlStateNormal];
        [projectButton setTitleColor:KWhiteColor forState:UIControlStateSelected];
        projectButton.titleLabel.font = [UIFont systemFontOfSize:12];
        projectButton.layer.cornerRadius = 13;
        [projectButton addTarget:self action:@selector(projectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topButtonView addSubview:projectButton];
        [self.selectedCodeArray addObject:projectButton];
    }
    
    QMUIButton *seeMoreButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"dbseeMore") title:@""];
    seeMoreButton.frame = CGRectMake(kScreenWidth-35, 6.5, 16, 14);
    seeMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [seeMoreButton setTitleColor:UIColorMakeWithHex(@"#ffffff") forState:UIControlStateNormal];
    [seeMoreButton addTarget:self action:@selector(seeAllStatusButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [seeMoreButton setHitEdgeInsets:UIEdgeInsetsMake(-3, -4, -5, -6)];
    [self.topButtonView addSubview:seeMoreButton];
}

#pragma mark - Network Methods
- (void)loadListRequest {
    // 缺少 单据状态和
    // 缺少按单据、按服务商字段
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":@(self.pageNo),@"pageSize":@"10"}];
    if (self.tempType >= 0) [paramDict jk_setObj:@(self.tempType) forKey:@"tempType"];
    if (self.serId >= 0) [paramDict jk_setObj:@(self.serId) forKey:@"beingSerId"];
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/documents/backlog" parameter:paramDict requestType:UDARequestTypeGet isShowHUD:false progressBlock:^(CGFloat value) {
        } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
            @strongify(self);
            if (requestModel.success) {
                if (self.pageNo == 1) [self.dataMutaArray removeAllObjects];
                self.pageNo++;
                YGJDocModel *model = [YGJDocModel modelWithDictionary:requestModel.result];
                self.daibanNumLabel.text = [NSString stringWithFormat:@"(%@)", @(model.total).stringValue];
                if ([model.records count] > 0) [self.dataMutaArray addObjectsFromArray:model.records];
                [self.statusCollectionView reloadData];
                [self.statusCollectionView.mj_footer endRefreshing];
                [self.statusCollectionView.mj_header endRefreshing];
                if ([self.dataMutaArray count] ==  model.total) [self.statusCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
        } errorBlock:^(NSError * _Nullable error) {
            @strongify(self);
            [self.statusCollectionView.mj_footer endRefreshing];
            [self.statusCollectionView.mj_header endRefreshing];
        }];
}

// 下拉刷新
- (void)downRefresh:(id)sender {
    self.pageNo = 1;
//    self.tempType = 0;
    [self loadListRequest];
}

// 上提加载
- (void)upRefresh:(id)sender {
    [self loadListRequest];
}
- (void)showHideAnAttempt:(NSArray *)array {
    if ([array count] == 0) {
        [self.statusCollectionView addSubview:self.emptyView];
    } else {
        [_emptyView removeFromSuperview];
    }
}

#pragma mark - External Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self showHideAnAttempt:self.dataMutaArray];
    return [self.dataMutaArray count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScale_W(145), kScale_W(75));
}
/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kScale_W(11), kScale_W(31), kScale_W(11), kScale_W(31));
}

/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kScale_W(22);
}
/**
// 分区内cell之间的最小列间距
// */
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return kScale_W(22);
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DocStatusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DocStatusCollectionViewCell className] forIndexPath:indexPath];
    [cell setupDocItemModel:self.dataMutaArray[indexPath.row]];
//    NSArray *statusArr = @[@"新建", @"录入", @"确认", @"修改", @"取消", @"驳回",@"录入", @"确认", @"修改", @"取消"];
//    cell.statusLabel.text = statusArr[indexPath.row];
    [cell setColorDoc];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YGJDocItemModel *model = self.dataMutaArray[indexPath.row];
    [self.navigationController pushViewController:[[PreviewDocViewController alloc] initWithId:@(model.id).stringValue] animated:true];
}

#pragma mark - Events
- (void)rightButtonOnClicked {
    
    ToDoHistoryViewController *vc = [[ToDoHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selcetButtonClick:(UIButton *)btn {
    
    if (_selectedView) {
        [_selectedView removeFromSuperview];
    }
    [self.docButton setTitle:btn.titleLabel.text forState:UIControlStateNormal];
}

- (void)seeAllStatusButtonMethod {
    
    NSArray<NSString *> *suggestions1 = self.faultTopButtonArray;

    SideslipView *view = [[SideslipView alloc] initWithButtonTDocumentTypeTitleArr:suggestions1 withDocumentPropertiesTitleArr:@[] byIsShowBottomButton:true];
    @weakify(self);
    view.sureButtonBlock = ^(NSString *string) {
        
        @strongify(self);
        [self changeTempType:string];
    };
    view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    if (self.tempType < -1) {
        
        __block NSUInteger index = 0;
        [self.serRecordsArray enumerateObjectsUsingBlock:^(YGJSerItemModel *obj, NSUInteger idx, BOOL * stop) {
            
            if (self.serId == obj.id) {
                index = idx;
                *stop = YES;
            }
        }];
        [view showWithTempType:index withTitle:@"服务商"];
        return;
    }
    [view showWithTempType:self.tempType withTitle:@"单据类型"];
}

- (void)changeDocButtonMethod:(UIButton *)btn {
    [self.popupByWindow showWithAnimated:true];
}

- (void)projectBtnClick:(UIButton *)sender {
    YDZYLog(@"--点击了-->%@",sender.titleLabel.text);
    [self changeTempType:sender.titleLabel.text];
}
#pragma mark - Private Method
- (void)setupTopServiceProvider {
    
    if ([self.serRecordsArray count] > 0) {
        NSMutableArray *tmpMutaArr = [NSMutableArray array];
        [self.serRecordsArray enumerateObjectsUsingBlock:^(YGJSerItemModel * obj, NSUInteger idx, BOOL * stop) {
            [tmpMutaArr addObject:obj.serName ? obj.serName : @""];
        }];
        self.faultTopButtonArray = tmpMutaArr;
        [self createTopButtonByButtonArr:self.faultTopButtonArray];
//        YGJSerItemModel *m = [self.serRecordsArray firstObject];
//        self.serId = m.id;
//        [self setupSelectedButtonTag:0];
        [self.statusCollectionView.mj_header beginRefreshing];
        return;
    }
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/serviceProvider/list" parameter:@{@"pageSize":@(200)} requestType:UDARequestTypeGet isShowHUD:NO progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            YGJSerModel *model = [YGJSerModel modelWithDictionary:requestModel.result];
            NSMutableArray *tmpMutaArr = [NSMutableArray array];
            [model.serviceProviderVoList enumerateObjectsUsingBlock:^(YGJSerItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tmpMutaArr addObject:obj.serName ? obj.serName : @""];
            }];
            self.faultTopButtonArray = tmpMutaArr;
            self.serRecordsArray = model.serviceProviderVoList;
            [self createTopButtonByButtonArr:self.faultTopButtonArray];
            if ([model.serviceProviderVoList count] > 0) {
//                YGJSerItemModel *m = [model.serviceProviderVoList firstObject];
//                self.serId = m.id;
//                [self setupSelectedButtonTag:0];
                [self.statusCollectionView.mj_header beginRefreshing];
            }
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

- (void)changeTempType:(NSString *)text {
    
    if (self.tempType < -1) {
        NSUInteger idx = [self.faultTopButtonArray indexOfObject:text];
        if (idx < 0) return;
        YGJSerItemModel *itemModel = self.serRecordsArray[idx];
        self.serId = itemModel.id;
        [self setupSelectedButtonTag:idx];
    } else {
        self.tempType = (int)[self.faultTopButtonArray indexOfObject:text];
    }
    [self.statusCollectionView.mj_header beginRefreshing];
}

- (void)setupSelectedButtonTag:(NSUInteger)selectedTag {
    
    for (NSInteger j = 0; j < [self.selectedCodeArray count]; j++) {
        UIButton *btn = self.selectedCodeArray[j];
        if (selectedTag == btn.tag - 4000) {
            btn.selected = YES;
            btn.backgroundColor = CNavBgColor;
        } else {
            btn.selected = NO;
            btn.backgroundColor = [UIColor colorWithHexString:@"#F1F6FF"];
        }
    }
}
#pragma mark - Setter Getter Methods
- (void)setTempType:(int)tempType {
    _tempType = tempType;
    
    if (_tempType < -1) return;
    NSUInteger selectedTag = _tempType;// + 3000;
    [self setupSelectedButtonTag:selectedTag];
}
- (QMUIPopupMenuView *)popupByWindow {
    if (!_popupByWindow) {
        _popupByWindow = [[QMUIPopupMenuView alloc] init];
        _popupByWindow.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _popupByWindow.tintColor = UIColorMakeWithHex(@"#333333");
        _popupByWindow.maskViewBackgroundColor = [UIColor clearColor];// [UIColorMakeWithHex(@"#000000") colorWithAlphaComponent:.4];
        _popupByWindow.shouldShowItemSeparator = true;
        _popupByWindow.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            aItem.button.titleLabel.font = UIFontMake(15);
            [aItem.button setTitleColor:UIColorMakeWithHex(@"#333333") forState:UIControlStateNormal];
            aItem.button.highlightedBackgroundColor = UIColorMakeWithHex(@"#EEEEEE");
        };
        @weakify(self);
        _popupByWindow.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:@"按单据" handler:^(QMUIPopupMenuButtonItem *aItem) {
            
            @strongify(self);
            [self.docButton setTitle:@"按单据" forState:UIControlStateNormal];
            self.faultTopButtonArray = @[@"进仓单",@"出仓单",@"发货通知单",@"收货通知单", @"委托加工单",@"承揽加工通知单",@"派车通知单",@"委托派车单",@"付款凭证", @"收款凭证"];
            self.tempType = -1;
            self.serId = -1;
            [self createTopButtonByButtonArr:self.faultTopButtonArray];
            [aItem.menuView hideWithAnimated:true];
            [self.statusCollectionView.mj_header beginRefreshing];
        }], [QMUIPopupMenuButtonItem itemWithImage:nil title:@"按服务商" handler:^(QMUIPopupMenuButtonItem *aItem) {
            
            @strongify(self);
            [self.docButton setTitle:@"按服务商" forState:UIControlStateNormal];
            self.tempType = -2;
            [self setupTopServiceProvider];
            [aItem.menuView hideWithAnimated:true];
        }]];
        _popupByWindow.didHideBlock = ^(BOOL hidesByUserTap) {
        };
    }
    return _popupByWindow;;
}
- (NSMutableArray *)dataMutaArray {
    if (!_dataMutaArray) {
        _dataMutaArray = [NSMutableArray array];
    }
    return _dataMutaArray;
}
- (QMUIEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[QMUIEmptyView alloc] initWithFrame:self.statusCollectionView.bounds];
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
- (QMUIButton *)docButton {
    if (!_docButton) {
        _docButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"down_home") title:@"按单据"];
        _docButton .contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_docButton addTarget:self action:@selector(changeDocButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_docButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
        _docButton.spacingBetweenImageAndTitle = 6.0;
        _docButton.titleLabel.font = UIFontMake(12.0);
        _docButton.imagePosition = QMUIButtonImagePositionRight;
        _docButton.frame = CGRectMake(kScreenWidth-130, 0, 120, 40);
    }
    return _docButton;
}

- (UICollectionView *)statusCollectionView {
    
    if (!_statusCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _statusCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _statusCollectionView.backgroundColor = [UIColor whiteColor];
        _statusCollectionView.delegate = self;
        _statusCollectionView.dataSource = self;
        _statusCollectionView.showsHorizontalScrollIndicator = NO;
        _statusCollectionView.scrollsToTop = NO;
        [_statusCollectionView registerClass:[DocStatusCollectionViewCell class] forCellWithReuseIdentifier:[DocStatusCollectionViewCell className]];
        _statusCollectionView.mj_header = [YGJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
        _statusCollectionView.mj_footer = [YGJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
        [_statusCollectionView.mj_header beginRefreshing];
    }
    return _statusCollectionView;
}
- (UIView *)topButtonView {
    
    if (!_topButtonView) {
        
        _topButtonView = [[UIView alloc] init];
        _topButtonView.backgroundColor = KWhiteColor;
    }
    
    return _topButtonView;
}

- (UIView *)firstUnderLineView {
    
    if (!_firstUnderLineView) {
       
        _firstUnderLineView = [[UIView alloc] init];
        _firstUnderLineView.backgroundColor = UNDERLINECOLOR;
    }
    
    return _firstUnderLineView;
}


@end
