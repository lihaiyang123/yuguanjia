//
//  DocLibViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/27.
//

#import "DocLibViewController.h"
#import "TemplatePreviewViewController.h"

#import "PublicTemCollectionViewCell.h"
#import "SideslipView.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

// mdoels
#import "YGJDocModel.h"
#import "YGJSerModel.h"

@interface DocLibViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) JXYButton *shaiXuanButton;
@property (nonatomic, strong) UICollectionView *publicTemplateCollectionView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) QMUIEmptyView *emptyView;

@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) int tempType;
@property (nonatomic, assign) NSUInteger pubPri;
@property (nonatomic, strong) NSArray *faultTopButtonArray;
@property (nonatomic, strong) NSMutableArray *dataMutaArray;
@end

@implementation DocLibViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    if (!self.isFromNewDoc) {
        self.isHidenNaviBar = YES;
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
    if (self.isFromNewDoc) {
        self.title = @"单据库";
    }
	[self.view setBackgroundColor:UIColorMakeWithHex(@"#F2F4F5")];
	self.pageNo = 1;
	_tempType = -1;
	self.pubPri = 0;
    self.faultTopButtonArray = @[@"进仓单",@"出仓单",@"发货通知单",@"收货通知单", @"委托加工单",@"承揽加工通知单",@"派车通知单",@"委托派车单",@"付款凭证", @"收款凭证"];
    if (!self.isFromNewDoc) {
        self.isHidenNaviBar = YES;
    }
	[self createTopUI];
}

- (void)createTopUI {
	//待办view
	self.topView = [[UIView alloc] init];
	self.topView.frame = CGRectMake(0, 0, kScreenWidth, 74);
	self.topView.backgroundColor = KWhiteColor;
	[self.view addSubview:self.topView];
	[self createStautsButton];
	[self createCollectionView];
}

