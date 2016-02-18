//
//  MHzAudioTool.m
//  02-PlayAudio
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "MHzAudioTool.h"
#import <AVFoundation/AVFoundation.h>


@implementation MHzAudioTool
// 类方法保存属性一般用静态变量
static NSMutableDictionary * _soundIDDictionary;
static NSMutableDictionary * _musicPlayerDictionary;

+ (void)initialize
{
    _soundIDDictionary = [NSMutableDictionary dictionary];
    _musicPlayerDictionary = [NSMutableDictionary dictionary];
}

+ (void)playSoundWithName:(NSString *)soundName
{
    SystemSoundID soundID = [_soundIDDictionary[soundName] unsignedIntValue];
    if (soundID == 0) {
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        AudioServicesCreateSystemSoundID(url, &soundID);
        [_soundIDDictionary setObject:@(soundID) forKey:soundName];
    }
    
    AudioServicesPlayAlertSound(soundID);
}

+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName
{
    // 1. get music palyer
    AVAudioPlayer *player = _musicPlayerDictionary[musicName];
    if (player == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [_musicPlayerDictionary setObject:player forKey:musicName];
    }
    [player play];
    
    return player;
}

+ (void)pauseMusicWithName:(NSString *)musicName
{
    AVAudioPlayer *player = _musicPlayerDictionary[musicName];
    
    // if is not nil, pause music
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithName:(NSString *)musicName
{
    AVAudioPlayer *player = _musicPlayerDictionary[musicName];
    
    if (player) {
        [player stop];
        [_musicPlayerDictionary removeObjectForKey:musicName];
    }
    
}
@end
