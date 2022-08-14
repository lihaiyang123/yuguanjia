//
//  LuckysheetImagePicker.h
//  YuGuanJia
//
//  Created by ggzj on 2021/8/7.
//

#import <Foundation/Foundation.h>

@protocol LuckysheetImagePickerDelegate <NSObject>

@optional

- (void)uploadAttachmentSuccess:(NSString *)filePath;
@end

@interface LuckysheetImagePicker : NSObject

- (instancetype)initWithDelegate:(id<LuckysheetImagePickerDelegate>)delegate;

- (void)openImagePicker;
@end
