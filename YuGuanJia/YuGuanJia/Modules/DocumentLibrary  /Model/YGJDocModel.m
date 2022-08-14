//
//  YGJDocModel.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/20.
//

#import "YGJDocModel.h"

@implementation YGJDocModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {

    return @{
             @"records" : [YGJDocItemModel class]
             };
}
@end

@implementation YGJDocItemModel

@end
