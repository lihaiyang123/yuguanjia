//
//  EditDetailForm.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/3.
//

#import "EditDetailForm.h"

// 标题
NSString * const EditDetailNameSection = @"EditDetailNameSection";

// 合同
NSString * const EditDetailCompactSection = @"EditDetailCompactSection";

//合同说明
NSString * const EditDetailCompactDescriptionSection = @"EditDetailCompactDescriptionSection";

//合同附件
NSString * const EditDetailCompactEnclosureSection = @"EditDetailCompactEnclosureSection";

//图片
NSString * const EditDetailImageSection = @"EditDetailImageSection";

//签订时间
NSString * const EditDetailSigningTimeSection = @"EditDetailSigningTimeSection";

//审批流程
NSString * const EditDetailApprovalProcessSection = @"EditDetailApprovalProcessSection";




@interface EditDetailForm()

@property (nonatomic, weak) XLFormSectionDescriptor *sectionDescriptor;
@property (nonatomic, weak) XLFormRowDescriptor * rowDescriptor;

@end

@implementation EditDetailForm

- (void)initializeForm {
    
    // 动态添加
//    XLFormRowDescriptor *photoRow = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypePhoto title:nil];
//    [self.sectionDescriptor addFormRow:photoRow afterRow:self.rowDescriptor];
}

- (void)initFormWithModel:(id)model {
    
    XLFormSectionDescriptor *nameSection = [XLFormSectionDescriptor formSection];
    nameSection.multivaluedTag = EditDetailNameSection;
    XLFormRowDescriptor * row;
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"客户名称"];
//    row.tag
    row.noValueDisplayText = @"上海定国钢材加工有限公司(示例)";
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = @"";
    //    row.value = @{
    //                  };
    [nameSection addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"联系人"];
    row.noValueDisplayText = @"陈德明（示例）";
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = @"";
    [nameSection addFormRow:row];
    [self addFormSection:nameSection];
    
    
    XLFormSectionDescriptor *compactSection = [XLFormSectionDescriptor formSection];
    compactSection.multivaluedTag = EditDetailCompactSection;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"合同名称"];
    row.noValueDisplayText = @"年付服务框架合同（示例）";
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = @"";
    [compactSection addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"合同编号"];
    row.noValueDisplayText = @"dfdsf4715545445（示例）";
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = @"";
    [compactSection addFormRow:row];
    
    // 合同类型
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPickerView title:@"合同类型"];
    row.cellClass = [EditDetailContractTypeCell class];
    row.noValueDisplayText = @"请选择";
    NSArray *valueArray = @[@"1", @"2", @"3", @"4"];
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [valueArray count]; i++) {
        NSString *name = valueArray[i];
        [arrayM addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(i) displayText:name]];
    }
    row.selectorOptions = arrayM;
//    row.value = [arrayM firstObject];
    [compactSection addFormRow:row];
    
    // 合同开始时间
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeDate title:@"合同开始时间"];
    row.cellClass = [EditDetailDateFormCell class];
//    [row.cellConfigAtConfigure setObject:[NSDate new] forKey:@"minimumDate"];
//    [row.cellConfigAtConfigure setObject:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*3)] forKey:@"maximumDate"];
    [row.cellConfigAtConfigure setObject:[NSLocale localeWithLocaleIdentifier:@"zh_CN" ] forKey:@"locale"];
    row.value = [NSDate new];
    [compactSection addFormRow:row];
    
    // 合同结束时间
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeDate title:@"合同结束时间"];
    row.cellClass = [EditDetailDateFormCell class];
    [row.cellConfigAtConfigure setObject:[NSLocale localeWithLocaleIdentifier:@"zh_CN" ] forKey:@"locale"];
    row.value = [NSDate new];
    [compactSection addFormRow:row];

    [self addFormSection:compactSection];
    
    // 合同金额
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPickerView title:@"合同金额"];
    row.cellClass = [EditDetailContractTypeCell class];
    row.noValueDisplayText = @"请选择";
    NSArray *moenyArray = @[@"1000", @"20000", @"30000", @"400000"];
    NSMutableArray *moneyArrayM = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [moenyArray count]; i++) {
        NSString *name = moenyArray[i];
        [moneyArrayM addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(i) displayText:name]];
    }
    row.selectorOptions = moneyArrayM;
