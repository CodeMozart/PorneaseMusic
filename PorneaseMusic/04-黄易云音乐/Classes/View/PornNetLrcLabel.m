//
//  PornNetLrcLabel.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/3/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "PornNetLrcLabel.h"

@implementation PornNetLrcLabel

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
//    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 设置上下文颜色
    [[UIColor greenColor] set];
    // 绘制的矩形框
    CGRect drawRect = CGRectMake(0, 0, rect.size.width * self.progress, rect.size.height);
    // 绘制
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}


@end
