//
//  CALayer+MHzAnimation.h
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (MHzAnimation)

/**
 *  暂停动画
 */
- (void)pauseAnimation;

/**
 *  恢复动画
 */
- (void)resumeAnimation;

@end
