//
//  MineViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//

#import "MineViewController.h"
#import "FlowViewController.h"
#import "FeedBackViewController.h"
#import "YJYMeAboutUSVC.h"
#import "MyProductViewController.h"
//
#import "UIButton+ClickRange.h"

// views
#import "MineTopView.h"
#import "MineTableViewCell.h"

@interface MineViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) MineTopView *topView;
@property (nonatomic, strong) UITableView *allTableView;
@end

@implementation MineViewController

#pragma mark - Life Cycle Methods
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!YGJSQLITE_MANAGER.isLogin) {
        [YGJCommonPopup showPopupStatus:YGJPopupStatusLogin complete:nil cancelHandler:nil];
        return;
    }
    [self loadInfoRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTips:) name:@"FEEDBACK-SUCCESS" object:nil];
}

- (void)showTips:(NSNotification *)notification {
    [YGJToast showToast:@"反馈成功"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}
#pragma mark - Intial Methods
- (void)initSubviews {
    self.isHidenNaviBar = true;
    self.dataArray = @[@{@"title": @"审批流程", @"icon": @"shenpiliucheng"}, @{@"title": @"我的商品", @"icon": @"shangpin"}, @{@"title": @"关于御管家", @"icon": @"guanyu"}, @{@"title": @"用户反馈", @"icon": @"fankui"}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self.view addSubview:self.allTableView];
    [self.allTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.topView];
}
#pragma mark - Network Methods
- (void)loadInfoRequest {
    @weakify(self)
    [UDAAPIRequest requestUrl:@"/app/users/getUsersInfoByToken" parameter:nil requestType:UDARequestTypePost isShowHUD:NO progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        @strongify(self)
        if (requestModel.success) {
            [self.topView setupDictionary:requestModel.result];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

#pragma mark - Target Methods

#pragma mark - Private Method

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.topView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MineTableViewCell className] forIndexPath:indexPath];
    cell.underLineView.hidden = indexPath.row == [self.dataArray count] - 1;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MineTableViewCell class]]) {
        MineTableViewCell *mineCell = (MineTableViewCell *)cell;
        NSDictionary *dict = self.dataArray[indexPath.row];
        mineCell.leftLittleImageView.image = [UIImage imageNamed:dict[@"icon"]];
        mineCell.midTitleLabel.text = dict[@"title"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSArray *tableArr = @[[FlowViewController className], [MyProductViewController className], [YJYMeAboutUSVC className], [FeedBackViewController className]];
    if (indexPath.row == 0 || indexPath.row == 1) {
        if ([YGJSQLITE_MANAGER isShouldToAuthentication]) {
            [YGJCommonPopup showPopupStatus:YGJPopupStatusAuth complete:nil cancelHandler:nil];
            return;
        }
    }
    [self.navigationController pushViewController:[NSClassFromString(tableArr[indexPath.row]) new] animated:true];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  CGFLOAT_MIN;
}

#pragma mark - Setter Getter Methods
- (UITableView *)allTableView {
    if (!_allTableView) {
        _allTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _allTableView.dataSource = self;
        _allTableView.delegate = self;
        _allTableView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
        _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _allTableView.showsVerticalScrollIndicator = false;
        _allTableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
        if (@available(iOS 11, *)) {
            _allTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_allTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:[MineTableViewCell className]];
        UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopViewHieght())];
        [hView setBackgroundColor:[UIColor clearColor]];
        _allTableView.tableHeaderView = hView;
    }
    return _allTableView;
}
- (MineTopView *)topView {
    if (!_topView) {
        _topView = [[MineTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopViewHieght())];
    }
    return _topView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FEEDBACK-SUCCESS" object:nil];
}
@end
