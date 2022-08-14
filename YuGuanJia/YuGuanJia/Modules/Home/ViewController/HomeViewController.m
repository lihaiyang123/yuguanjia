//
//  HomeViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//

#import "HomeViewController.h"
#import "MineNeedToDoViewController.h"
#import "AddNewDocViewController.h"
#import "PreviewDocViewController.h"
#import "CooperationViewController.h"

//categorys
#import "UIButton+ClickRange.h"

//views
#import "DocStatusCollectionViewCell.h"
#import "XieZuoDTTableViewCell.h"
#import "XieZuoTaiNoDataTableViewCell.h"
#import "SideslipView.h"
#import "YGJSelectView.h"

// mdoels
#import "YGJDocModel.h"
#import "YGJSerModel.h"
#import "CooperationModel.h"
#import "UserModel.h"

@interface HomeViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YGJSelectViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    YGJSelectView *_ygjSelectView;
}
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) QMUIButton *docButton;
@property (nonatomic, strong) UIView *topView;//顶部待办View
@property (nonatomic, strong) UILabel *daibanNumLabel;
@property (nonatomic, strong) UIView *topButtonView;//选择按钮view
@property (nonatomic, strong) JXYButton *seeAllStatusButton;
@property (nonatomic, strong) UIView *firstUnderLineView;
@property (nonatomic, strong) QMUIEmptyView *emptyView;
@property (nonatomic, assign) int tempType;
@property (nonatomic, assign) int serId;
@property (nonatomic, strong) NSMutableArray *selectedCodeArray;
@property (nonatomic, copy)   NSArray *faultTopButtonArray;//单据默认显示的按钮
@property (nonatomic, strong) NSArray *serRecordsArray;
@property (nonatomic, strong) NSMutableArray *myUpcomingArray;//按单据我的待办数组
@property (nonatomic, strong) UICollectionView *statusCollectionView;//顶部待办事项
@property (nonatomic, strong) UIView *midView;//中间 协作动态和我的表库
@property (nonatomic, strong) UITableView *allTableView;//协作动态列表
@property (nonatomic, strong) NSMutableArray *dataMutaArr;//协作动态列表数据数组
@property (nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property (nonatomic, strong) UserModel *userModel;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getUserInfoRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userModel = [YGJSQLITE_MANAGER getUserInfoModel];
    _tempType = -1;
    _serId = -1;
    [self updateLearnTime];
    self.myUpcomingArray = [NSMutableArray array];
    self.faultTopButtonArray = @[@"进仓单",@"出仓单",@"发货通知单",@"收货通知单", @"委托加工单",@"承揽加工通知单",@"派车通知单",@"委托派车单",@"付款凭证", @"收款凭证"];
    self.serRecordsArray = @[];
    [self createBar];
    [self createTopUI];
    [self createMidUI];
    [self setBigScrollViewContentSize];
}

#pragma mark - Network Methods
- (void)getUserInfoRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/users/getUsersInfoByToken" parameter:nil requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            UserModel *model = [UserModel modelWithDictionary:requestModel.result];
            [YGJSQLITE_MANAGER updateUserInfoModel:model];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:model.serTypes];
            if (arr.count > 0) {
                [YGJSQLITE_MANAGER clearLoginIdentity];
            }
            [YGJSQLITE_MANAGER updateLoginRequestIdentity:arr];
            if ([YGJSQLITE_MANAGER isShouldToAuthentication]) {
                [YGJCommonPopup showPopupStatus:YGJPopupStatusAuth complete:nil cancelHandler:nil];
                self.topView.hidden = YES;
                self.midView.hidden = YES;
                return;
            }
            self.topView.hidden = NO;
            self.midView.hidden = NO;
            [self processInstanceListRequest];
            [self myUpcomingListRequest];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];

}
- (void)processInstanceListRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/processInstance/work/events" parameter:@{@"pageNo":@"1",@"pageSize":@"5"} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            YDZYLog(@"---->协作动态");
            if ([self.dataMutaArr count] != 0) {
                [self.dataMutaArr removeAllObjects];
            }
            NSArray *arr = requestModel.result[@"records"];
            for (int i = 0; i < [arr count]; i ++) {
                [self.dataMutaArr addObject:[CooperationModel modelWithDictionary:arr[i]]];
            }
            [self.allTableView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}
