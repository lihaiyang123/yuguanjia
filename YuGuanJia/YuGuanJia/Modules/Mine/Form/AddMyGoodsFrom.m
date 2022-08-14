//
//  AddMyGoodsFrom.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/17.
//

#import "AddMyGoodsFrom.h"

//商品名称、封面、属性、行业类型、轮播图
NSString * const EditShopTopSection = @"EditShopTopSection";
//商品价格、型号、参数、附注
NSString * const EditShopMiddleSection = @"EditShopMiddleSection";
//商品介绍图
NSString * const EditShopBottomSection = @"EditShopBottomSection";

//商品名称
NSString *const kGoodsName = @"kGoodsName";
//封面图片
NSString *const kGoodsCover = @"kGoodsCover";
//商品属性
NSString *const kAttributes = @"kAttributes";
//行业类型
NSString *const kIndustryType = @"kIndustryType";
//轮播图
NSString *const kCarouselMap = @"kCarouselMap";
//商品价格
NSString *const kGoodsPrice = @"kGoodsPrice";
//商品型号
NSString *const kGoodsModel = @"kGoodsModel";
//商品参数
NSString *const kGoodsParameter = @"kGoodsParameter";
//商品附注
NSString *const kGoodsNoteAppended = @"kGoodsNoteAppended";
//商品介绍图
NSString *const kGoodsIntroduceImage = @"kGoodsIntroduceImage";


@interface AddMyGoodsFrom ()

@property (nonatomic, weak) XLFormSectionDescriptor *sectionDescriptor;
@property (nonatomic, weak) XLFormRowDescriptor * rowDescriptor;


@end

@implementation AddMyGoodsFrom

- (void)initializeForm {
    
    
}

- (void)initFormWithModel:(id)model {
    
    XLFormSectionDescriptor *topSection = [XLFormSectionDescriptor formSection];
    topSection.multivaluedTag = EditShopTopSection;
    XLFormRowDescriptor * row;
    //商品名称
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoodsName rowType:XLFormRowDescriptorTypeText title:@"商品名称"];
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = @"";
    [topSection addFormRow:row];
    
    
    //图片
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"添加商品封面图片（1张）："];
    row.cellClass = [EditDetailSeizeASeatCell class];
    row.required = YES;
    [topSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoodsCover rowType:XLFormRowDescriptorTypeImage title:@""];
    row.cellClass = [EditDetailSeletedImageCell class];
    [topSection addFormRow:row];
    
    //商品属性
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAttributes rowType:XLFormRowDescriptorTypeText title:@"商品属性"];
    row.cellClass = [AddCommodityAttributesCell class];
    YDZYLog(@"--->>> %@",row.value);
    [topSection addFormRow:row];

    //商品行业类型
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kIndustryType rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:@"商品行业类型："];
    row.cellClass = [EditDetailInlineSelectorCell class];
    row.required = YES;
    row.selectorOptions = @[@"选择类型", @"卷板", @"圆盘", @"电机", @"机械设备", @"铸件",@"平板",@"电机铁芯"];
    row.value = @"选择类型";
    [topSection addFormRow:row];
    
    //添加商品轮播图图片（1~5张）：
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"添加商品轮播图图片（1~5张）："];
    row.cellClass = [EditDetailSeizeASeatCell class];
    row.required = YES;
    [topSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCarouselMap rowType:XLFormRowDescriptorTypeImage title:@""];

    row.cellClass = [AddCommodityCarouselMapCell class];
    [topSection addFormRow:row];
    [self addFormSection:topSection];
    
    //中间信息部分
    //商品价格
    XLFormSectionDescriptor *midSection = [XLFormSectionDescriptor formSection];
    midSection.multivaluedTag = EditShopMiddleSection;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoodsPrice rowType:XLFormRowDescriptorTypeText title:@"商品价格"];
    row.cellClass = [AddCommodityPriceCell class];
    [midSection addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoodsModel rowType:XLFormRowDescriptorTypeText title:@"商品型号"];
    row.cellClass = [EditDetailTextFieldCell class];
    [midSection addFormRow:row];

    
    //商品参数
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoodsParameter rowType:XLFormRowDescriptorTypeText title:@"商品参数"];
    row.cellClass = [EditDetailTextFieldCell class];
    [midSection addFormRow:row];
    
    //商品附注
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"商品附注："];
    row.cellClass = [EditDetailSeizeASeatCell class];
    row.required = NO;
    [midSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoodsNoteAppended rowType:XLFormRowDescriptorTypeTextView title:@""];
    row.cellClass = [EditDetailTextViewCell class];
    [midSection addFormRow:row];

    [self addFormSection:midSection];
    
    //底部
    XLFormSectionDescriptor *bottomSection = [XLFormSectionDescriptor formSection];
    bottomSection.multivaluedTag = EditShopBottomSection;

    //添加商品介绍图图片（1~8张）：
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"添加商品介绍图片（1~8张）："];
    row.cellClass = [EditDetailSeizeASeatCell class];
    row.required = YES;
    [bottomSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kGoodsIntroduceImage rowType:XLFormRowDescriptorTypeImage title:@""];

    row.cellClass = [AddCommodityIntroduceImageCell class];
    [bottomSection addFormRow:row];
    [self addFormSection:bottomSection];


}

- (void)setupSection:(XLFormSectionDescriptor *)sectionDescriptor
   withRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    self.sectionDescriptor = sectionDescriptor;
    self.rowDescriptor = rowDescriptor;
}



@end
