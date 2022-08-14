//
//  UDAAPIRequest.m
//  uda-mail-ios
//
//  Created by 刘权 on 2019/8/26.
//  Copyright © 2019 YunDa. All rights reserved.
//

#import "UDAAPIRequest.h"
#import "LoginViewController.h"

#import "NSString+Helper.h"

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
#define EORROCODE 403

@implementation UDAAPIRequest

#pragma mark--init AFHTTPSessionManager
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

+ (void)load{
    [super load];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)initialize{
    [super initialize];
    
    _sessionManager = [AFHTTPSessionManager manager];
    [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _sessionManager.requestSerializer.timeoutInterval = Request_Time;
    [_sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;


    AFHTTPResponseSerializer *response = [AFHTTPResponseSerializer serializer];


    _sessionManager.responseSerializer = response;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];

//    [_sessionManager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    _sessionManager.operationQueue.maxConcurrentOperationCount = 3;
}
#pragma mark--网络请求
+ (void)requestUrl:(NSString *)requestUrl parameter:(id __nullable)json requestType:(UDARequestType)type isShowHUD:(BOOL)isShow progressBlock:(progressBlock)progressBlock completeBlock:(completeBlock_success)completeBlock errorBlock:(errorBlock_fail)errorBlock{
    
    NSString *url = [self compnentUrl:requestUrl];
//    NSString *url = requestUrl;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (json == nil) json = @{};
    
    NSURLSessionDataTask *sessionTask;
    NSString *deviceName;
    NSString *OSName;
    NSString *OSVersion;
    UIDevice *device = [UIDevice currentDevice];
    deviceName = [device localizedModel];
    OSName = [device systemName];
    OSVersion = [device systemVersion];
    //设置请求头
    if ([YGJSQLITE_MANAGER isLogin]) {
        [_sessionManager.requestSerializer setValue:YGJSQLITE_MANAGER.token forHTTPHeaderField:@"X-Access-Token"];
    }

    if (isShow) {
        
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    
    if (type == UDARequestTypeGet) {
        // GET
        
        NSDictionary *paramenter = [self setCommonParamenter:json];
        YDZYLog(@"----请求URL----%@",url);
        YDZYLog(@"----请求字典----%@",paramenter);
        sessionTask = [_sessionManager GET:url parameters:paramenter progress:^(NSProgress * _Nonnull downloadProgress) {
            [self requestProgress:progressBlock value:downloadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isShow) {
                [SVProgressHUD dismiss];
            }
            
            NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            UDAResponseDataModel *model = [UDAResponseDataModel modelWithJSON:resultStr];
            YDZYLog(@"GET REQUEST SUCCESS\n url=%@\n,paramenter=%@\n,data=%@",task.currentRequest.URL,json,[model modelToJSONObject]?:resultStr);
            //游客状态
            if (model.code == 403) {
                
                [self setLoginVC];
            }

            [self requestSuccess:completeBlock object:responseObject task:task];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];
            YDZYLog(@"GET REQUEST ERROR\n,url=%@\n,error=%@",task.currentRequest.URL,error);

            [self requestError:errorBlock error:error task:task];
        }];
    }else if (type == UDARequestTypePost){
        // POST
        NSDictionary *paramenter = [self setCommonParamenter:json];
        YDZYLog(@"----请求URL----%@",url);
        YDZYLog(@"----请求字典----%@",paramenter);

        sessionTask = [_sessionManager POST:url parameters:paramenter progress:^(NSProgress * _Nonnull uploadProgress) {
             [self requestProgress:progressBlock value:uploadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            if (isShow) {
                [SVProgressHUD dismiss];
            }

            NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            UDAResponseDataModel *model = [UDAResponseDataModel modelWithJSON:resultStr];
            YDZYLog(@"----resultStr----%@",resultStr);

            YDZYLog(@"POST REQUEST SUCCESS\n url=%@\n,paramenter=%@\n,data=%@",task.currentRequest.URL,paramenter,[model modelToJSONObject]?:resultStr);
            //游客状态
            if (model.code == 403) {
                
                [self setLoginVC];
            }

            [self requestSuccess:completeBlock object:responseObject task:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (isShow) {
                [SVProgressHUD dismiss];
            }

            YDZYLog(@"POST REQUEST ERROR\n url=%@\n,paramenter=%@\n,error=%@",task.currentRequest.URL,paramenter,error);
            [self requestError:errorBlock error:error task:task];
        }];
        
        [self addSessionTask:sessionTask];
    } else if (type == UDARequestTypePut) {
        
        NSDictionary *paramenter = [self setCommonParamenter:json];
        YDZYLog(@"----请求URL----%@",url);
        YDZYLog(@"----请求字典----%@",paramenter);

        sessionTask = [_sessionManager PUT:url parameters:paramenter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (isShow) {
                [SVProgressHUD dismiss];
            }

            NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            UDAResponseDataModel *model = [UDAResponseDataModel modelWithJSON:resultStr];
            YDZYLog(@"----resultStr----%@",resultStr);

            YDZYLog(@"PUT REQUEST SUCCESS\n url=%@\n,paramenter=%@\n,data=%@",task.currentRequest.URL,paramenter,[model modelToJSONObject]?:resultStr);
            //游客状态
            if (model.code == 403) {
                
                [self setLoginVC];
            }

            [self requestSuccess:completeBlock object:responseObject task:task];

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (isShow) {
                [SVProgressHUD dismiss];
            }

            YDZYLog(@"PUT REQUEST ERROR\n url=%@\n,paramenter=%@\n,error=%@",task.currentRequest.URL,paramenter,error);
            [self requestError:errorBlock error:error task:task];

        }];
    } else if (type == UDARequestTypeDelete) {
        
        NSDictionary *paramenter = [self setCommonParamenter:json];
        YDZYLog(@"----请求URL----%@",url);
        YDZYLog(@"----请求字典----%@",paramenter);
        
        sessionTask = [_sessionManager DELETE:url parameters:paramenter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isShow) {
                [SVProgressHUD dismiss];
            }

            NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            UDAResponseDataModel *model = [UDAResponseDataModel modelWithJSON:resultStr];
            YDZYLog(@"----resultStr----%@",resultStr);

            YDZYLog(@"DELETE REQUEST SUCCESS\n url=%@\n,paramenter=%@\n,data=%@",task.currentRequest.URL,paramenter,[model modelToJSONObject]?:resultStr);
            //游客状态
            if (model.code == 403) {
                
                [self setLoginVC];
            }

            [self requestSuccess:completeBlock object:responseObject task:task];

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (isShow) {
                [SVProgressHUD dismiss];
            }

            YDZYLog(@"DELETE REQUEST ERROR\n url=%@\n,paramenter=%@\n,error=%@",task.currentRequest.URL,paramenter,error);
            [self requestError:errorBlock error:error task:task];

        }];
        
    }
}
#pragma mark - 处理token失效后切换登录界面
+ (void)setLoginVC
{
    [YGJCommonPopup showPopupStatus:YGJPopupStatusLogin complete:nil cancelHandler:nil];
}

