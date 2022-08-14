//
//  UDABaseHander.h
//  uda-mail-ios
//
//  Created by 柯索 on 2019/8/28.
//  Copyright © 2019 YunDa. All rights reserved.
//

#ifndef UDABaseHander_h
#define UDABaseHander_h
typedef void(^ Success)(id _Nullable json);
typedef void(^ Failure)(NSString * _Nonnull errorMSG);
// Handler处理失败时调用的Block
typedef void (^FailureBlock)(id _Nullable obj);
// Handler处理完成时调用的Block
typedef void (^LoginCompletionBlock)(void);

#endif /* UDABaseHander_h */
