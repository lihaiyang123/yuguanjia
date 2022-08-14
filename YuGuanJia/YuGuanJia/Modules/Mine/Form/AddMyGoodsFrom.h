//
//  AddMyGoodsFrom.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/17.
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

NS_ASSUME_NONNULL_BEGIN

extern NSString * const EditShopTopSection;
extern NSString * const EditShopMiddleSection;
extern NSString * const EditShopBottomSection;

@interface AddMyGoodsFrom : XLFormDescriptor

- (void)initFormWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
