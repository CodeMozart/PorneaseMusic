//
//  MHzAudioTool.h
//  02-PlayAudio
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MHzAudioTool : NSObject
// 考虑外面怎么调用比较方便
+ (void)playSoundWithName:(NSString *)soundName; /** 播放音效 */
+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName; /** 播放音乐 */

+ (void)pauseMusicWithName:(NSString *)musicName; /** pause音乐 */

+ (void)stopMusicWithName:(NSString *)musicName; /** stop音乐 */
@end
