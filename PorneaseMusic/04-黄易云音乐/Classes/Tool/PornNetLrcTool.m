//
//  PornNetLrcTool.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/3/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "PornNetLrcTool.h"
#import "PornNetLrcLine.h"

@implementation PornNetLrcTool
+ (NSArray *)lrcToolWithLrcName:(NSString *)lrcName
{
    // 1.load Lrc
    NSString *filePath = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    // 2.将歌词切割
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    
    // 3.lrc -> model
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrclineString in lrcArray) {
        // 3.1 将不需要的歌词过滤
        if ([lrclineString hasPrefix:@"[ti:"] || [lrclineString hasPrefix:@"[ar:"] || [lrclineString hasPrefix:@"[al:"] || ![lrclineString hasPrefix:@"["]) continue;
            
        // 3.2
        PornNetLrcLine *lrcLine = [PornNetLrcLine lrcLineWithString:lrclineString];
        
        [tempArray addObject:lrcLine];
    }
    
    return tempArray;
}





































































@end
