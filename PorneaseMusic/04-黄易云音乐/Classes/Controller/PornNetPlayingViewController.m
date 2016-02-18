//
//  PornNetPlayingViewController.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "PornNetPlayingViewController.h"
#import "PornNetMusic.h"

#import "PornNetMusicTool.h"
#import "MHzAudioTool.h"

#import <Masonry.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CALayer+MHzAnimation.h"
#import "NSString+MHzTime.h"

#import "PornNetLrcView.h"
#import "PornNetLrcLabel.h"

@interface PornNetPlayingViewController ()<AVAudioPlayerDelegate,UIScrollViewDelegate,PornNetLrcViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView; /**< 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet PornNetLrcView *lrcView;
@property (weak, nonatomic) IBOutlet PornNetLrcLabel *lrcLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;/**< 歌曲当前时间 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;/**< 歌曲总时间 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;/**< 歌曲当前进度 */
@property (weak, nonatomic) IBOutlet UILabel *songLabel;/**< 歌曲名称 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;/**< 歌手名称 */
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) NSTimer *progressTimer;/**< 定时器 */
@property (weak, nonatomic) CADisplayLink *lrcTimer;/**< 歌词的定时器 */
@property (weak, nonatomic) AVAudioPlayer *currentPlayer;/**< 播放器 */
@end

@implementation PornNetPlayingViewController

#pragma mark -  <初始化方法>

- (void)viewDidLoad
{
    // 在这里拿到的控件的尺寸和storyboard里面是一致的，所以控件的尺寸不准确
    
    [super viewDidLoad];
    
    // 1.设置背景图片的毛玻璃效果（几种方式？自带／toolBar/图片）
    [self setupBlur];
    
    // 2.设置滚动条的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 3.开始播放音乐
    [self startPlayingMusic];
    
    // 4.将外面的label对象的指针赋值给lrcView的指针
    self.lrcView.extraLrcLabel = self.lrcLabel;
    
    // 5.设置lrcView的代理
    self.lrcView.lrcViewDelegate = self;
    
}

- (void)viewWillLayoutSubviews
{
    // setupCornerRadius
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width * 0.5;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = 10;
    self.iconImageView.layer.borderColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0].CGColor;

}

/**
 *  设置毛玻璃效果
 */
- (void)setupBlur
{
    // 1.create toolBar object
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlack;
    [self.bgImageView addSubview:toolBar];
    
    // 2.add constraint
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top);
        make.bottom.equalTo(self.bgImageView.mas_bottom);
        make.left.equalTo(self.bgImageView.mas_left);
        make.right.equalTo(self.bgImageView.mas_right);
    }];
}

/**
 *  给专辑封面添加动画
 */
- (void)setupIconImageViewAnimation
{
    // 1. create animation
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 2. setup animation's property
    rotationAnim.fromValue = @(0);
    rotationAnim.toValue = @(M_PI * 2);
    rotationAnim.duration = 35;
    rotationAnim.repeatCount = NSIntegerMax;
    // 3. add animation to View's layer
    [self.iconImageView.layer addAnimation:rotationAnim forKey:nil];// 这个key是用来取动画的
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -  <start play music>
/**
 <#Description#>
 */
- (void)startPlayingMusic
{
    PornNetMusic *playingMusic = [PornNetMusicTool playingMusic];
    
    self.bgImageView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconImageView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    // play:
    AVAudioPlayer *currentPlayer = [MHzAudioTool playMusicWithName:playingMusic.filename];
    self.currentPlayer = currentPlayer;
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:currentPlayer.duration];
    self.currentPlayer.delegate = self;
    
    // setTimer:
    [self stopProgressTimer];
    [self startProgressTimer];
    
    // add animation to iconImageView (rotate it)
    // 核心动画的特点：重新添加动画，动画就会从头开始
    [self setupIconImageViewAnimation];
    
//    将歌词的文件名称传给lrcView
    self.lrcView.lrcName = playingMusic.lrcname;
    
    [self stopLrcTimer];
    [self startLrcTimer];
    
    // 设置锁屏界面信息
    [self setupLockScreenInfo:[UIImage imageNamed:playingMusic.icon]];
    
}



#pragma mark -  <对定时器的操作>
/**
 定时器开启
 */
