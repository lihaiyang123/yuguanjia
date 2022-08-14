//
//  UnderReviewGoodsForm.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/30.
//

#import <XLForm/XLForm.h>

//cell
#import "EditDetailTextFieldCell.h"
#import "EditDetailSeizeASeatCell.h"
#import "EditDetailSeletedImageCell.h"
#import "AddCommodityAttributesCell.h"
#import "EditDetailInlineSelectorCell.h"
#import "AddCommodityPriceCell.h"
#import "EditDetailTextViewCell.h"
#import "AddCommodityCarouselMapCell.h"
#import "AddCommodityIntroduceImageCell.h"

//models
#import "GoodsInfoModel.h"


NS_ASSUME_NONNULL_BEGIN
extern NSString * const EditMyGoodsTopSection;
extern NSString * const EditMyGoodsMiddleSection;
extern NSString * const EditMyGoodsBottomSection;


@interface EditMyGoodsForm : XLFormDescriptor

- (void)initFormWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