//    row.value = [arrayM firstObject];
    [compactSection addFormRow:row];
    
    //合同说明
    XLFormSectionDescriptor *compactDescriptionSection = [XLFormSectionDescriptor formSection];
    compactDescriptionSection.multivaluedTag = EditDetailCompactDescriptionSection;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"合同说明"];
    row.cellClass = [EditDetailSeizeASeatCell class];
    [compactDescriptionSection addFormRow:row];

    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeTextView title:@""];
    row.noValueDisplayText = @"合作自签订之日起生效";
    row.cellClass = [EditDetailTextViewCell class];
    [compactDescriptionSection addFormRow:row];

    [self addFormSection:compactDescriptionSection];
    
    //合同附件
    XLFormSectionDescriptor *compactEnclosureSection = [XLFormSectionDescriptor formSection];
    compactEnclosureSection.multivaluedTag = EditDetailCompactEnclosureSection;

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"合同附件"];
    row.cellClass = [EditDetailSeizeASeatCell class];
    [compactEnclosureSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeImage title:@""];

    row.cellClass = [EditDetailSeletedImageCell class];
    [compactEnclosureSection addFormRow:row];

    [self addFormSection:compactEnclosureSection];
    
    
    //图片
    XLFormSectionDescriptor *imageSection = [XLFormSectionDescriptor formSection];
    imageSection.multivaluedTag = EditDetailImageSection;

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"图片"];
    row.cellClass = [EditDetailSeizeASeatCell class];
    [imageSection addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeImage title:@""];

    row.cellClass = [EditDetailSeletedImageCell class];
    [imageSection addFormRow:row];

    [self addFormSection:imageSection];


    //签订时间
    XLFormSectionDescriptor *signingTimeSection = [XLFormSectionDescriptor formSection];
    signingTimeSection.multivaluedTag = EditDetailSigningTimeSection;
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeDate title:@"签订时间"];
    row.cellClass = [EditDetailNotRequiredCell class];
    [row.cellConfigAtConfigure setObject:[NSLocale localeWithLocaleIdentifier:@"zh_CN" ] forKey:@"locale"];
    row.value = [NSDate new];
    [signingTimeSection addFormRow:row];
    [self addFormSection:signingTimeSection];
    
    //我方负责人
    XLFormSectionDescriptor *personInChargeSection = [XLFormSectionDescriptor formSection];
    personInChargeSection.multivaluedTag = EditDetailNameSection;
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"我方负责人"];
    row.noValueDisplayText = @"刘华";
    row.cellClass = [EditDetailTextFieldCell class];
    row.value = @"";
    [personInChargeSection addFormRow:row];
    [self addFormSection:personInChargeSection];


    //审批流程
    XLFormSectionDescriptor *approvalProcessSection = [XLFormSectionDescriptor formSection];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:@"审批流程"];
    row.cellClass = [EditDetailInlineSelectorCell class];
    row.selectorOptions = @[@"我的流程1", @"我的流程2", @"我的流程3", @"我的流程4", @"我的流程5", @"我的流程6"];
//    row.selectorTitle = @"我的流程6";
    row.value = @"我的流程6";
    [approvalProcessSection addFormRow:row];
    [self addFormSection:approvalProcessSection];

}

- (void)setupSection:(XLFormSectionDescriptor *)sectionDescriptor
   withRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    self.sectionDescriptor = sectionDescriptor;
    self.rowDescriptor = rowDescriptor;
}

@end
