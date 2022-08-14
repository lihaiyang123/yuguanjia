//
//  MineFlowModel.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/18.
//

#import "MineFlowModel.h"

@implementation MineFlowModel

//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
//
//    return @{
//             @"records" : [MineFlowItemModel class]
//             };
//}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    
    NSMutableDictionary *bigDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if ([bigDictionary[@"records"] isKindOfClass:[NSArray class]]) {
        
        NSArray *records = bigDictionary[@"records"];
        __block NSMutableArray *tmpMutaArray = [NSMutableArray array];
        [records enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * stop) {
            
            NSMutableDictionary *itemMutaDict = [NSMutableDictionary dictionaryWithDictionary:@{@"procName": objDict[@"procName"], @"id": [NSString stringWithFormat:@"%@", objDict[@"id"]]}];
            if ([objDict jk_stringForKey:@"procCancel"]) {

                [itemMutaDict jk_setObj:[objDict[@"procCancel"] componentsSeparatedByString:@","] forKey:@"procCancel"];
            } else {
                [itemMutaDict jk_setObj:@[] forKey:@"procCancel"];
            }
            
            if ([objDict jk_stringForKey:@"procEdit"]) {
                [itemMutaDict jk_setObj:[objDict[@"procEdit"] componentsSeparatedByString:@","] forKey:@"procEdit"];
            } else {
                [itemMutaDict jk_setObj:@[] forKey:@"procEdit"];
            }
            
            if ([objDict jk_stringForKey:@"procInput"]) {
                [itemMutaDict jk_setObj:[objDict[@"procInput"] componentsSeparatedByString:@","] forKey:@"procInput"];
            } else {
                [itemMutaDict jk_setObj:@[] forKey:@"procInput"];
            }

            
            if ([objDict jk_stringForKey:@"procNew"]) {
                [itemMutaDict jk_setObj:[objDict[@"procNew"] componentsSeparatedByString:@","] forKey:@"procNew"];
            } else {
                [itemMutaDict jk_setObj:@[] forKey:@"procNew"];
            }
            
            if ([objDict jk_stringForKey:@"procSubmit"]) {
                [itemMutaDict jk_setObj:[objDict[@"procSubmit"] componentsSeparatedByString:@","] forKey:@"procSubmit"];
            } else {
                [itemMutaDict jk_setObj:@[] forKey:@"procSubmit"];
            }
            
            [tmpMutaArray addObject:itemMutaDict];
        }];
        [bigDictionary jk_setObj:tmpMutaArray forKey:@"records"];
    }
    return bigDictionary;
}

@end

//@implementation MineFlowItemModel
//
//@end
