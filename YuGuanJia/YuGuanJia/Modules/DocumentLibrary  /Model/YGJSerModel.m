//
//  YGJSerModel.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/20.
//

#import "YGJSerModel.h"

@implementation YGJSerModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {

    return @{
             @"serviceProviderVoList" : [YGJSerItemModel class]
             };
}
@end

@implementation YGJSerItemModel

@end
