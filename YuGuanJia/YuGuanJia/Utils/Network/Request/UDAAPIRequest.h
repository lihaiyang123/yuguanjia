//
//  UDAAPIRequest.h
//  uda-mail-ios
//
//  Created by 刘权 on 2019/8/26.
//  Copyright © 2019 YunDa. All rights reserved.
//

#import "UDARequestRoute.h"
// model
#import "UDAResponseDataModel.h"

// api
#import "UDANetworkAPI.h"


/** NET SUCCESS */
typedef void (^completeBlock_success)(UDAResponseDataModel * _Nonnull requestModel);
/** NEI ERROR */
typedef void (^errorBlock_fail)(NSError * _Nullable error);
/** LOADING PREGRESS */
typedef void (^progressBlock)(CGFloat value);
#ifndef kIsNetwork
#define kIsNetwork     [UDAAPIRequest isNetwork]  // 判断是否有网
#endif

#ifndef kIsWWANNetwork
#define kIsWWANNetwork [UDAAPIRequest isWWANNetwork]  // 判断是否为手机网络
#endif

#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork [UDAAPIRequest isWiFiNetwork]  // 判断是否为WiFi网络
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UDAAPIRequest : UDARequestRoute

#pragma mark--网络请求
+ (void)requestUrl:(NSString *)requestUrl parameter:(id __nullable)json requestType:(UDARequestType)type isShowHUD:(BOOL)isShow progressBlock:(progressBlock)progressBlock completeBlock:(completeBlock_success)completeBlock errorBlock:(errorBlock_fail)errorBlock;

#pragma mark--上传文件
/**
 *  上传文件
 *
 *  @param json 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param filePath   文件本地的沙盒路径
 *  @param progressBlock   上传进度信息
 *  @param completeBlock    请求成功的回调
 *  @param errorBlock    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionDataTask *)uploadFileUrl:(NSString *)requestUrl
   parameters:(id)json
         name:(NSString *)name
     filePath:(NSString *)filePath
progressBlock:(progressBlock)progressBlock
completeBlock:(completeBlock_success)completeBlock
   errorBlock:(errorBlock_fail)errorBlock;

#pragma mark--上传图片
/**
 *  上传单/多张图片
 *
 *  @param json 请求参数
 *  @param name       图片对应服务器上的字段
 *  @param images     图片数组
 *  @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 *  @param imageType  图片文件的类型,例:png、jpg(默认类型)....
 *  @param progressBlock   上传进度信息
 *  @param completeBlock    请求成功的回调
 *  @param errorBlock    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionDataTask *)uploadImagesUrl:(NSString *)requestUrl
   parameters:(id __nullable)json
         name:(NSString *)name
       images:(NSArray<UIImage *> *)images
    fileNames:(NSArray<NSString *> * __nullable)fileNames
   imageScale:(CGFloat)imageScale
    imageType:(NSString *)imageType
progressBlock:(progressBlock)progressBlock
completeBlock:(completeBlock_success)completeBlock
   errorBlock:(errorBlock_fail)errorBlock;

#pragma mark--Base64图片上传
/**
 *  上传单/多张图片
 *
 *  @param route      路由
 *  @param method      名称
 *  @param image 单张image
 *  @param key       图片对应服务器上的字段
 *  @param type       请求类型
 *  @param progressBlock   上传进度信息
 *  @param completeBlock    请求成功的回调
 *  @param errorBlock    请求失败的回调
 *
 */
+ (void)uploadBase64PictureRoute:(NSString *)route
                          method:(NSString *)method
                         picture:(UIImage *)image
                     pictureKey:(NSString *)key
                     requestType:(UDARequestType)type
                   progressBlock:(progressBlock)progressBlock completeBlock:(completeBlock_success)completeBlock errorBlock:(errorBlock_fail)errorBlock;

#pragma mark--下载文件
/**
 *  下载文件
 *
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progressBlock 文件下载的进度信息
 *  @param completeBlock  下载成功的回调(回调参数filePath:文件的路径)
 *  @param errorBlock  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionDownloadTask *)downloadUrl:(NSString *)requestUrl
      fileDir:(NSString *)fileDir
progressBlock:(progressBlock)progressBlock
completeBlock:(void(^)(NSURL *filePath))completeBlock
   errorBlock:(errorBlock_fail)errorBlock;

#pragma mark--其他
// 取消所有HTTP请求
+ (void)cancelAllRequest;

// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL;

// 有网YES, 无网:NO
+ (BOOL)isNetwork;

// 手机网络:YES, 反之:NO
+ (BOOL)isWWANNetwork;

// WiFi网络:YES, 反之:NO
+ (BOOL)isWiFiNetwork;

@end

NS_ASSUME_NONNULL_END
