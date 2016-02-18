//
//  PornNetMusicTool.h
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PornNetMusic.h"

@interface PornNetMusicTool : NSObject

/**
 *
 */
+ (NSArray *)musics;

+ (PornNetMusic *)playingMusic;

/**
 *  下一曲
 */
+ (PornNetMusic *)nextMusic;
/**
 *  上一曲
 */
+ (PornNetMusic *)lastMusic;

/** 设置当前播放歌曲 */
+ (void)setPlayingMusic:(PornNetMusic *)playingMusic;

@end