//按单据筛选我的待办
- (void)myUpcomingListRequest{
    
    //0:付款凭证；1:进出仓单；2:加工单；3:派车通知单；4:收发货通知单；
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":@(1),@"pageSize":@"100"}];
    if (self.tempType >= 0) [paramDict jk_setObj:@(self.tempType) forKey:@"tempType"];
    if (self.serId >= 0) [paramDict jk_setObj:@(self.serId) forKey:@"beingSerId"];

    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/documents/backlog" parameter:paramDict requestType:UDARequestTypeGet isShowHUD:false progressBlock:^(CGFloat value) {
                
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            if (self.myUpcomingArray.count != 0) {
                [self.myUpcomingArray removeAllObjects];
            }
            YGJDocModel *model = [YGJDocModel modelWithDictionary:requestModel.result];
            self.daibanNumLabel.text = [NSString stringWithFormat:@"(%@)", @(model.total).stringValue];
            if ([model.records count] > 0) {
                [self.myUpcomingArray addObjectsFromArray:model.records];
                YGJDocItemModel *docModel = [self.myUpcomingArray firstObject];
                [YGJSQLITE_MANAGER updateEventId:docModel.eventId];
            }
            
            [self.statusCollectionView reloadData];
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}

#pragma mark - Intial Methods
- (void)createBar {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 44)];
    titleLabel.font = FONTSIZEBOLD(18);
    titleLabel.textColor = KWhiteColor;
    titleLabel.text = self.userModel.serName;
    titleLabel.textAlignment = 1;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10.0, 0.0, 44.0, 44.0);
    [rightButton addTarget:self action:@selector(rightButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"home_add"] forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:rightButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    JXYButton *leftButton = [[JXYButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44) withNomalTitle:YGJSQLITE_MANAGER.cityName withSelectTilel:@"" withFont:9 withImageNomal:@"adress_home" withImageSelected:@""];
    [leftButton setImagePosition:JXYUIButtonImagePositionTop spacing:3];
    [leftButton setTitleColor:CNavBgFontColor forState:UIControlStateNormal];
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    leftButton.enabled = false;
    [leftview addSubview:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftview];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)createTopUI {
    
    [self.view addSubview:self.bigScrollView];
    //待办view
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = KWhiteColor;
    [_bigScrollView addSubview:self.topView];
    
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
    
    self.daibanNumLabel = [[UILabel alloc] init];
    self.daibanNumLabel.frame = CGRectMake(daibanLabel.right, 8, 36, 27);
    self.daibanNumLabel.font = [UIFont fontWithName:@"PingFang-SC-Heavy" size:18];
    self.daibanNumLabel.textColor = [UIColor colorWithHexString:@"#FF4A4A"];
    [self.topView addSubview:self.daibanNumLabel];

    [self.topView addSubview:self.docButton];
    self.popupByWindow.sourceView = self.docButton;
    
    [self.topView addSubview:self.firstUnderLineView];
    self.firstUnderLineView.frame = CGRectMake(0, daibanImageview.bottom+8, kScreenWidth, 1);
    [self createTopButtonByButtonArr:self.faultTopButtonArray];
    
    [self.topView addSubview:self.statusCollectionView];
    self.statusCollectionView.frame = CGRectMake(0,self.topButtonView.bottom, kScreenWidth, 97);
    
    [self.topView addSubview:self.seeAllStatusButton];
    self.seeAllStatusButton.frame = CGRectMake((kScreenWidth-100)/2.0, self.statusCollectionView.bottom, 100, 20);
    
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, _seeAllStatusButton.bottom+10);

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
    _topButtonView.frame = CGRectMake(0, _firstUnderLineView.bottom+15, kScreenWidth, 40);

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
        [projectButton setTitleColor:CNavBgColor forState:UIControlStateNormal];
        [projectButton setTitleColor:KWhiteColor forState:UIControlStateSelected];
        [projectButton setBackgroundColor:UIColorMakeWithHex(@"#F1F6FF")];
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
- (void)createMidUI {
    [_bigScrollView addSubview:self.midView];
    _midView.frame = CGRectMake(0, self.topView.bottom+12, kScreenWidth, 55+351+38-60);

    NSArray *btnNameArr = [NSArray arrayWithObjects:@"协作动态",@"我的表库",nil];
    _ygjSelectView = [[YGJSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55) byButtonTitleNameArr:btnNameArr];
    _ygjSelectView.backgroundColor = [UIColor whiteColor];
    _ygjSelectView.delegate = self;
    _ygjSelectView.selectIndex = 1000;
    [self.midView addSubview:_ygjSelectView];
    [self.midView addSubview:self.allTableView];
    
    JXYButton *seeAllButton = [[JXYButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2.0, _allTableView.bottom+5, 100, 20) withNomalTitle:@"查看全部" withSelectTilel:@"" withFont:12 withImageNomal:@"seeAll_home" withImageSelected:@""];
    seeAllButton.titleLabel.textAlignment = 1;
    [seeAllButton setImagePosition:JXYUIButtonImagePositionRight spacing:5];
    [seeAllButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.midView addSubview:seeAllButton];
    [seeAllButton addTarget:self action:@selector(seeAllCooButtonMethod) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setBigScrollViewContentSize {
    
    _bigScrollView.contentSize = CGSizeMake(kScreenWidth, self.midView.bottom+19+20+64+44);
}
#pragma mark - YGJSelectViewDelegate
- (void)selectButtonItemClickedIndex:(UIButton *)sender
{
    [self changeButtonColorByTag:sender.tag];
    switch (sender.tag-1000) {
        case 0:
        {
            YDZYLog(@"SSSSS");
        }
            break;
        case 1:
        {
//            [YGJToast showToast:@"功能待开发"];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UICollectionViewDelegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self showHideAnAttempt:self.myUpcomingArray];
    return self.myUpcomingArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScale_W(145), kScale_W(75));
}
/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kScale_W(11), kScale_W(12), kScale_W(11), kScale_W(12));
}
/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kScale_W(9);
}
/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DocStatusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DocStatusCollectionViewCell className] forIndexPath:indexPath];
    [cell setupDocItemModel:self.myUpcomingArray[indexPath.row]];
    [cell setColorDoc];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YGJDocItemModel *model = self.myUpcomingArray[indexPath.row];
    [self.navigationController pushViewController:[[PreviewDocViewController alloc] initWithId:@(model.id).stringValue] animated:true];
}
#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataMutaArr.count == 0) {
        return 1;
    }
    return self.dataMutaArr.count > 5 ? 5 : self.dataMutaArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataMutaArr.count == 0) {
        return 290;
    }
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataMutaArr.count == 0) {
        
        XieZuoTaiNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XieZuoTaiNoDataTableViewCell className]];
        if (!cell) {
            
            cell = [[XieZuoTaiNoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XieZuoTaiNoDataTableViewCell className]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else {
        XieZuoDTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XieZuoDTTableViewCell className]];
        if (!cell) {
            cell = [[XieZuoDTTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XieZuoDTTableViewCell className]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CooperationModel *model = self.dataMutaArr[indexPath.row];
        [cell setUpCooperationModel:model];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.dataMutaArr count]) {
        return;
    }
//    XieZuoDTTableViewCell *cell = (XieZuoDTTableViewCell *)[self tableView:self.allTableView cellForRowAtIndexPath:indexPath];
//    cell.leftGreenView.hidden = YES;
    CooperationModel *model = self.dataMutaArr[indexPath.row];
    [self.navigationController pushViewController:[[PreviewDocViewController alloc] initWithId:@(model.id).stringValue] animated:true];
}