#pragma mark -
- (void)createStautsButton {

	[self.topView addSubview:self.segmentedControl];
	self.segmentedControl.frame = CGRectMake(kScale_W(62), 15.5f, kScale_W(250), 40);

	self.shaiXuanButton = [[JXYButton alloc] initWithFrame:CGRectMake(self.segmentedControl.right+17,17.5f, 44, 40) withNomalTitle:@"筛选" withSelectTilel:@"" withFont:9 withImageNomal:@"shaixuan" withImageSelected:@""];
	[self.shaiXuanButton setImagePosition:JXYUIButtonImagePositionTop spacing:3];
	[self.shaiXuanButton setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
	[self.shaiXuanButton addTarget:self action:@selector(shaixuanButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.topView addSubview:self.shaiXuanButton];
}

#pragma mark - UICollectionView
- (void)createCollectionView {

	CGFloat itemHeight = kScale_W(98);
	CGFloat itemWitdh = kScale_W(107.5);
	CGFloat leftGap = kScale_W(14.5);
	CGFloat topGap = kScale_W(20.5);
	CGFloat itemGap = kScale_W(12);
	CGFloat bottomGap = kScale_W(20);
	CGFloat collectionViewHeight = kScreenHeight-kStatusBarHeight-44-kTabBarHeight-74;
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	self.publicTemplateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.topView.bottom, kScreenWidth, collectionViewHeight) collectionViewLayout:layout];
	[layout setScrollDirection:UICollectionViewScrollDirectionVertical];
	self.publicTemplateCollectionView.backgroundColor = [UIColor clearColor];
	//    设置每一块大小
	layout.itemSize = CGSizeMake(itemWitdh, itemHeight);
	//    设置行间距
	layout.minimumLineSpacing = itemGap;
	//    设置列间距
	layout.minimumInteritemSpacing = 0;
	//    设置边界间距
	layout.sectionInset = UIEdgeInsetsMake(topGap, leftGap,bottomGap, leftGap);
	[self.view addSubview:self.publicTemplateCollectionView];
	self.publicTemplateCollectionView.delegate = self;
	self.publicTemplateCollectionView.dataSource = self;
	self.publicTemplateCollectionView.showsHorizontalScrollIndicator = NO;
	self.publicTemplateCollectionView.scrollsToTop = NO;
	[self.publicTemplateCollectionView registerClass:[PublicTemCollectionViewCell class] forCellWithReuseIdentifier:[PublicTemCollectionViewCell className]];
	self.publicTemplateCollectionView.mj_header = [YGJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
	self.publicTemplateCollectionView.mj_footer = [YGJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
	[self.publicTemplateCollectionView.mj_header beginRefreshing];
}

#pragma mark - Network Methods
- (void)loadListRequest {
	// 缺少 单据状态和
	// 缺少按单据、按服务商字段
    NSMutableDictionary *paramDict = nil;
    NSString *requestUrl = @"/app/templates/list";
    if (self.pubPri == 0) {
        paramDict = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":@(self.pageNo),@"pageSize":@(10),@"pubPri": @(self.pubPri)}];
        if (self.tempType >= 0) [paramDict jk_setObj:@(self.tempType) forKey:@"tempType"];

    } else {
        requestUrl = @"/app/templates/custom/list";
        paramDict = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":@(self.pageNo),@"pageSize":@(10)}];
        if (self.tempType >= 0) [paramDict jk_setObj:@(self.tempType) forKey:@"tempType"];
    }
	@weakify(self);
	[UDAAPIRequest requestUrl:requestUrl parameter:paramDict requestType:UDARequestTypeGet isShowHUD:false progressBlock:^(CGFloat value) {
	 } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
	         @strongify(self);
	         if (requestModel.success) {
			 if (self.pageNo == 1) [self.dataMutaArray removeAllObjects];
			 self.pageNo++;
			 YGJDocModel *model = [YGJDocModel modelWithDictionary:requestModel.result];
			 if ([model.records count] > 0) [self.dataMutaArray addObjectsFromArray:model.records];
			 [self.publicTemplateCollectionView reloadData];
			 [self.publicTemplateCollectionView.mj_footer endRefreshing];
			 [self.publicTemplateCollectionView.mj_header endRefreshing];
			 if ([self.dataMutaArray count] ==  model.total) [self.publicTemplateCollectionView.mj_footer endRefreshingWithNoMoreData];
		 }
	 } errorBlock:^(NSError * _Nullable error) {
	         @strongify(self);
	         [self.publicTemplateCollectionView.mj_footer endRefreshing];
	         [self.publicTemplateCollectionView.mj_header endRefreshing];
	 }];
}

// 下拉刷新
- (void)downRefresh:(id)sender {
	self.pageNo = 1;
	[self loadListRequest];
}

// 上提加载
- (void)upRefresh:(id)sender {
	[self loadListRequest];
}
- (void)showHideAnAttempt:(NSArray *)array {
	if ([array count] == 0) {
		[self.publicTemplateCollectionView addSubview:self.emptyView];
	} else {
		[_emptyView removeFromSuperview];
	}
}
#pragma mark - collectionView代理
//设置collectionView一共有多少块
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	[self showHideAnAttempt:self.dataMutaArray];
	return [self.dataMutaArray count];
}
//设置每一块的内容cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	PublicTemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PublicTemCollectionViewCell className] forIndexPath:indexPath];
	[cell setupDocItemModel:self.dataMutaArray[indexPath.row]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    YGJDocItemModel *model = self.dataMutaArray[indexPath.row];
    [self.navigationController pushViewController:[[TemplatePreviewViewController alloc] initWithId:@(model.id).stringValue] animated:true];
}

#pragma mark - 点击事件
-(void)changeIndex {
	NSInteger index=self.segmentedControl.selectedSegmentIndex;
	self.pubPri = index;
	[self.publicTemplateCollectionView.mj_header beginRefreshing];
}

- (void)shaixuanButtonOnClicked {

	SideslipView *view = [[SideslipView alloc] initWithButtonTDocumentTypeTitleArr:self.faultTopButtonArray withDocumentPropertiesTitleArr:@[] byIsShowBottomButton:NO];
	view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
	@weakify(self);
	view.sureButtonBlock = ^(NSString *string) {

	        @strongify(self);
	        [self changeTempType:string];
	};
	[view showWithTempType:self.tempType withTitle:@"单据类型"];
}
- (void)changeTempType:(NSString *)text {

	self.tempType = (int)[self.faultTopButtonArray indexOfObject:text];
	[self.publicTemplateCollectionView.mj_header beginRefreshing];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataMutaArray {
	if (!_dataMutaArray) {
		_dataMutaArray = [NSMutableArray array];
	}
	return _dataMutaArray;
}
- (QMUIEmptyView *)emptyView {
	if (!_emptyView) {
		_emptyView = [[QMUIEmptyView alloc] initWithFrame:self.publicTemplateCollectionView.bounds];
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
- (UISegmentedControl *)segmentedControl {
	if (!_segmentedControl) {
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"公共模板",@"个性化模板"]];

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
@end
