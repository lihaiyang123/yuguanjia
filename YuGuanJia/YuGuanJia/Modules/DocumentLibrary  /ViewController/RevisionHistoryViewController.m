//
//  RevisionHistoryViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/29.
//

#import "RevisionHistoryViewController.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

//views
#import "RevisionHistoryTableViewCell.h"

@interface RevisionHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *allTableView;
@property (nonatomic, strong) QMUIEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString *idString;
@end

@implementation RevisionHistoryViewController

- (instancetype)initWithId:(NSString *)idString {
    if (self = [super init]) {
        self.idString = idString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改记录";
//    self.pageNo = 1;
    [self creatTableView];
}

- (void)loadListRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:[NSString stringWithFormat:@"/app/documents/modify/logs/%@",self.idString] parameter:@{} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
//            if (self.pageNo == 1) [self.dataArr removeAllObjects];
//            self.pageNo++;
            if ([self.dataArr count] != 0) {
                [self.dataArr removeAllObjects];
            }
            self.dataArr = [NSMutableArray arrayWithArray:requestModel.result[@"records"]];
            [self.allTableView reloadData];
            [self.allTableView.mj_footer endRefreshing];
            [self.allTableView.mj_header endRefreshing];
            if ([self.dataArr count] == [requestModel.result[@"total"] integerValue]) [self.allTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [YGJToast showToast:requestModel.message];
            [self.allTableView.mj_footer endRefreshing];
            [self.allTableView.mj_header endRefreshing];

        }
    } errorBlock:^(NSError * _Nullable error) {
        @strongify(self);
        [self.allTableView.mj_footer endRefreshing];
        [self.allTableView.mj_header endRefreshing];
    }];
}

- (void)creatTableView {
    
    _allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kScreenHeight-kStatusBarHeight-44) style:UITableViewStylePlain];
    _allTableView.dataSource = self;
    _allTableView.delegate = self;
    _allTableView.backgroundColor = UIColorMakeWithHex(@"#F2F4F5");
    _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_allTableView];
    _allTableView.mj_header = [YGJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    _allTableView.mj_footer = [YGJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    [_allTableView.mj_header beginRefreshing];
}

// 下拉刷新
- (void)downRefresh:(id)sender {
//    self.pageNo = 1;
    [self loadListRequest];
}

// 上提加载
- (void)upRefresh:(id)sender {
    [self loadListRequest];
}
- (void)showHideAnAttempt:(NSArray *)array {
    if ([array count] == 0) {
        [self.allTableView addSubview:self.emptyView];
    } else {
        [_emptyView removeFromSuperview];
    }
}
#pragma mark - tableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self showHideAnAttempt:self.dataArr];
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 116.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RevisionHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RevisionHistoryTableViewCell className]];
    if (!cell) {
        
        cell = [[RevisionHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[RevisionHistoryTableViewCell className]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setDataDic:self.dataArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;;
}

@end
