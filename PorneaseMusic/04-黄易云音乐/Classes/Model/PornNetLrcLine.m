//
//  PornNetLrcLine.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/3/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "PornNetLrcLine.h"

@implementation PornNetLrcLine
- (instancetype)initWithLrcString:(NSString *)lrclineString
{
    if (self = [super init]) {
        NSArray *lrclineArray = [lrclineString componentsSeparatedByString:@"]"];
        self.text = [lrclineArray lastObject];
        self.time = [self timeWithTimeString:[lrclineArray[0] substringFromIndex:1]];
    }
    
    return self;
}

+ (instancetype)lrcLineWithString:(NSString *)lrclineString
{
    return [[self alloc] initWithLrcString:lrclineString];
}

- (NSTimeInterval)timeWithTimeString:(NSString *)timeString
{
    NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
    NSInteger min = [[timeArray firstObject] integerValue];
    NSInteger second = [[[timeArray lastObject] componentsSeparatedByString:@"."][0] integerValue];
    NSInteger haomiao =[[[timeArray lastObject] componentsSeparatedByString:@"."][0] integerValue];
    
    return min * 60 + second + haomiao * 0.01;
}
@end