#pragma mark - Events
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
- (void)changeButtonColorByTag:(NSInteger)buttonTag {
    _ygjSelectView.selectIndex = buttonTag;
}

- (void)rightButtonOnClicked {
    
    if ([YGJSQLITE_MANAGER isShouldToAuthentication]) {
        
        [YGJCommonPopup showPopupStatus:YGJPopupStatusAuth complete:nil cancelHandler:nil];
        return;
    }
    AddNewDocViewController *vc = [[AddNewDocViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftButtonOnClicked {
    
    
}

- (void)changeDocButtonMethod:(UIButton *)btn {
    [self.popupByWindow showWithAnimated:true];
}

- (void)projectBtnClick:(UIButton *)sender {
    YDZYLog(@"--点击了-->%@",sender.titleLabel.text);
    [self changeTempType:sender.titleLabel.text];
}

- (void)seeAllButtonMethod {
    
    MineNeedToDoViewController *vc = [[MineNeedToDoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)seeAllCooButtonMethod {
    [self.navigationController pushViewController:[CooperationViewController new] animated:YES];
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
        [self myUpcomingListRequest];
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
                [self myUpcomingListRequest];
            }
        }
    } errorBlock:^(NSError * _Nullable error) {
    }];
}
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
    [self myUpcomingListRequest];
}
- (void)showHideAnAttempt:(NSArray *)array {
    if ([array count] == 0) {
        [self.statusCollectionView addSubview:self.emptyView];
    } else {
        [_emptyView removeFromSuperview];
    }
}

