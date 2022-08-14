//
//  MineDocLibViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/27.
//

#import "MineDocLibViewController.h"
#import "PreviewDocViewController.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

// views
#import "SideslipView.h"
#import "MyDocTableViewCell.h"

// mdoels
#import "YGJDocModel.h"
#import "YGJSerModel.h"

@interface MineDocLibViewController () <UITableViewDelegate,UITableViewDataSource> {
    CGFloat _collectionViewHeight;
    CGFloat _topButtonViewHeight;
    BOOL _isClickSeeAllStatusButton;
}
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) int tempType;
@property (nonatomic, assign) int serId;
@property (nonatomic, assign) NSUInteger docStatus;

@property (nonatomic, strong) QMUIButton *docButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *topButtonView;
@property (nonatomic, strong) NSArray *faultTopButtonArray;
@property (nonatomic, strong) NSMutableArray *selectedCodeArray;
@property (nonatomic, strong) UITableView *allTableView;
@property (nonatomic, strong) NSMutableArray *dataMutaArray;

@property (nonatomic, strong) QMUIEmptyView *emptyView;
@property (nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property (nonatomic, strong) NSArray *serRecordsArray;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *statusArray;
@end

@implementation MineDocLibViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isFromAddDoc) {
        self.isHidenNaviBar = YES;
    }
    if ([YGJSQLITE_MANAGER isShouldToAuthentication]) {
        [YGJCommonPopup showPopupStatus:YGJPopupStatusAuth complete:nil cancelHandler:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    _tempType = -1;
    _serId = -1;
    if (!self.isFromAddDoc) {
        self.isHidenNaviBar = YES;
    } else {
        self.title = @"我的单据";
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.faultTopButtonArray = @[@"进仓单",@"出仓单",@"发货通知单",@"收货通知单", @"委托加工单",@"承揽加工通知单",@"派车通知单",@"委托派车单",@"付款凭证", @"收款凭证"];
    self.statusArray = @[@"进行中",@"已结束",@"已取消",@"全部"];
    self.docStatus = 0;
    self.serRecordsArray = @[];
    _topButtonViewHeight = 39;
    [self createTopUI];
}

- (void)createTopUI {
    
    // 待办view
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, 151);
    self.topView.backgroundColor = KWhiteColor;
    [self.view addSubview:self.topView];
    
    [self.topView addSubview:self.docButton];
    self.popupByWindow.sourceView = self.docButton;

    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.frame = CGRectMake(12.5f, 30, kScale_W(350), 40);

    [self createTopButtonByButtonArr:self.faultTopButtonArray];
    [self creatTableView];
}

#pragma mark - Network Methods
- (void)loadListRequest {
    // 缺少 单据状态和
    // 缺少按单据、按服务商字段
    
    NSString *status = @"";
    if (self.docStatus <= 3) status = @[@"ING",@"END",@"CANCEL",@"ALL"][self.docStatus];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":@(self.pageNo), @"status": status}];
    if (self.tempType >= 0) [paramDict jk_setObj:@(self.tempType) forKey:@"tempType"];
    if (self.serId >= 0) [paramDict jk_setObj:@(self.serId) forKey:@"serId"];
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/documents/mylist" parameter:paramDict requestType:UDARequestTypeGet isShowHUD:false progressBlock:^(CGFloat value) {
        } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
            @strongify(self);
            if (requestModel.success) {
                if (self.pageNo == 1) [self.dataMutaArray removeAllObjects];
                self.pageNo++;
                YGJDocModel *model = [YGJDocModel modelWithDictionary:requestModel.result];
                if ([model.records count] > 0) [self.dataMutaArray addObjectsFromArray:model.records];
                [self.allTableView reloadData];
                [self.allTableView.mj_footer endRefreshing];
                [self.allTableView.mj_header endRefreshing];
                if ([self.dataMutaArray count] ==  model.total) [self.allTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } errorBlock:^(NSError * _Nullable error) {
            @strongify(self);
            [self.allTableView.mj_footer endRefreshing];
            [self.allTableView.mj_header endRefreshing];
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
#pragma mark - 加仓单 出仓单按钮
- (void)createTopButtonByButtonArr:(NSArray *)arr {
    
    if (_topButtonView) {
        [_topButtonView removeFromSuperview];
        _topButtonView = nil;
    }
    if (self.selectedCodeArray.count != 0) {
        [self.selectedCodeArray removeAllObjects];
    }
    self.topButtonView = [[UIView alloc] init];
    
    self.topButtonView.frame = CGRectMake(0, self.segmentedControl.bottom+18, kScreenWidth, _topButtonViewHeight);
    self.topButtonView.backgroundColor = KWhiteColor;
    [self.topView addSubview:self.topButtonView];
    
    CGFloat _margin_X = kScale_W(15); // 水平间距
    CGFloat _margin_Y = 0; // 数值间距
    CGFloat itemWidth = (KScreenWidth-25-_margin_X*3)/4.0;// 宽
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
//        if (index == 0) {
//            projectButton.selected = YES;
//            projectButton.backgroundColor = CNavBgColor;
//
//        }else {
//            projectButton.selected = NO;
            projectButton.backgroundColor = [UIColor colorWithHexString:@"#F1F6FF"];
//        }
        [projectButton setTitleColor:CNavBgColor forState:UIControlStateNormal];
        [projectButton setTitleColor:KWhiteColor forState:UIControlStateSelected];
        projectButton.titleLabel.font = [UIFont systemFontOfSize:12];
        projectButton.layer.cornerRadius = 13;
        [projectButton addTarget:self action:@selector(projectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topButtonView addSubview:projectButton];
        [self.selectedCodeArray addObject:projectButton];
    }
    
    JXYButton *seeAllButton = [[JXYButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2.0, _topButtonView.bottom, 100, 20) withNomalTitle:@"查看全部" withSelectTilel:@"" withFont:12 withImageNomal:@"seeAll_home" withImageSelected:@""];
    seeAllButton.titleLabel.textAlignment = 1;
    [seeAllButton setImagePosition:JXYUIButtonImagePositionRight spacing:5];
    [seeAllButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.topView addSubview:seeAllButton];
    [seeAllButton addTarget:self action:@selector(seeAllButtonMethod) forControlEvents:UIControlEventTouchUpInside];
}
- (void)creatTableView{
    
    _allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.bottom, KScreenWidth, kScreenHeight-151-kStatusBarHeight-44-kTabBarHeight) style:UITableViewStylePlain];
    _allTableView.dataSource = self;
    _allTableView.delegate = self;
    _allTableView.rowHeight = 135;
    _allTableView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _allTableView.mj_header = [YGJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    _allTableView.mj_footer = [YGJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    [_allTableView.mj_header beginRefreshing];
    [self.view addSubview:_allTableView];
}

#pragma mark - tableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self showHideAnAttempt:self.dataMutaArray];
    return [self.dataMutaArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyDocTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyDocTableViewCell className]];
    if (!cell) {
        cell = [[MyDocTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyDocTableViewCell className]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MyDocTableViewCell class]]) {
        MyDocTableViewCell *docCell = (MyDocTableViewCell *)cell;
        [docCell setupDocItemModel:self.dataMutaArray[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YGJDocItemModel *model = self.dataMutaArray[indexPath.row];
    [self.navigationController pushViewController:[[PreviewDocViewController alloc] initWithId:@(model.id).stringValue] animated:true];
}
#pragma mark - 点击事件
- (void)changeDocButtonMethod:(UIButton *)sender {
    
    [self.popupByWindow showWithAnimated:true];
}
- (void)projectBtnClick:(UIButton *)sender {
    YDZYLog(@"--点击了-->%@",sender.titleLabel.text);
    [self changeTempType:sender.titleLabel.text];
}
-(void)changeIndex {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    self.docStatus = index;
    self.tempType = -1;
    [self.allTableView.mj_header beginRefreshing];
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
    [self.allTableView.mj_header beginRefreshing];
}

- (void)seeAllButtonMethod {

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
- (void)showHideAnAttempt:(NSArray *)array {
    if ([array count] == 0) {
        [self.allTableView addSubview:self.emptyView];
    } else {
        [_emptyView removeFromSuperview];
    }
}

- (void)setupTopServiceProvider {
    
    if ([self.serRecordsArray count] > 0) {
        NSMutableArray *tmpMutaArr = [NSMutableArray array];
        [self.serRecordsArray enumerateObjectsUsingBlock:^(YGJSerItemModel * obj, NSUInteger idx, BOOL * stop) {
            [tmpMutaArr addObject:obj.serName ? obj.serName : @""];
        }];
        self.faultTopButtonArray = tmpMutaArr;
        [self createTopButtonByButtonArr:self.faultTopButtonArray];
        YGJSerItemModel *m = [self.serRecordsArray firstObject];
        self.serId = m.id;
        [self setupSelectedButtonTag:0];
        [self.allTableView.mj_header beginRefreshing];
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
                YGJSerItemModel *m = [model.serviceProviderVoList firstObject];
                self.serId = m.id;
                [self setupSelectedButtonTag:0];
                [self.allTableView.mj_header beginRefreshing];
            }
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

#pragma mark - 懒加载
- (void)setTempType:(int)tempType {
    _tempType = tempType;
    
    if (_tempType < -1) return;
    NSUInteger selectedTag = _tempType;// + 3000;
    [self setupSelectedButtonTag:selectedTag];
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
- (NSMutableArray *)dataMutaArray {
    if (!_dataMutaArray) {
        _dataMutaArray = [NSMutableArray array];
    }
    return _dataMutaArray;
}
- (NSMutableArray *)selectedCodeArray {
    
    if (!_selectedCodeArray) {
        
        _selectedCodeArray = [NSMutableArray array];
    }
    return _selectedCodeArray;
}
- (QMUIEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[QMUIEmptyView alloc] initWithFrame:self.allTableView.bounds];
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
            [self createTopButtonByButtonArr:self.faultTopButtonArray];
            self.tempType = -1;
            self.serId = -1;
            [aItem.menuView hideWithAnimated:true];
            [self.allTableView.mj_header beginRefreshing];
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
- (UISegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:self.statusArray];
        
        _segmentedControl.layer.borderColor = [CNavBgColor CGColor];
        _segmentedControl.layer.borderWidth = 0.5;
        _segmentedControl.layer.cornerRadius = 5.0;
        _segmentedControl.layer.masksToBounds = true;

        [_segmentedControl setTintColor:CNavBgColor];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl setBackgroundImage:[[UIImage qmui_imageWithColor:[UIColor whiteColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setBackgroundImage:[[UIImage qmui_imageWithColor:CNavBgColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

        _segmentedControl.apportionsSegmentWidthsByContent = NO;
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:UIFontMake(14),
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性

        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:UIFontMake(14),
                                                   NSForegroundColorAttributeName:CNavBgColor};

        [_segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        [_segmentedControl addTarget:self action:@selector(changeIndex) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
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
        _docButton.frame = CGRectMake(kScreenWidth-130, 0, 120, 30);
    }
    return _docButton;
}
@end
