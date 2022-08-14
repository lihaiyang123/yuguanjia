//
//  EditMyGoodsForm.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/30.
//

#import "EditMyGoodsForm.h"

//商品名称、封面、属性、行业类型、轮播图
NSString * const EditMyGoodsTopSection = @"EditMyGoodsTopSection";
//商品价格、型号、参数、附注
NSString * const EditMyGoodsMiddleSection = @"EditMyGoodsMiddleSection";
//商品介绍图
NSString * const EditMyGoodsBottomSection = @"EditMyGoodsBottomSection";

//商品名称
NSString *const kEditMyGoodsName = @"kEditMyGoodsName";
//封面图片
NSString *const kEditMyGoodsCover = @"kEditMyGoodsCover";
//商品属性
NSString *const kEditMyGoodsAttributes = @"kEditMyGoodsAttributes";
//行业类型
NSString *const kEditMyGoodsIndustryType = @"kEditMyGoodsIndustryType";
//轮播图
NSString *const kEditMyGoodsCarouselMap = @"kEditMyGoodsCarouselMap";
//商品价格
NSString *const kEditMyGoodsPrice = @"kEditMyGoodsPrice";
//商品型号
NSString *const kEditMyGoodsModel = @"kEditMyGoodsModel";
//商品参数
NSString *const kEditMyGoodsParameter = @"kEditMyGoodsParameter";
//商品附注
NSString *const kEditMyGoodsNoteAppended = @"kEditMyGoodsNoteAppended";
//商品介绍图
NSString *const kEditMyGoodsIntroduceImage = @"kEditMyGoodsIntroduceImage";


@interface EditMyGoodsForm ()

@property (nonatomic, weak) XLFormSectionDescriptor *sectionDescriptor;
@property (nonatomic, weak) XLFormRowDescriptor * rowDescriptor;


@end

@implementation EditMyGoodsForm

- (void)initializeForm {
    
    
}

- (void)initFormWithModel:(id)model {
    
    GoodsInfoModel *goodsModel = (GoodsInfoModel *)model;
    XLFormSectionDescriptor *topSection = [XLFormSectionDescriptor formSection];
    topSection.multivaluedTag = EditMyGoodsTopSection;
    XLFormRowDescriptor * row;
    //商品名称
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsName rowType:XLFormRowDescriptorTypeText title:@"商品名称"];
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = [NSString stringWithFormat:@"%ld",goodsModel.goodsVo.goodName];
    [topSection addFormRow:row];
    
    
    //图片
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"添加商品封面图片（1张）："];
    row.cellClass = [EditDetailSeizeASeatCell class];
    row.required = YES;
    [topSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsCover rowType:XLFormRowDescriptorTypeImage title:@""];
    row.cellClass = [EditDetailSeletedImageCell class];
    row.value = goodsModel.goodsVo.goodPic;
    [topSection addFormRow:row];
    
    //商品属性
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsAttributes rowType:XLFormRowDescriptorTypeText title:@"商品属性"];
    row.cellClass = [AddCommodityAttributesCell class];
    row.value = [NSString stringWithFormat:@"%ld",goodsModel.goodsVo.goodAttr];
    [topSection addFormRow:row];

    //商品行业类型
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsIndustryType rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:@"商品行业类型："];
    row.cellClass = [EditDetailInlineSelectorCell class];
    row.required = YES;
//    0:卷板1:盘圆2:电机3:机械设备4:铸件5:平板6:电机铁芯
    NSArray *arr = @[@"卷板", @"圆盘", @"电机", @"机械设备", @"铸件",@"平板",@"电机铁芯"];
    row.selectorOptions = arr;
    NSString *industryTypeString = nil;
    if (goodsModel.goodsVo.industryType == 0) {
        industryTypeString = @"卷板";
    } else if (goodsModel.goodsVo.industryType == 1) {
        industryTypeString = @"圆盘";
    } else if (goodsModel.goodsVo.industryType == 2) {
        industryTypeString = @"电机";
    } else if (goodsModel.goodsVo.industryType == 3) {
        industryTypeString = @"机械设备";
    } else if (goodsModel.goodsVo.industryType == 4) {
        industryTypeString = @"铸件";
    } else if (goodsModel.goodsVo.industryType == 5) {
        industryTypeString = @"平板";
    } else {
        industryTypeString = @"机械设备";
    }
    row.value = industryTypeString;
    [topSection addFormRow:row];
    
    //添加商品轮播图图片（1~5张）：
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"添加商品轮播图图片（1~5张）："];
    row.cellClass = [EditDetailSeizeASeatCell class];
    row.required = YES;
    [topSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsCarouselMap rowType:XLFormRowDescriptorTypeImage title:@""];
    row.cellClass = [AddCommodityCarouselMapCell class];
    row.value = goodsModel.goodsPicsList;
    [topSection addFormRow:row];
    [self addFormSection:topSection];
    
    //中间信息部分
    //商品价格
    XLFormSectionDescriptor *midSection = [XLFormSectionDescriptor formSection];
    midSection.multivaluedTag = EditMyGoodsMiddleSection;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsPrice rowType:XLFormRowDescriptorTypeText title:@"商品价格"];
    row.cellClass = [AddCommodityPriceCell class];
    row.value = [NSString stringWithFormat:@"%ld",goodsModel.goodsVo.goodPrice];
    [midSection addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsModel rowType:XLFormRowDescriptorTypeText title:@"商品型号"];
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = [NSString stringWithFormat:@"%ld",goodsModel.goodsVo.goodType];
    [midSection addFormRow:row];

    
    //商品参数
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsParameter rowType:XLFormRowDescriptorTypeText title:@"商品参数"];
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = [NSString stringWithFormat:@"%ld",goodsModel.goodsVo.goodPara];
    [midSection addFormRow:row];
    
    //商品附注
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"商品附注："];
    row.cellClass = [EditDetailSeizeASeatCell class];
    row.required = NO;
    [midSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsNoteAppended rowType:XLFormRowDescriptorTypeTextView title:@""];
    row.cellClass = [EditDetailTextViewCell class];
    row.value = goodsModel.goodsVo.remark;
    [midSection addFormRow:row];

    [self addFormSection:midSection];
    
    //底部
    XLFormSectionDescriptor *bottomSection = [XLFormSectionDescriptor formSection];
    bottomSection.multivaluedTag = EditMyGoodsBottomSection;

    //添加商品介绍图图片（1~8张）：
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"添加商品介绍图片（1~8张）："];
    row.cellClass = [EditDetailSeizeASeatCell class];
    row.required = YES;
    [bottomSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditMyGoodsIntroduceImage rowType:XLFormRowDescriptorTypeImage title:@""];
    row.cellClass = [AddCommodityIntroduceImageCell class];
    row.value = goodsModel.goodsPicsList;
    [bottomSection addFormRow:row];
    [self addFormSection:bottomSection];

}

- (void)setupSection:(XLFormSectionDescriptor *)sectionDescriptor
   withRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    self.sectionDescriptor = sectionDescriptor;
    self.rowDescriptor = rowDescriptor;
}

@end