- (void)updateLearnTime {
    
    [self performSelector:@selector(settingupLearnTimeValue) withObject:nil afterDelay:20.0];
}
- (void)settingupLearnTimeValue {
    [self updateLearnTime];
    NSString *eventIdString = [YGJSQLITE_MANAGER getEventId];
    if ([NSString isBlankString:eventIdString]) {
        eventIdString = @"0";
    }
    @weakify(self);
    [UDAAPIRequest requestUrl:[NSString stringWithFormat:@"/app/documents/backlog/check/%@",eventIdString] parameter:@{} requestType:UDARequestTypeGet isShowHUD:NO progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            NSInteger count = [requestModel.result[@"count"] integerValue];
            if (count > 0) {
                self.tempType = -1;
                self.serId = -1;
                [self myUpcomingListRequest];
            }
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark – Getters and Setters
- (UIScrollView *)bigScrollView{
    
    if (!_bigScrollView) {
        
        _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight-kTabBarHeight)];
        _bigScrollView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _bigScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _bigScrollView;
}
- (QMUIPopupMenuView *)popupByWindow {
    if (!_popupByWindow) {
        _popupByWindow = [[QMUIPopupMenuView alloc] init];
        _popupByWindow.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _popupByWindow.tintColor = UIColorMakeWithHex(@"#333333");
        _popupByWindow.maskViewBackgroundColor = [UIColor clearColor];
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
            [self myUpcomingListRequest];
            
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

- (UITableView *)allTableView {
    
    if (!_allTableView) {
        
        _allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _ygjSelectView.bottom, KScreenWidth, 290) style:UITableViewStylePlain];
        _allTableView.dataSource = self;
        _allTableView.delegate = self;
        _allTableView.backgroundColor = KWhiteColor;
        _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _allTableView;
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
        _emptyView.verticalOffset = kScale_W(10.0);
    }
    return _emptyView;
}

- (UICollectionView *)statusCollectionView {
    
    if (!_statusCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _statusCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _statusCollectionView.backgroundColor = [UIColor whiteColor];
        _statusCollectionView.delegate = self;
        _statusCollectionView.dataSource = self;
        _statusCollectionView.showsHorizontalScrollIndicator = NO;
        _statusCollectionView.scrollsToTop = NO;
        [_statusCollectionView registerClass:[DocStatusCollectionViewCell class] forCellWithReuseIdentifier:[DocStatusCollectionViewCell className]];

    }
    return _statusCollectionView;
}

- (UIView *)midView {
    
    if (!_midView) {
        
        _midView = [[UIView alloc] init];
        _midView.backgroundColor = KWhiteColor;
    }
    
    return _midView;
}

- (UIView *)topButtonView {
    
    if (!_topButtonView) {
        
        _topButtonView = [[UIView alloc] init];
        _topButtonView.backgroundColor = KWhiteColor;
    }
    
    return _topButtonView;
}

- (JXYButton *)seeAllStatusButton {
    
    if (!_seeAllStatusButton) {
        
        _seeAllStatusButton = [[JXYButton alloc] initWithFrame:CGRectZero withNomalTitle:@"查看全部" withSelectTilel:@"" withFont:12 withImageNomal:@"seeAll_home" withImageSelected:@""];
        _seeAllStatusButton.titleLabel.textAlignment = 1;
        [_seeAllStatusButton setImagePosition:JXYUIButtonImagePositionRight spacing:5];
        [_seeAllStatusButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_seeAllStatusButton addTarget:self action:@selector(seeAllButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAllStatusButton;
}

- (UIView *)firstUnderLineView {
    
    if (!_firstUnderLineView) {
       
        _firstUnderLineView = [[UIView alloc] init];
        _firstUnderLineView.backgroundColor = UNDERLINECOLOR;
    }
    return _firstUnderLineView;
}

- (NSMutableArray *)selectedCodeArray {
    
    if (!_selectedCodeArray) {
     
        _selectedCodeArray = [NSMutableArray array];
    }
    return _selectedCodeArray;
}

- (NSMutableArray *)dataMutaArr {
    
    if (!_dataMutaArr) {
     
        _dataMutaArr = [NSMutableArray array];
    }
    return _dataMutaArr;
}

- (NSArray *)faultTopButtonArray {
    
    if (!_faultTopButtonArray) {
     
        _faultTopButtonArray = [NSArray array];
    }
    return _faultTopButtonArray;
}
@end
