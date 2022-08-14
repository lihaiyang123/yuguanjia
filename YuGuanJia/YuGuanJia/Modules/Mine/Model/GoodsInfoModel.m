//
//  GoodsInfoModel.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/30.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {

    return @{
             @"goodsPicsList" : [GoodsPicsListModel class],
             @"goodsVo" : [GoodsVoModel class]
             };
}

//- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
//
//    NSMutableDictionary *bigDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
//
//    if ([bigDictionary[@"goodsPicsList"] isKindOfClass:[NSArray class]]) {
//
//        NSArray *goodsPicsList = bigDictionary[@"goodsPicsList"];
//        __block NSMutableArray *tmpMutaArray = [NSMutableArray array];
//        [goodsPicsList enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * stop) {
//
//            NSMutableDictionary *itemMutaDict = [NSMutableDictionary dictionary];
//            if ([objDict jk_stringForKey:@"picType"]) {
//
//                [itemMutaDict jk_setObj:[NSString stringWithFormat:@"%@",objDict[@"picType"]] forKey:@"picType"];
//            } else {
//                [itemMutaDict jk_setObj:@[] forKey:@"picType"];
//            }
//
//            [tmpMutaArray addObject:itemMutaDict];
//        }];
//        [bigDictionary jk_setObj:tmpMutaArray forKey:@"goodsPicsList"];
//    }
//    return bigDictionary;
//
//}

@end

@implementation GoodsPicsListModel



@end

@implementation GoodsVoModel

@end

