//
//  PornNetMusicTool.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "PornNetMusicTool.h"
#import <MJExtension.h>
#import "PornNetMusic.h"


@implementation PornNetMusicTool

static NSArray *_musics;
static PornNetMusic *_playingMusic;

+ (void)initialize
{
    _musics = [PornNetMusic objectArrayWithFilename:@"Musics.plist"];
    
    _playingMusic = _musics[0];
}

+ (NSArray *)musics
{
    return _musics;
}

+ (PornNetMusic *)nextMusic
{
    // 1.
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //
    NSInteger nextIndex = currentIndex + 1;
    
    if (nextIndex > _musics.count - 1) {
        nextIndex = 0;
    }
    
    return _musics[nextIndex];
}

+ (PornNetMusic *)lastMusic
{
    // 1.
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //
    NSInteger lastIndex = currentIndex - 1;
    
    if (lastIndex < 0) {
        lastIndex = _musics.count - 1;
    }
    
    return _musics[lastIndex];
}

#pragma mark -  <对当前歌曲的操作>
/**
 设置当前歌曲
 */
+ (void)setPlayingMusic:(PornNetMusic *)playingMusic
{
    _playingMusic = playingMusic;
}
/**
 返回当前歌曲
 */
+ (PornNetMusic *)playingMusic
{
    return _playingMusic;
}

@end
