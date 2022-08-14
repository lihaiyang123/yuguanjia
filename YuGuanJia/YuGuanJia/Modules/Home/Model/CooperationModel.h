//
//  CooperationModel.h
//  YuGuanJia
//
//  Created by Yang on 2021/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CooperationModel : NSObject

@property (nonatomic, assign) NSInteger apprId;
@property (nonatomic, assign) NSInteger docStatus;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger isMain;
@property (nonatomic, assign) NSInteger processId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger serId;
@property (nonatomic, copy) NSString *serName;
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