#pragma mark--上传文件
+ (__kindof NSURLSessionDataTask *)uploadFileUrl:(NSString *)requestUrl
                                        parameters:(id)json
                                              name:(NSString *)name
                                          filePath:(NSString *)filePath
                                     progressBlock:(progressBlock)progressBlock
                                     completeBlock:(completeBlock_success)completeBlock
                                        errorBlock:(errorBlock_fail)errorBlock{
    
    NSString *url = [self compnentUrl:requestUrl];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (json == nil) json = @{};
    
    NSURLSessionDataTask *sessionTask = [_sessionManager POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        error ? [self requestError:errorBlock error:error task:nil] : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        [self requestProgress:progressBlock value:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self requestSuccess:completeBlock object:responseObject task:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self requestError:errorBlock error:error task:task];
    }];
    
    // 添加sessionTask到数组
    [self addSessionTask:sessionTask];
    
    return sessionTask;
}

#pragma mark--上传图片
+ (__kindof NSURLSessionDataTask *)uploadImagesUrl:(NSString *)requestUrl
                                          parameters:(id __nullable)json
                                                name:(NSString *)name
                                              images:(NSArray<UIImage *> *)images
                                           fileNames:(NSArray<NSString *> * __nullable)fileNames
                                          imageScale:(CGFloat)imageScale
                                           imageType:(NSString *)imageType
                                       progressBlock:(progressBlock)progressBlock
                                       completeBlock:(completeBlock_success)completeBlock
                                          errorBlock:(errorBlock_fail)errorBlock{
    
    NSString *url = [self compnentUrl:requestUrl];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (json == nil) json = @{};
    
    // 设置公共参数
    NSDictionary *paramenter = [self setCommonParamenter:json];
    NSURLSessionDataTask *sessionTask = [_sessionManager POST:url parameters:paramenter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < images.count; i++) {
            // 图片压缩
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 0.5);
            // 自定义图片名
            NSString *fileName;
            if (fileNames && fileNames.count == images.count) {
                fileName = fileNames[i];
            }else{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *time = [formatter stringFromDate:[NSDate date]];
                fileName = [NSString stringWithFormat:@"%@%u",time,i];
            }
            // 图片类型
            NSString *type = imageType.length > 0 ? imageType : @"jpg";
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:[NSString stringWithFormat:@"%@.%@",fileName,type]
                                    mimeType:[NSString stringWithFormat:@"image/%@",type]];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        [self requestProgress:progressBlock value:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        UDAResponseDataModel *model = [UDAResponseDataModel modelWithJSON:resultStr];
        YDZYLog(@"UPLOAD IMAGE REQUEST SUCCESS\n url=%@\n,paramenter=%@\n,data=%@",task.currentRequest.URL,paramenter,[model modelToJSONObject]?:resultStr);
        [self requestSuccess:completeBlock object:responseObject task:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YDZYLog(@"UPLOAD IMAGE REQUEST ERROR\n url=%@\n,paramenter=%@\n,error=%@",task.currentRequest.URL,paramenter,error);
        [self requestError:errorBlock error:error task:task];
    }];
    
    // 添加sessionTask到数组
    [self addSessionTask:sessionTask];
    
    return sessionTask;
}

