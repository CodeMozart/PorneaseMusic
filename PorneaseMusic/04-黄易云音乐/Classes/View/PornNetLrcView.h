//
//  PornNetLrcView.h
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PornNetLrcLabel,PornNetLrcView;

// 声明代理
@protocol PornNetLrcViewDelegate <NSObject>
@optional
- (void)lrcView:(PornNetLrcView *)lrcView image:(UIImage *)lockImage;
@end

@interface PornNetLrcView : UIScrollView
@property (weak, nonatomic) id<PornNetLrcViewDelegate> lrcViewDelegate;/** 代理属性 */
@property (copy, nonatomic) NSString *lrcName;/**< 歌词文件名称 */
@property (assign, nonatomic) NSTimeInterval currentTime;/**< 当前播放的时间 */
@property (weak, nonatomic) PornNetLrcLabel *extraLrcLabel;/**< 外面歌词label的引用 */

@end
