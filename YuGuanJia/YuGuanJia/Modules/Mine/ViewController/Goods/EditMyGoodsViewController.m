//
//  EditMyGoodsViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/30.
//

#import "EditMyGoodsViewController.h"

//models
#import "GoodsInfoModel.h"

@interface EditMyGoodsViewController ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation EditMyGoodsViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    
    self.form = [EditMyGoodsForm formDescriptorWithTitle:@"商品内容"];

    [super viewDidLoad];
    [self initSubviews];
    [self loadData];
}
#pragma mark - Intial Methods
- (void)initSubviews {
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = CGFLOAT_MIN;
        self.tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
        self.tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        [self setAutomaticallyAdjustsScrollViewInsets:false];
    }
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_offset(kScale_W(60));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.bottomView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.bottomView);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).priorityLow();
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top).priorityLow();
    }];
    
}
#pragma mark - Network Methods
- (void)loadData {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/queryById" parameter:@{@"id": self.idStr} requestType:UDARequestTypeGet isShowHUD:YES progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            GoodsInfoModel *model = [GoodsInfoModel modelWithDictionary:requestModel.result];
            [(EditMyGoodsForm *)self.form initFormWithModel:model];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - Events
- (void)submitButtonEvent:(UIButton *)sender {
    
//    NSArray *topArr = self.formValues[EditMyGoodsTopSection];
//    NSArray *midArr = self.formValues[EditMyGoodsMiddleSection];
//    NSArray *bottomArr = self.formValues[EditMyGoodsBottomSection];
//
//    YDZYLog(@"---top----> %@",topArr);
//    YDZYLog(@"---mid----> %@",midArr);
//    YDZYLog(@"---bottom----> %@",bottomArr);
    
    
    XLFormRowDescriptor *kGoodsNameRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsName"];
    NSString *kGoodsName = kGoodsNameRowDescriptor.value;
    if ([NSString isBlankString:kGoodsName]) {
        [YGJToast showToast:@"请填写商品名称"];
        return;
    }

    XLFormRowDescriptor *kGoodsCoverRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsCover"];
    NSString *kGoodsCover = kGoodsCoverRowDescriptor.value;
    if ([NSString isBlankString:kGoodsCover]) {
        [YGJToast showToast:@"请添加商品封面"];
        return;
    }
    
    XLFormRowDescriptor *kAttributesRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsAttributes"];
    NSString *kAttributes = kAttributesRowDescriptor.value;
    if ([kAttributes isEqualToString:@"虚拟服务"]) {
        kAttributes = @"0";
    }else{
        kAttributes = @"1";
    }
    
    XLFormRowDescriptor *kIndustryTypeRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsIndustryType"];
    NSString *kIndustryType = kIndustryTypeRowDescriptor.value;
    if ([kIndustryType isEqualToString:@"选择类型"]) {
        [YGJToast showToast:@"请选择类型"];
        return;
    } else if ([kIndustryType isEqualToString:@"卷板"]) {
        kIndustryType = @"0";
    } else if ([kIndustryType isEqualToString:@"圆盘"]) {
        kIndustryType = @"1";
    } else if ([kIndustryType isEqualToString:@"电机"]) {
        kIndustryType = @"2";
    } else if ([kIndustryType isEqualToString:@"机械设备"]) {
        kIndustryType = @"3";
    } else if ([kIndustryType isEqualToString:@"铸件"]) {
        kIndustryType = @"4";
    } else if ([kIndustryType isEqualToString:@"平板"]) {
        kIndustryType = @"5";
    } else {
        kIndustryType = @"6";
    }
    
    XLFormRowDescriptor *kCarouselMapRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsCarouselMap"];
    NSArray *kCarouselMap = kCarouselMapRowDescriptor.value;
    if ([kCarouselMap count] == 0) {
        
        [YGJToast showToast:@"请添加商品轮播图片"];
        return;
    }
    //kGoodsModel
    XLFormRowDescriptor *kGoodsPriceRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsPrice"];
    NSString *kGoodsPrice = kGoodsPriceRowDescriptor.value;
    if ([NSString isBlankString:kGoodsPrice]) {
        [YGJToast showToast:@"请填写商品价格"];
        return;
    }
    
    XLFormRowDescriptor *kGoodsModelRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsModel"];
    NSString *kGoodsModel = kGoodsModelRowDescriptor.value;
    if ([NSString isBlankString:kGoodsModel]) {
        [YGJToast showToast:@"请填写商品型号"];
        return;
    }
    
    XLFormRowDescriptor *kGoodsParameterRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsParameter"];
    NSString *kGoodsParameter = kGoodsParameterRowDescriptor.value;
    if ([NSString isBlankString:kGoodsParameter]) {
        [YGJToast showToast:@"请填写商品参数"];
        return;
    }
    
    XLFormRowDescriptor *kGoodsNoteAppendedRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsNoteAppended"];
    NSString *kGoodsNoteAppended = kGoodsNoteAppendedRowDescriptor.value;
    
    XLFormRowDescriptor *kGoodsIntroduceImageRowDescriptor = [self.form formRowWithTag:@"kEditMyGoodsIntroduceImage"];
    NSArray *kGoodsIntroduceImage = kGoodsIntroduceImageRowDescriptor.value;
    if ([kGoodsIntroduceImage count] == 0) {
        
        [YGJToast showToast:@"请添加商品介绍图片"];
        return;
    }

    NSMutableArray *carouselMapArr = [NSMutableArray array];
    for (int i = 0; i < kCarouselMap.count; i ++) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:kCarouselMap[i],@"picUrl",@"0",@"picType", nil];
        [carouselMapArr addObject:dic];
        
    }
    NSMutableArray *goodsIntroduceImageArr = [NSMutableArray array];
    for (int i = 0; i < kGoodsIntroduceImage.count; i ++) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:kGoodsIntroduceImage[i],@"picUrl",@"1",@"picType", nil];
        [goodsIntroduceImageArr addObject:dic];
        
    }

    //提交用到的参数字典
    NSDictionary *goodsParamDict = [NSDictionary dictionaryWithObjectsAndKeys:kAttributes,@"goodAttr",kGoodsName,@"goodName",kGoodsParameter,@"goodPara",kGoodsCover,@"goodPic",kGoodsPrice,@"goodPrice",kIndustryType,@"industryType",carouselMapArr,@"carouselPics",goodsIntroduceImageArr,@"productPics",kGoodsNoteAppended,@"remark",kGoodsModel,@"goodType", nil];
            
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/add" parameter:goodsParamDict requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            [YGJToast showToast:@"提交成功"];
        }
        
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
        
    
    
}
#pragma mark - Public Methods

#pragma mark - Private Method

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)didSelectFormRow:(XLFormRowDescriptor *)formRow {
    [super didSelectFormRow:formRow];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kScale_W(15.0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

#pragma mark – Getters and Setters
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"确认修改" forState:UIControlStateNormal];
        _submitButton.backgroundColor = UIColorMakeWithHex(@"#4581EB");
        _submitButton.titleLabel.font = UIFontBoldMake(18);
        _submitButton.layer.cornerRadius = kScale_W(22.5);
        [_submitButton setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.enabled = NO;
    }
    return _submitButton;
}

@end
