//
//  ServiceProviderModel.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import "ServiceProviderModel.h"

@implementation ServiceProviderModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"serviceProviderVoList" : [ServiceChildModel class]};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"serviceProviderVoList" : [ServiceChildModel class]};
}

@end
