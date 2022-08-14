//
//  CDCountDownButton.h
//  FT_iPhone
//
//  Created by 王乾 on 2018/12/22.
//  Copyright © 2018 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDCountDownButton;

typedef NSString* (^CountDownChanging)(CDCountDownButton *countDownButton,NSUInteger second);
typedef NSString* (^CountDownFinished)(CDCountDownButton *countDownButton,NSUInteger second);

typedef void (^TouchedCountDownButtonHandler)(CDCountDownButton *countDownButton,NSInteger tag);

@interface CDCountDownButton : UIButton {
    
    NSInteger _second;
    NSUInteger _totalSecond;
    
    NSTimer *_timer;
    NSDate *_startDate;
    
    CountDownChanging _countDownChanging;
    CountDownFinished _countDownFinished;
    TouchedCountDownButtonHandler _touchedCountDownButtonHandler;
}
@property(nonatomic,strong) id userInfo;

- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
- (void)countDownChanging:(CountDownChanging)countDownChanging;
- (void)countDownFinished:(CountDownFinished)countDownFinished;

- (void)startCountDownWithSecond:(NSUInteger)second;
- (void)stopCountDown;

@end
