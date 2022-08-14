//
//  YGJCommonPopup.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/28.
//

#import <Foundation/Foundation.h>


typedef void(^YGJPopupBlock)(void);

typedef NS_ENUM (NSInteger, YGJPopupStatus) {

	YGJPopupStatusLogin        = 0,//  去登录
	YGJPopupStatusAuth         = 1,//  认证
};

@interface YGJCommonPopup : NSObject

+ (void)showPopupStatus:(YGJPopupStatus)popupStatus complete:(YGJPopupBlock)completeHandler cancelHandler:(YGJPopupBlock)cancelHandler;
@end

