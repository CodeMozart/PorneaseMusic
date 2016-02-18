//
//  NSString+MHzTime.h
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MHzTime)

/**
 *  转换播放时间的格式
 *
 *  @param time 时间
 *
 *  @return 返回 02:20 这样格式的时间
 */
+ (NSString *)stringWithTime:(NSTimeInterval)time;

@end
