//
//  CDCountDownButton.m
//  FT_iPhone
//
//  Created by 王乾 on 2018/12/22.
//  Copyright © 2018 ChangDao. All rights reserved.
//

#import "CDCountDownButton.h"

@interface CDCountDownButton ()

@end

@implementation CDCountDownButton

#pragma -mark touche action
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler{
    _touchedCountDownButtonHandler = [touchedCountDownButtonHandler copy];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touched:(CDCountDownButton*)sender{
    if (_touchedCountDownButtonHandler) {
        _touchedCountDownButtonHandler(sender,sender.tag);
    }
}

#pragma -mark count down method
-(void)startCountDownWithSecond:(NSUInteger)totalSecond
{
    _totalSecond = totalSecond;
    _second = totalSecond;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    _startDate = [NSDate date];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)timerStart:(NSTimer *)theTimer {
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    
    _second = _totalSecond - (NSInteger)(deltaTime+0.5) ;
    
    
    if (_second< 0.0) {
        
        [self stopCountDown];
    } else {
        
        if (_countDownChanging) {
            
            [self setTitle:_countDownChanging(self,_second) forState:UIControlStateNormal];
//            [self setTitle:_countDownChanging(self,_second) forState:UIControlStateDisabled];
        } else {
            NSString *title = [NSString stringWithFormat:@"%@秒",@(_second)];
            [self setTitle:title forState:UIControlStateNormal];
//            [self setTitle:title forState:UIControlStateDisabled];
            
        }
    }
}

- (void)stopCountDown{
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            
            if ([_timer isValid]) {
                
                [_timer invalidate];
                _second = _totalSecond;
                if (_countDownFinished) {
                    
                    [self setTitle:_countDownFinished(self,_totalSecond)forState:UIControlStateNormal];
//                    [self setTitle:_countDownFinished(self,_totalSecond)forState:UIControlStateDisabled];
                } else {
                    [self setTitle:@"重新获取" forState:UIControlStateNormal];
//                    [self setTitle:@"重新获取" forState:UIControlStateDisabled];
                }
            }
        }
    }
}
#pragma -mark block
-(void)countDownChanging:(CountDownChanging)countDownChanging{
    _countDownChanging = [countDownChanging copy];
}
-(void)countDownFinished:(CountDownFinished)countDownFinished{
    _countDownFinished = [countDownFinished copy];
}
@end
