//
//  DocumentOperationViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/7.
//

#import "DocumentOperationViewController.h"

//views
#import "DocumentOperationTableViewCell.h"

@interface DocumentOperationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *allTableView;
@property (nonatomic, strong) QMUIEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *dataMutaArr;
@end

@implementation DocumentOperationViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self loadData];
}
#pragma mark - Intial Methods
- (void)initSubviews {
        
    self.title = @"操作记录";
    [self.view addSubview:self.allTableView];
    [self.allTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - Network Methods
- (void)showHideAnAttempt:(NSArray *)array {
    if ([array count] == 0) {
        [self.allTableView addSubview:self.emptyView];
    } else {
        [_emptyView removeFromSuperview];
    }
}
- (void)loadData {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:[NSString stringWithFormat:@"/app/documents/logs/%@",self.idStr] parameter:@{} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            self.dataMutaArr = requestModel.result[@"records"];
//            [YGJToast showToast:requestModel.message];
            [self.allTableView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
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
    
    DocumentOperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DocumentOperationTableViewCell className] forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell isKindOfClass:[DocumentOperationTableViewCell class]]) {
        DocumentOperationTableViewCell *cooCell = (DocumentOperationTableViewCell *)cell;
        [cooCell setUpDict:self.dataMutaArr[indexPath.row]];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark – Getters and Setters
- (UITableView *)allTableView {
    
    if (!_allTableView) {
        
        _allTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _allTableView.dataSource = self;
        _allTableView.delegate = self;
        _allTableView.backgroundColor = KWhiteColor;
        _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_allTableView registerClass:[DocumentOperationTableViewCell class] forCellReuseIdentifier:[DocumentOperationTableViewCell className]];
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

#pragma mark – Getters and Setters

@end
