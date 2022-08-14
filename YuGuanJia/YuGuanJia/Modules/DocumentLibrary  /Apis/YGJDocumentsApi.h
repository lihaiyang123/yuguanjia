//
//  YGJDocumentsApi.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/28.
//

#import <Foundation/Foundation.h>

typedef void(^YGJDataBlock)(UDAResponseDataModel *model);

@interface YGJDocumentsApi : NSObject

/// 单据表-通过id查询
+ (void)requestDocumentsQueryById:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 单据表-审批
+ (void)requestDocumentsApprove:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 单据表-取消
+ (void)requestDocumentsCancel:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 驳回创建、录入、确认
+ (void)requestDocumentsRejectTurndown:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 驳回修改
+ (void)requestDocumentsRejectModify:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 驳回取消
+ (void)requestDocumentsRejectCancel:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 单据表-确认
+ (void)requestDocumentsConfirm:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;
/// 单据表-确认新建
+ (void)requestDocumentsConfirmCreate:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 单据表-再次确认
+ (void)requestDocumentsConfirmAgian:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 单据表-修改 
+ (void)requestDocumentsModify:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;


/// 单据表-录入单据
+ (void)requestDocumentsEdit:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 单据表-添加
+ (void)requestDocumentsAdd:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

/// 模版
/// 单据模板表-通过id查询
+ (void)requestTemplatesQueryById:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;
/// 单据模板表-编辑模版
+ (void)requestTemplatesEdit:(NSDictionary *)params
                     success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;
/// 单据模板表-自定义模版
+ (void)requestTemplatesCustomSave:(NSDictionary *)params
                     success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;

///  导出
+ (void)requestExport:(BOOL)isTemplate id:(NSString *)idString success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler;
@end
