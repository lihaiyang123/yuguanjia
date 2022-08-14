//
//  ServiceProviderModel.h
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import <Foundation/Foundation.h>
#import "ServiceChildModel.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceProviderModel : NSObject

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *serID;
@property (nonatomic, copy) NSString *userType;



/** 内容 */
@property (nonatomic, copy) NSArray<ServiceChildModel *> *serviceProviderVoList;


/** 是否展开 */
@property (nonatomic, assign) BOOL isExpand;


@end

NS_ASSUME_NONNULL_END
