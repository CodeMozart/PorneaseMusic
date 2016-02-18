//
//  CALayer+MHzAnimation.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "CALayer+MHzAnimation.h"

@implementation CALayer (MHzAnimation)

- (void)pauseAnimation
{
//    NSLog(@"%f",CACurrentMediaTime()); // 153000.040479
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
//    NSLog(@"%f",pausedTime); // 153000.041121
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumeAnimation
{
    CFTimeInterval pausedTime = self.timeOffset;
//    NSLog(@"%f",pausedTime); // 153000.041121
//    NSLog(@"%f",CACurrentMediaTime()); // 153015.168862
    self.speed = 1.0;
//    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
//    NSLog(@"%f",timeSincePause); // 15.127929
    self.beginTime = timeSincePause;
}

@end
