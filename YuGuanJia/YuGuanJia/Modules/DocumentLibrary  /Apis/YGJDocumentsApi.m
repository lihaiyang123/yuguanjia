//
//  YGJDocumentsApi.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/28.
//

#import "YGJDocumentsApi.h"

@implementation YGJDocumentsApi

#pragma mark - 单据
/// 查询单据表
+ (void)requestDocumentsQueryById:(NSDictionary *)params
                          success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    [YGJDocumentsApi commomGetRequestUrl:@"/app/documents/queryById" withParams:params isLoading:false success:successHandler error:errorHandler];
}

/// 审批
+ (void)requestDocumentsApprove:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    [YGJDocumentsApi commomPostRequestUrl:@"/app/documents/approve" withParams:params isLoading:false success:successHandler error:errorHandler];
}

/// 取消
+ (void)requestDocumentsCancel:(NSDictionary *)params
                       success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/cancel/%@",params[@"id"]] withParams:params isLoading:false success:successHandler error:errorHandler];
}

/// 驳回创建、录入、确认
+ (void)requestDocumentsRejectTurndown:(NSDictionary *)params
                         success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/reject/%@",params[@"id"]] withParams:params isLoading:true success:successHandler error:errorHandler];
}

/// 驳回修改
+ (void)requestDocumentsRejectModify:(NSDictionary *)params
                       success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/reject/modify/%@",params[@"id"]] withParams:params isLoading:true success:successHandler error:errorHandler];
}

/// 驳回取消
+ (void)requestDocumentsRejectCancel:(NSDictionary *)params
                       success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/reject/cancel/%@",params[@"id"]] withParams:params isLoading:true success:successHandler error:errorHandler];
}

/// 确认
+ (void)requestDocumentsConfirm:(NSDictionary *)params
                        success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/confirm/%@",params[@"id"]] withParams:params isLoading:true success:successHandler error:errorHandler];
}

/// 修改
+ (void)requestDocumentsModify:(NSDictionary *)params
                       success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/modify/%@",params[@"id"]] withParams:params isLoading:true success:successHandler error:errorHandler];
}

/// 录入单据
+ (void)requestDocumentsEdit:(NSDictionary *)params
                     success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/confirm/%@",params[@"id"]] withParams:params isLoading:true success:successHandler error:errorHandler];
}

/// 单据表-确认新建
+ (void)requestDocumentsConfirmCreate:(NSDictionary *)params
                              success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/create/%@",params[@"id"]] withParams:params isLoading:true success:successHandler error:errorHandler];
}

/// 单据表-再次确认
+ (void)requestDocumentsConfirmAgian:(NSDictionary *)params
                             success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/documents/confirm/%@",params[@"id"]] withParams:params isLoading:true success:successHandler error:errorHandler];
}


/// 创建
+ (void)requestDocumentsAdd:(NSDictionary *)params
                    success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    [YGJDocumentsApi commomPostRequestUrl:@"/app/documents/add" withParams:params isLoading:true success:successHandler error:errorHandler];
}

#pragma mark - 模版
/// 查询模版表
+ (void)requestTemplatesQueryById:(NSDictionary *)params
                          success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    [YGJDocumentsApi commomGetRequestUrl:@"/app/templates/queryById" withParams:params isLoading:false success:successHandler error:errorHandler];
}
/// 单据模板表-编辑模版
+ (void)requestTemplatesEdit:(NSDictionary *)params
                     success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/templates/edit/%@", params[@"id"]] withParams:params isLoading:false success:successHandler error:errorHandler];
}
/// 单据模板表-自定义模版
+ (void)requestTemplatesCustomSave:(NSDictionary *)params
                    success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [YGJDocumentsApi commomPutRequestUrl:[NSString stringWithFormat:@"/app/templates/custom/save/%@", params[@"id"]] withParams:params isLoading:false success:successHandler error:errorHandler];
}
///  导出
+ (void)requestExport:(BOOL)isTemplate id:(NSString *)idString success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    NSString *url = isTemplate ? @"/app/templates/export/" : @"/app/documents/export/";
    [YGJDocumentsApi commomGetRequestUrl:[NSString stringWithFormat:@"%@%@", url, idString] withParams:@{} isLoading:false success:successHandler error:errorHandler];
}

/// 公共请求方法Post
+ (void)commomPostRequestUrl:(NSString *)url withParams:(NSDictionary *)params isLoading:(BOOL)isLoading success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [UDAAPIRequest requestUrl:url parameter:params requestType:UDARequestTypePost isShowHUD:isLoading progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel *requestModel) {
        
        if (requestModel.success) {
            if (successHandler) successHandler(requestModel);
        } else {
            if (errorHandler) errorHandler();
        }
    } errorBlock:^(NSError * _Nullable error) {
        if (error) {
            if (errorHandler) errorHandler();
        }
    }];
}

/// 公共请求方法Get
+ (void)commomGetRequestUrl:(NSString *)url withParams:(NSDictionary *)params isLoading:(BOOL)isLoading success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [UDAAPIRequest requestUrl:url parameter:params requestType:UDARequestTypeGet isShowHUD:isLoading progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel *requestModel) {
        
        if (requestModel.success) {
            if (successHandler) successHandler(requestModel);
        } else {
            if (errorHandler) errorHandler();
        }
    } errorBlock:^(NSError * _Nullable error) {
        if (error) {
            if (errorHandler) errorHandler();
        }
    }];
}

/// 公共方法put
+ (void)commomPutRequestUrl:(NSString *)url withParams:(NSDictionary *)params isLoading:(BOOL)isLoading success:(YGJDataBlock)successHandler error:(CDBlock)errorHandler {
    
    [UDAAPIRequest requestUrl:url parameter:params requestType:UDARequestTypePut isShowHUD:isLoading progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel *requestModel) {
        
        if (requestModel.success) {
            if (successHandler) successHandler(requestModel);
        } else {
            if (errorHandler) errorHandler();
        }
    } errorBlock:^(NSError * _Nullable error) {
        if (error) {
            if (errorHandler) errorHandler();
        }
    }];
}
@end
