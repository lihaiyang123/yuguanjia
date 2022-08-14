//
//  YGJEnum.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/30.
//

#ifndef YGJEnum_h
#define YGJEnum_h

// 商品状态
typedef NS_ENUM(NSInteger, YGJGoodsStatus) {
    
    YGJGoodsStatusUnderReview                = 0,//审核中
    YGJGoodsStatusApproved                   = 1,//审核通过
    YGJGoodsStatusRejected                   = 2,//被拒绝
    YGJGoodsStatusOnTheShelf                 = 3,//上架中
    YGJGoodsStatusRemoved                    = 4,//已下架
};

#endif /* YGJEnum_h */
