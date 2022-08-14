//
//  MineFlowModel.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//@class MineFlowItemModel;

@interface MineFlowModel : NSObject

@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, copy)   NSArray *records;
@property (nonatomic, assign) BOOL isSearchCount;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger total;
@end

//@interface MineFlowItemModel : NSObject
//
//@property (nonatomic, copy)   NSString *createTime;
//@property (nonatomic, assign) NSInteger creater;
//@property (nonatomic, assign) NSInteger del;
//@property (nonatomic, assign) NSInteger identifier;
//
//@property (nonatomic, copy)   NSString *procCancel;
//@property (nonatomic, copy)   NSString *procEdit;
//@property (nonatomic, copy)   NSString *procInput;
//@property (nonatomic, copy)   NSString *procNew;
//@property (nonatomic, copy)   NSString *procSubmit;
//
//@property (nonatomic, copy)   NSString *procName;
//
//@property (nonatomic, copy)   NSString *updateTime;
//@property (nonatomic, assign) NSInteger updater;
//@property (nonatomic, assign) NSInteger userID;
//@end

NS_ASSUME_NONNULL_END
