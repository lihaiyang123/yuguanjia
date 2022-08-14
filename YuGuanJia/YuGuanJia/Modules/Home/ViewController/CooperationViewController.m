//
//  CooperationViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/6.
//

#import "CooperationViewController.h"
#import "PreviewDocViewController.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

//views
#import "XieZuoDTTableViewCell.h"

// mdoels
#import "CooperationModel.h"

@interface CooperationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, strong) UITableView *allTableView;
@property (nonatomic, strong) QMUIEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *dataMutaArr;
@end

@implementation CooperationViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}
#pragma mark - Intial Methods
- (void)initSubviews {
    self.title = @"协作动态";
    self.pageNo = 1;
    [self.view addSubview:self.allTableView];
    [self.allTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - Network Methods
// 下拉刷新
- (void)downRefresh:(id)sender {
    self.pageNo = 1;
    [self loadData];
}
// 上提加载
- (void)upRefresh:(id)sender {
    [self loadData];
}
- (void)showHideAnAttempt:(NSArray *)array {
    if ([array count] == 0) {
        [self.allTableView addSubview:self.emptyView];
    } else {
        [_emptyView removeFromSuperview];
    }
}
- (void)loadData {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/processInstance/work/events" parameter:@{@"pageNo":@(self.pageNo),@"pageSize":@"10"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (self.pageNo == 1) [self.dataMutaArr removeAllObjects];
        self.pageNo++;
        if (requestModel.success) {
            NSArray *arr = requestModel.result[@"records"];
            NSInteger total = [requestModel.result[@"total"] integerValue];
            for (int i = 0; i < [arr count]; i ++) {
                [self.dataMutaArr addObject:[CooperationModel modelWithDictionary:arr[i]]];
            }
            [self.allTableView reloadData];
            [self.allTableView.mj_footer endRefreshing];
            [self.allTableView.mj_header endRefreshing];
            if ([self.dataMutaArr count] ==  total) [self.allTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } errorBlock:^(NSError * _Nullable error) {
        [self.allTableView.mj_footer endRefreshing];
        [self.allTableView.mj_header endRefreshing];
    }];
}

#pragma mark - Events

#pragma mark - Public Methods

#pragma mark - Private Method

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self showHideAnAttempt:self.dataMutaArr];
    return self.dataMutaArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XieZuoDTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XieZuoDTTableViewCell className] forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell isKindOfClass:[XieZuoDTTableViewCell class]]) {
        XieZuoDTTableViewCell *cooCell = (XieZuoDTTableViewCell *)cell;
        CooperationModel *model = self.dataMutaArr[indexPath.row];
        [cooCell setUpCooperationModel:model];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CooperationModel *model = self.dataMutaArr[indexPath.row];
    [self.navigationController pushViewController:[[PreviewDocViewController alloc] initWithId:@(model.id).stringValue] animated:true];
}
#pragma mark – Getters and Setters
- (UITableView *)allTableView {
    
    if (!_allTableView) {
        _allTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _allTableView.dataSource = self;
        _allTableView.delegate = self;
        _allTableView.backgroundColor = KWhiteColor;
        _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_allTableView registerClass:[XieZuoDTTableViewCell class] forCellReuseIdentifier:[XieZuoDTTableViewCell className]];
        _allTableView.mj_header = [YGJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
        _allTableView.mj_footer = [YGJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
        [_allTableView.mj_header beginRefreshing];
    }
    return _allTableView;
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

- (NSMutableArray *)dataMutaArr {
    if (!_dataMutaArr) {
        _dataMutaArr = [NSMutableArray array];
    }
    return _dataMutaArr;
}
@end
