//
//  LuckySheetViewController.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/26.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger, ExcelStauts) {
    
    // 修改单据
    ExcelStautsDocunment = 0,
    // 编辑模版
    ExcelStautsTemplateEdit = 1,
    // 自定义模版
    ExcelStautsTemplateCustom = 2,
    // 查看单据、不可编辑
    ExcelStautsDocunmentNonEditable = 3,

};

@interface LuckySheetViewController : RootViewController

- (instancetype)initWithDict:(NSDictionary *)infoDict wthStatus:(ExcelStauts)status;
@end
