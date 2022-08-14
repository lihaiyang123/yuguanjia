//
//  FlowEditViewController.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/15.
//

#import "FlowEditViewController.h"
// views
#import "FlowTableViewCell.h"
#import "FlowFooterView.h"
#import "FlowHeaderView.h"

@interface FlowEditViewController ()<QMUITableViewDelegate,QMUITableViewDataSource>

@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSMutableArray *dataMutaArray;
@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableDictionary *bigDcit;

@property (nonatomic, copy) CDBlock refreshBlock;
@end

@implementation FlowEditViewController

#pragma mark - Life Cycle Methods
- (instancetype)initWithEditDict:(NSDictionary *)dic withRefresh:(CDBlock)block {
    if (self = [super init]) {
        if (dic) self.bigDcit = [NSMutableDictionary dictionaryWithDictionary:dic];
        _refreshBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

#pragma mark - Intial Methods
- (void)initSubviews {
    self.title = @"新建流程";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.view.backgroundColor = UIColorMakeWithHex(@"#F2F4F5");
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Network Methods

#pragma mark - Target Methods
- (void)rightButtonOnClicked:(UIButton *)sender {
    [self.view endEditing:true];
    NSDictionary *toastDict = @{@"procNew": @"新建", @"procInput": @"录入", @"procSubmit": @"确认", @"procEdit": @"修改", @"procCancel": @"取消"};
    NSMutableDictionary *mutaDict = [self.dataMutaArray firstObject];
    NSString *name = mutaDict[@"procName"];
    if (name.length == 0) {
        [YGJToast showToast:@"请输入流程名字"];
        return;
    }
    __block NSString *toastKey = @"";
    __block NSMutableDictionary *resultMutaDict = [NSMutableDictionary dictionaryWithDictionary:@{@"procName": name}];
    [mutaDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arrayM = (NSArray *)obj;
            if ([arrayM count] == 0) {
                toastKey = key;
                *stop = true;
            }
            resultMutaDict[key] = [arrayM componentsJoinedByString:@","];
        }
    }];
    
    if (toastKey.length > 0) {
        NSString *toast = [NSString stringWithFormat:@"请添加%@流程", toastDict[toastKey]];
        [YGJToast showToast:toast];
        return;
    }
//    YDZYLog(@"%@", resultMutaDict);
    
    NSString *requestUrl = @"/app/process/add";
    UDARequestType requestType = UDARequestTypePost;
    if ([self.bigDcit jk_hasKey:@"id"]) {
        requestUrl = @"/app/process/edit";
        requestType = UDARequestTypePut;
        [resultMutaDict jk_setObj:self.bigDcit[@"id"] forKey:@"id"];
    }
    
    @weakify(self);
    [UDAAPIRequest requestUrl:requestUrl parameter:resultMutaDict requestType:requestType isShowHUD:YES progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {

        @strongify(self);
        if (requestModel.success) {
            
            if (self.refreshBlock) self.refreshBlock();
            [self.navigationController popViewControllerAnimated:true];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];

}
#pragma mark - Public Methods
- (void)setupIndexPath:(NSIndexPath *)indexPath withKey:(NSString *)key withArray:(NSArray *)arr {

    NSMutableDictionary *dic = self.dataMutaArray[indexPath.section];
    dic[key] = arr;
    [self.dataMutaArray replaceObjectAtIndex:indexPath.section withObject:dic];
}

#pragma mark - Private Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:true];
}
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
        [flowCell setupName:dic withValue:valueArray withIsEdit:true withIndexPath:indexPath];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ceil(kScale_W(60));
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableDictionary *dic = self.dataMutaArray[section];
    @weakify(self);
    return [[FlowHeaderView alloc] initWithEdit:true withName:dic[@"procName"] withBlock:^(NSString *string) {
        @strongify(self);
        dic[@"procName"] = string;
        [self.dataMutaArray replaceObjectAtIndex:section withObject:dic];
    } withEditBlock:nil];
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
        _tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[FlowTableViewCell class] forCellReuseIdentifier:[FlowTableViewCell className]];
    }
    return _tableView;
}

- (NSMutableArray *)dataMutaArray {
    if (!_dataMutaArray) {
        _dataMutaArray = [NSMutableArray arrayWithArray:@[self.bigDcit]];
    }
    return _dataMutaArray;
}
- (NSArray *)keyArray {
    if (!_keyArray) {
        _keyArray = @[@{@"procNew": @"新建"}, @{@"procInput": @"录入"}, @{@"procSubmit": @"确认"}, @{@"procEdit": @"修改"}, @{@"procCancel": @"取消"}];
    }
    return _keyArray;
}
- (NSMutableDictionary *)bigDcit {
    if (!_bigDcit) {
        _bigDcit = [NSMutableDictionary dictionaryWithDictionary:@{@"procName": @"", @"procNew": @[], @"procInput": @[], @"procSubmit": @[], @"procEdit": @[], @"procCancel": @[]}];
    }
    return _bigDcit;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(10.0, 0.0, 44.0, 44.0);
        [_rightButton addTarget:self action:@selector(rightButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    return _rightButton;
}
@end
