//
//  ServiceDocViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/9.
//

#import "ServiceDocViewController.h"
#import "PreviewDocViewController.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

// mdoels
#import "YGJDocModel.h"
#import "YGJSerModel.h"

//views
#import "MyDocTableViewCell.h"

@interface ServiceDocViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, strong) UITableView *allTableView;
@property (nonatomic, strong) NSMutableArray *dataMutaArray;
@property (nonatomic, strong) QMUIEmptyView *emptyView;
@end

@implementation ServiceDocViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"与该企业的单据";
    self.pageNo = 1;
    [self initSubviews];
}
#pragma mark - Intial Methods
- (void)initSubviews {
    [self creatTableView];
}

- (void)creatTableView{
    
    _allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kScreenHeight-kStatusBarHeight-44) style:UITableViewStylePlain];
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
#pragma mark - Network Methods
- (void)loadData {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":@(self.pageNo),@"pageSize":@"10" ,@"status": @"ALL", @"serId":@(self.idInteger)}];
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
    [self loadData];
}

// 上提加载
- (void)upRefresh:(id)sender {
    [self loadData];
}
#pragma mark - Events

#pragma mark - Public Methods

#pragma mark - Private Method
- (void)showHideAnAttempt:(NSArray *)array {
    if ([array count] == 0) {
        [self.allTableView addSubview:self.emptyView];
    } else {
        [_emptyView removeFromSuperview];
    }
}

#pragma mark - tableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self showHideAnAttempt:self.dataMutaArray];
    return [self.dataMutaArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark – Getters and Setters

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
- (NSMutableArray *)dataMutaArray {
    if (!_dataMutaArray) {
        _dataMutaArray = [NSMutableArray array];
    }
    return _dataMutaArray;
}

@end
