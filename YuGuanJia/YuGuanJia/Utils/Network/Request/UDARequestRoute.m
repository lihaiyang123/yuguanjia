//
//  UDABaseRequest.m
//  uda-mail-ios
//
//  Created by 刘权 on 2019/8/26.
//  Copyright © 2019 YunDa. All rights reserved.
//

#import "UDARequestRoute.h"

@implementation UDARequestRoute

+ (NSString *)compnentUrl:(NSString *)url{
    NSString *tepUrl = @"";
    if(url && url.length > 0){
        
        tepUrl =  [NSString stringWithFormat:@"%@%@",[self getHostUrl],url];

    }else{
        return [self getHostUrl];
    }
    return tepUrl;
}
+(NSString*)getHostUrl {
    return [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"WebserviceUrl"]];
}
+ (NSString *)getHost{
#ifndef __OPTIMIZE__
    if (HostFlag == UDAHostRelease) {
        return @"release_host";
    }else if(HostFlag == UDAHostInternal){
        return @"internal_host";
    }else if(HostFlag == UDAHostOutside){
        return @"outside_host";
    }else{
        // 默认生产
        return @"release_host";
    }
#endif
    return @"release_host";
}

#pragma mark 默认方法

+ (NSString *)getTimeStamp{
    
    UInt64 temp = [[NSDate  date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0llu", temp];
}

+ (NSString *)getUserID{
//    ADUserInformation *user = [ADUser shareUser].user;
//    NSString *userID = [NSString stringWithFormat:@"%zd",user?user.ID:0];
//    user = nil;
    return @"";
}

//+ (NSString *)getToken{
//
//
//    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
//    if (![[MethodManager sharedMethodManager] isBlankString:userToken]) {
//        return userToken;
//    }
//
//    return @"";
//}

//+ (NSString *)getSign
//{
//    UIDevice *device = [UIDevice currentDevice];
//    NSString *time = [NSString intervalWithTimeString:[NSString getCurrentTimes]];
//    NSString *OSName = [device systemName];
//    NSString *secret = @"esgfgjukntghfghfghmxydzyapp20200101";
//    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",[self getToken],time,OSName,secret];
//    return [sign md5];
//}

@end
