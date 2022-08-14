//
//  YGJDocModel.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YGJDocItemModel;
@interface YGJDocModel : NSObject

@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, copy)   NSArray<YGJDocItemModel *> *records;
@property (nonatomic, assign) BOOL isSearchCount;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger total;
@end


@interface YGJDocItemModel : NSObject

@property (nonatomic, assign) NSInteger docStatus;
@property (nonatomic, assign) NSInteger beingSerID;
@property (nonatomic, assign) NSInteger beingSerProcId;
@property (nonatomic, assign) NSInteger nextApprID;
@property (nonatomic, copy)   NSString *nextApprName;
@property (nonatomic, copy)   NSString *serName;

@property (nonatomic, copy)   NSString *beingSerName;
@property (nonatomic, copy)   NSString *buttons;

@property (nonatomic, copy)   NSString *createTime;
@property (nonatomic, assign) NSInteger creater;
@property (nonatomic, assign) NSInteger del;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSString *previewURL;
@property (nonatomic, assign) NSInteger procID;
@property (nonatomic, assign) NSInteger serID;
@property (nonatomic, assign) NSInteger serProcId;

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy)   NSString *tempContent;
@property (nonatomic, assign) NSInteger tempType;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, assign) NSInteger updater;

@property (nonatomic, copy)   NSString *previewUrl;
@property (nonatomic, assign) NSInteger pubPri;
@property (nonatomic, copy) NSString *tempName;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSInteger tempStatus;

//待办历史、我的待办
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger eventId;

@end

NS_ASSUME_NONNULL_END
