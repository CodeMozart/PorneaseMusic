//
//  NSString+MHzTime.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "NSString+MHzTime.h"

@implementation NSString (MHzTime)

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    // 系统加载会耗费大约0.03的时间，但是定时器是从一开始就走，所以在实际过了1s的时候，歌曲只走了0.97，0.97会被转成0，所以会造成显示出现问题
    time += 0.05;
    NSInteger min = time / 60;
    NSInteger second = (NSInteger)time % 60; // double不能取余
    
    return [NSString stringWithFormat:@"%02ld:%02ld",min,second];
}

@end
