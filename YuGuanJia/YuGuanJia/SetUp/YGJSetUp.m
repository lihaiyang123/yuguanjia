//
//  YGJSetUp.m
//  YuGuanJia
//
//  Created by 李海洋 on 2022/7/14.
//

#import "YGJSetUp.h"

@implementation YGJSetUp

+ (NSString *)getBaseUrl {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WebserviceUrl"];
}

+ (NSString *)getAgrementUrl{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AgrementUrl"];
}

+ (NSString *)getPrivacyUrl{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PrivacyUrl"];
}
@end
