//
//  FlowEditViewController.h
//  YuGuanJia
//
//  Created by ggzj on 2021/7/15.
//

#import "RootViewController.h"

@interface FlowEditViewController : RootViewController

- (instancetype)initWithEditDict:(NSDictionary *)dic withRefresh:(CDBlock)block;

- (void)setupIndexPath:(NSIndexPath *)indexPath withKey:(NSString *)key withArray:(NSArray *)arr;
@end