#pragma mark--base64上传
+ (void)uploadBase64PictureRoute:(NSString *)route
                          method:(NSString *)method
                         picture:(UIImage *)image
                      pictureKey:(NSString *)key
                     requestType:(UDARequestType)type
                   progressBlock:(progressBlock)progressBlock completeBlock:(completeBlock_success)completeBlock errorBlock:(errorBlock_fail)errorBlock{
    
//    NSString *base64 = [image converToBase64String];
//    NSDictionary *parament = @{
//                               @"client":@"ios",
//                               key:base64
//                               };
//    [self requestRoute:route method:method parameter:parament requestType:type progressBlock:progressBlock completeBlock:completeBlock errorBlock:errorBlock];
}

#pragma mark--下载文件
+ (__kindof NSURLSessionDownloadTask *)downloadUrl:(NSString *)requestUrl
                                             fileDir:(NSString *)fileDir
                                       progressBlock:(progressBlock)progressBlock
                                       completeBlock:(void(^)(NSURL *filePath))completeBlock
                                          errorBlock:(errorBlock_fail)errorBlock{
    
    NSString *url = requestUrl; //[self compnentUrl:requestUrl];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        [self requestProgress:progressBlock value:downloadProgress];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(errorBlock && error) {
            errorBlock(error);
            return;
        }
        // filePath.absoluteString
        completeBlock ? completeBlock(filePath /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}

#pragma mark--公共
// 配置公共参数
+ (NSDictionary *)setCommonParamenter:(NSDictionary *)parament{
    NSMutableDictionary *dic = [parament mutableCopy];
    // 添加登录token
//    UDAUser *user = [[UDAUserManager shareUser]getCurrentUser];
//    if (![parament valueForKey:@"key"] && !kISNullString(user.key)) {
//        [dic setObject:[self getToken] forKey:@"key"];
//    }
    return dic;
}

// 请求进度
+ (void)requestProgress:(progressBlock)progressBlock value:(NSProgress *)value{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat values = value.fractionCompleted;
        if (progressBlock) {
            progressBlock(values);
        }
    });
}

// 请求成功
+ (void)requestSuccess:(completeBlock_success)completeBlock object:(id)object task:(NSURLSessionDataTask *)task{
    NSString *resultStr = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
    UDAResponseDataModel *model = [UDAResponseDataModel modelWithJSON:resultStr];
    if (!model) {
        model = [[UDAResponseDataModel alloc]init];
        model.data = resultStr;
    }
    completeBlock(model);
    task ? [self removeSessionTask:task] : nil;
}

// 请求失败
+ (void)requestError:(errorBlock_fail)errorBlock error:(NSError *)error task:(NSURLSessionDataTask *)task{
    errorBlock(error);
    task ? [self removeSessionTask:task] : nil;
}

// 添加到请求队列
+ (void)addSessionTask:(NSURLSessionDataTask *)task{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 添加最新的sessionTask到数组
    task ? [[self allSessionTask] addObject:task] : nil ;
}

// 从请求队列中移除
+ (void)removeSessionTask:(NSURLSessionDataTask *)task{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    task ? [[self allSessionTask] removeObject:task] : nil;
}

#pragma mark--其他
+ (void)cancelAllRequest {
    
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString containsString:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

@end
