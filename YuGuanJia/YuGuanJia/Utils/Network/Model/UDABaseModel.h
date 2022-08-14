//
//  UDABaseModel.h
//  uda-mail-ios
//
//  Created by 柯索 on 2019/8/28.
//  Copyright © 2019 YunDa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UDABaseModel : NSObject <YYModel,NSCoding,NSCopying>

/**
 Creates and returns an array from a json-array.
 This method is thread-safe.
 
 @param cls  The instance's class in array.
 @param json  A json array of `NSArray`, `NSString` or `NSData`.
 Example: [{"name","Mary"},{name:"Joe"}]
 
 @return A array, or nil if an error occurs.
 */
+ (NSArray *)yd_modelArrayWithJson:(id)json;

/**
 Creates and returns a dictionary from a json.
 This method is thread-safe.
 
 @param cls  The value instance's class in dictionary.
 @param json  A json dictionary of `NSDictionary`, `NSString` or `NSData`.
 Example: {"user1":{"name","Mary"}, "user2": {name:"Joe"}}
 
 @return A array, or nil if an error occurs.
 */
+ (NSDictionary *)yd_modelDictionaryWithJson:(id)json;

@end

NS_ASSUME_NONNULL_END