- (void)startProgressTimer
{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

/**
 定时器停止
 */
- (void)stopProgressTimer
{
    [self.progressTimer invalidate];
}

- (void)updateProgressInfo
{
    // 1.改变滑块的value
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
    // 2.
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
}

- (void)startLrcTimer
{
    CADisplayLink *lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    self.lrcTimer = lrcTimer;
    [lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopLrcTimer
{
    [self.lrcTimer invalidate];
}

- (void)updateLrc
{
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}
#pragma mark -  <对进度条的操作>
/**
 点击进度条上的滑块
 */
- (IBAction)touchDownSlider:(id)sender {
    [self stopProgressTimer];
}
- (IBAction)valueChanged:(id)sender {
    // 1. get slider value
    CGFloat ratio = self.progressSlider.value;
    // 2. calculate current time
    NSTimeInterval showCurrentTime = ratio * self.currentPlayer.duration;
    // 3. display
    self.currentTimeLabel.text = [NSString stringWithTime:showCurrentTime];
}
- (IBAction)touchUpInsideSlider:(id)sender {
    // 1.calculate time should show
    NSTimeInterval currentTime = self.progressSlider.value * self.currentPlayer.duration;
    self.currentPlayer.currentTime = currentTime;
    
    // 2.start Timer
    [self startProgressTimer];
}

/**
 点击进度条（默认情况下进度条是不能点击的）
 */
- (IBAction)tapClickSlider:(UITapGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.calculate tap point's ratio of the slider
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    
    // 3. change song's playing time
    self.currentPlayer.currentTime = ratio * self.currentPlayer.duration;
    
    // 4. change progressSlider's value and label's text
    // 如果这里不主动调用的话，进度条不会立刻更新到对应的位置
    [self updateProgressInfo];
}

#pragma mark -  <歌曲控制台>
- (IBAction)clickPlayButton:(UIButton *)sender {
    
    if (self.currentPlayer.isPlaying) { // palying
        // 1.change button's state
        sender.selected = NO;
        // 2.pause music
        [self.currentPlayer pause];
        // 3.pause animation
        [self.iconImageView.layer pauseAnimation];
        // 4.remove Timer
        [self stopProgressTimer];
        
        
    } else { // pause
        sender.selected = YES;
        [self.currentPlayer play];
        [self.iconImageView.layer resumeAnimation];
        [self startProgressTimer];
    }
}

- (IBAction)lastSong {
    PornNetMusic *lastMusic = [PornNetMusicTool lastMusic];
    [self changeMusic:lastMusic];
}
- (IBAction)nextSong {
    
    PornNetMusic *nextMusic = [PornNetMusicTool nextMusic];
    [self changeMusic:nextMusic];
}

- (void)changeMusic:(PornNetMusic *)changeMusic
{
    // 1.stop current music
    PornNetMusic *playingMusic = [PornNetMusicTool playingMusic];
    [MHzAudioTool stopMusicWithName:playingMusic.filename];
    
    // 2.get new music
    [PornNetMusicTool setPlayingMusic:changeMusic];
    
    // 3.play new music
    [self startPlayingMusic];
}

#pragma mark -  <AVAudioPlayer的代理方法>
/**
 监听歌曲的播放完成
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self nextSong];
    }
}
#pragma mark -  <UIScrollView的代理方法>
/**
 <#Description#>
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.current ratio of scroll
    CGFloat ratio = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 2. the alpha of lrcLabel & iconImageView
    self.iconImageView.alpha = 1- ratio;
    self.lrcLabel.alpha = 1- ratio;
}

#pragma mark -  <设置锁屏界面>
/**
 <#Description#>
 */
- (void)setupLockScreenInfo:(UIImage *)lockImage
{
    // 取出当前播放歌曲
    PornNetMusic *playingMusic = [PornNetMusicTool playingMusic];
    // 获取锁屏中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 设置显示信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 设置歌曲
    [info setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    [info setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    // 设置歌曲总时长
    [info setObject:@(self.currentPlayer.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置专辑封面
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:lockImage];
    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    
    center.nowPlayingInfo = info;
    
    // 让应用程序可以接收远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark -  <处理锁屏界面的远程事件>

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self clickPlayButton:self.playButton];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextSong];
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self lastSong];
            
        default:
            break;
    }
}

#pragma mark -  <lrcView的代理方法>

- (void)lrcView:(PornNetLrcView *)lrcView image:(UIImage *)lockImage
{
    [self setupLockScreenInfo:lockImage];
}









@end
