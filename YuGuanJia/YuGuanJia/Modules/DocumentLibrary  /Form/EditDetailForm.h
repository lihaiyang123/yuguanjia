//
//  EditDetailForm.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/3.
//

#import <XLForm/XLForm.h>

//cell
#import "EditDetailTextFieldCell.h"
#import "EditDetailDateFormCell.h"
#import "EditDetailContractTypeCell.h"
#import "EditDetailTextViewCell.h"
#import "EditDetailSeizeASeatCell.h"
#import "EditDetailNotRequiredCell.h"
#import "EditDetailInlineSelectorCell.h"
#import "EditDetailSeletedImageCell.h"

//models


NS_ASSUME_NONNULL_BEGIN

extern NSString * const EditDetailNameSection;

extern NSString * const EditDetailCompactSection;

extern NSString * const EditDetailCompactDescriptionSection;

extern NSString * const EditDetailCompactEnclosureSection;

extern NSString * const EditDetailSigningTimeSection;

extern NSString * const EditDetailApprovalProcessSection;

extern NSString * const EditDetailImageSection;





@interface EditDetailForm : XLFormDescriptor


- (void)initFormWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
