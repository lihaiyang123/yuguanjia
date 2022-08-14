//
//  AddMyGoodsViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/17.
//

#import "AddMyGoodsViewController.h"
#import "GoodsDetailViewController.h"

@interface AddMyGoodsViewController ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *submitButton;//提交
@property (nonatomic, strong) UIButton *previewButton;//预览


@end

@implementation AddMyGoodsViewController

- (void)viewDidLoad {
    
    self.form = [AddMyGoodsFrom formDescriptorWithTitle:@"商品内容-新建"];
    [(AddMyGoodsFrom *)self.form initFormWithModel:@""];

    [super viewDidLoad];
    [self initSubviews];

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
    
    [self.bottomView addSubview:self.previewButton];
    [self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).mas_offset(kScale_W(14.5));
        make.top.equalTo(self.bottomView).mas_offset(kScale_W(7.5));
        make.width.mas_offset(kScale_W(165.5));
        make.height.mas_offset(kScale_W(45.5));
    }];

    [self.bottomView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.previewButton.mas_right).offset(kScale_W(14.5));
        make.top.equalTo(self.bottomView).mas_offset(kScale_W(7.5));
        make.width.mas_offset(kScale_W(165.5));
        make.height.mas_offset(kScale_W(45.5));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).priorityLow();
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top).priorityLow();
    }];
}

- (void)changeBottomButtonByLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle colorHex:(NSString *)colorHex {
    
    [_previewButton setTitle:@"被拒绝" forState:UIControlStateNormal];
    _previewButton.layer.borderColor = UIColorMakeWithHex(@"#FF1F44").CGColor;
    [_previewButton setTitleColor:UIColorMakeWithHex(@"#FF1F44") forState:UIControlStateNormal];

}

#pragma mark - Target Methods

- (void)previewButtonEvent:(UIButton *)sender {
    
    [self getDictDataByType:@"0"];
}

- (void)submitButtonEvent:(UIButton *)sender {
    
    [self getDictDataByType:@"1"];
    
}

//type = 0 预览  type = 1 提交
- (void)getDictDataByType:(NSString *)type {
    
    XLFormRowDescriptor *kGoodsNameRowDescriptor = [self.form formRowWithTag:@"kGoodsName"];
    NSString *kGoodsName = kGoodsNameRowDescriptor.value;
    if ([NSString isBlankString:kGoodsName]) {
        [YGJToast showToast:@"请填写商品名称"];
        return;
    }

    XLFormRowDescriptor *kGoodsCoverRowDescriptor = [self.form formRowWithTag:@"kGoodsCover"];
    NSString *kGoodsCover = kGoodsCoverRowDescriptor.value;
    if ([NSString isBlankString:kGoodsCover]) {
        [YGJToast showToast:@"请添加商品封面"];
        return;
    }
    
    XLFormRowDescriptor *kAttributesRowDescriptor = [self.form formRowWithTag:@"kAttributes"];
    NSString *kAttributes = kAttributesRowDescriptor.value;
    if ([kAttributes isEqualToString:@"虚拟服务"]) {
        kAttributes = @"0";
    }else{
        kAttributes = @"1";
    }
    
    XLFormRowDescriptor *kIndustryTypeRowDescriptor = [self.form formRowWithTag:@"kIndustryType"];
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
    
    XLFormRowDescriptor *kCarouselMapRowDescriptor = [self.form formRowWithTag:@"kCarouselMap"];
    NSArray *kCarouselMap = kCarouselMapRowDescriptor.value;
    if ([kCarouselMap count] == 0) {
        
        [YGJToast showToast:@"请添加商品轮播图片"];
        return;
    }
    //kGoodsModel
    XLFormRowDescriptor *kGoodsPriceRowDescriptor = [self.form formRowWithTag:@"kGoodsPrice"];
    NSString *kGoodsPrice = kGoodsPriceRowDescriptor.value;
    if ([NSString isBlankString:kGoodsPrice]) {
        [YGJToast showToast:@"请填写商品价格"];
        return;
    }
    
    XLFormRowDescriptor *kGoodsModelRowDescriptor = [self.form formRowWithTag:@"kGoodsModel"];
    NSString *kGoodsModel = kGoodsModelRowDescriptor.value;
    if ([NSString isBlankString:kGoodsModel]) {
        [YGJToast showToast:@"请填写商品型号"];
        return;
    }
    
    XLFormRowDescriptor *kGoodsParameterRowDescriptor = [self.form formRowWithTag:@"kGoodsParameter"];
    NSString *kGoodsParameter = kGoodsParameterRowDescriptor.value;
    if ([NSString isBlankString:kGoodsParameter]) {
        [YGJToast showToast:@"请填写商品参数"];
        return;
    }
    
    XLFormRowDescriptor *kGoodsNoteAppendedRowDescriptor = [self.form formRowWithTag:@"kGoodsNoteAppended"];
    NSString *kGoodsNoteAppended = kGoodsNoteAppendedRowDescriptor.value;
    
    XLFormRowDescriptor *kGoodsIntroduceImageRowDescriptor = [self.form formRowWithTag:@"kGoodsIntroduceImage"];
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
    
    //预览用到的参数字典
    NSMutableArray *goodsPicsListArr = [NSMutableArray arrayWithArray:carouselMapArr];
    [goodsPicsListArr addObjectsFromArray:goodsIntroduceImageArr];
    
    NSDictionary *goodsVoDict = [NSDictionary dictionaryWithObjectsAndKeys:kAttributes,@"goodAttr",kGoodsName,@"goodName",kGoodsParameter,@"goodPara",kGoodsCover,@"goodPic",kGoodsPrice,@"goodPrice",kIndustryType,@"industryType",kGoodsNoteAppended,@"remark",kGoodsModel,@"goodType", nil];
    
    NSDictionary *previewDict = [NSDictionary dictionaryWithObjectsAndKeys:goodsPicsListArr,@"goodsPicsList",goodsVoDict,@"goodsVo", nil];
    
    if ([type isEqualToString:@"1"]) {
        
        @weakify(self);
        [UDAAPIRequest requestUrl:@"/app/goods/add" parameter:goodsParamDict requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
            
        } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
            
            @strongify(self);
            if (requestModel.success) {
                
                [YGJToast showToast:@"提交成功"];
            }
            
        } errorBlock:^(NSError * _Nullable error) {
            
        }];
        
    }else {
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
        vc.dataDic = previewDict;
        vc.isPreview = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

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

#pragma mark - Setter Getter Methods
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        _previewButton.backgroundColor = KWhiteColor;
        _previewButton.titleLabel.font = UIFontBoldMake(18);
        _previewButton.layer.cornerRadius = kScale_W(22.5);
        _previewButton.layer.borderColor = UIColorMakeWithHex(@"#4581EB").CGColor;
        _previewButton.layer.borderWidth = kScale_W(0.5);
        [_previewButton setTitleColor:UIColorMakeWithHex(@"#4581EB") forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(previewButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewButton;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.backgroundColor = UIColorMakeWithHex(@"#4581EB");
        _submitButton.titleLabel.font = UIFontBoldMake(18);
        _submitButton.layer.cornerRadius = kScale_W(22.5);
        [_submitButton setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
