//
//  FlowViewController.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/14.
//

#import "FlowViewController.h"
#import "FlowEditViewController.h"

#import "YGJRefreshFooter.h"
#import "YGJRefreshNormalHeader.h"

// views
#import "FlowTableViewCell.h"
#import "FlowFooterView.h"
#import "FlowHeaderView.h"

// models
#import "MineFlowModel.h"

@interface FlowViewController () <QMUITableViewDelegate,QMUITableViewDataSource>

@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSMutableArray *dataMutaArray;
@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation FlowViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}
#pragma mark - Intial Methods
- (void)initSubviews {
    self.view.backgroundColor = UIColorMakeWithHex(@"#F2F4F5");
    self.title = @"流程设置";
    self.pageNo = 1;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
- (void)loadData {
    
    @weakify(self);

    [UDAAPIRequest requestUrl:@"/app/process/mylist" parameter:@{@"pageNo":@(self.pageNo)} requestType:UDARequestTypeGet isShowHUD:false progressBlock:^(CGFloat value) {
            
        } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
            @strongify(self);
            if (requestModel.success) {
                if (self.pageNo == 1) [self.dataMutaArray removeAllObjects];
                self.pageNo++;
                MineFlowModel *model = [MineFlowModel modelWithDictionary:requestModel.result];
                if ([model.records count] > 0) [self.dataMutaArray addObjectsFromArray:model.records];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                if ([self.dataMutaArray count] ==  model.total) [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }

        } errorBlock:^(NSError * _Nullable error) {
            @strongify(self);
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
}
#pragma mark - Target Methods
- (void)goToEditViewController:(NSDictionary *)dic {
    
    @weakify(self);
    [self.navigationController pushViewController:[[FlowEditViewController alloc] initWithEditDict:dic withRefresh:^{
        
        @strongify(self);
        [self.tableView.mj_header beginRefreshing];
    }] animated:true];
}
#pragma mark - Public Methods
- (void)setupIndexPath:(NSIndexPath *)indexPath withKey:(NSString *)key withArray:(NSArray *)arr {

    NSMutableDictionary *dic = self.dataMutaArray[indexPath.section];
    dic[key] = arr;
    [self.dataMutaArray replaceObjectAtIndex:indexPath.section withObject:dic];
}

#pragma mark - Private Method

#pragma mark - External Delegate

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataMutaArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger num = [self.dataMutaArray[section] count];
    if (num > [self.keyArray count]) {
        num = [self.keyArray count];
    }
    return num;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FlowTableViewCell className] forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[FlowTableViewCell class]]) {
        FlowTableViewCell *flowCell = (FlowTableViewCell *)cell;
        NSDictionary *dic = self.keyArray[indexPath.row];
        NSArray *valueArray = self.dataMutaArray[indexPath.section][[[dic allKeys] firstObject]];
        [flowCell setupName:dic withValue:valueArray withIsEdit:false withIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:true];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    FlowTableViewCell *cell = (FlowTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(cellSelectRowAtIndexPath:)]) {
        [cell cellSelectRowAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableDictionary *dic = self.dataMutaArray[section];
    @weakify(self);
    return [[FlowHeaderView alloc] initWithEdit:false withName:dic[@"procName"] withBlock:nil withEditBlock:^{
        
        @strongify(self);
        [self goToEditViewController:dic];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ceil(kScale_W(60));
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kScale_W(47);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  CGFLOAT_MIN;
}

#pragma mark - Setter Getter Methods
- (QMUITableView *)tableView {
    if (!_tableView) {
        _tableView = [[QMUITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.tableFooterView = self.footerView; // [[UIView alloc] initWithFrame: CGRectZero];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[FlowTableViewCell class] forCellReuseIdentifier:[FlowTableViewCell className]];
        _tableView.mj_header = [YGJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
        _tableView.mj_footer = [YGJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (NSMutableArray *)dataMutaArray {
    if (!_dataMutaArray) {
        _dataMutaArray = [NSMutableArray array];
    }
    return _dataMutaArray;
}
- (NSArray *)keyArray {
    if (!_keyArray) {
        _keyArray = @[@{@"procNew": @"新建"}, @{@"procInput": @"录入"}, @{@"procSubmit": @"确认"}, @{@"procEdit": @"修改"}, @{@"procCancel": @"取消"}];
    }
    return _keyArray;
}
- (UIView *)footerView {
    if (!_footerView) {
        @weakify(self);
        _footerView = [[FlowFooterView alloc] initWithBlock:^{
            @strongify(self);
            [self goToEditViewController:nil];
        }];
    }
    return _footerView;
}
@end
