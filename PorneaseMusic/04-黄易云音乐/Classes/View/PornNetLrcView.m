//
//  PornNetLrcView.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/2/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "PornNetLrcView.h"
#import "Masonry.h"
#import "PornNetLrcCell.h"
#import "PornNetLrcTool.h"
#import "PornNetLrcLine.h"
#import "PornNetLrcLabel.h"
#import "PornNetMusic.h"
#import "PornNetMusicTool.h"

@interface PornNetLrcView()<UITableViewDataSource>
@property (weak, nonatomic) UITableView *tableView;/**< 放歌词的tableView */
@property (strong, nonatomic) NSArray *lrcLines;/**< 歌词数据 */
@property (assign, nonatomic) NSInteger currentIndex;/**< 记录当前滚动显示歌词的索引 */
@end

@implementation PornNetLrcView

// xib(stroyboard)初始化控件在initWithCoder
// 从xib初始化控件不会调用initWithFrame
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    // iOS9的时候，如果在initWithCoder中设置这些属性，可能会被清空，但是在这里不会
    // setup tableView 's properties
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)setupTableView
{
    // 1.create tableView
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.pagingEnabled = YES;
    tableView.rowHeight = 35;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 在UIScrollView中使用autolayout
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    
    // 设置内边距，使得歌词首尾能显示在中间
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height *0.5, 0, self.bounds.size.height *0.5, 0);
}

#pragma mark -  <数据源方法>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PornNetLrcCell *cell = [PornNetLrcCell lrcCellWithTableView:tableView];
    
    if (indexPath.row == self.currentIndex) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:20];
        cell.lrcLabel.textColor = [UIColor greenColor];
    } else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:14];
        cell.lrcLabel.textColor = [UIColor whiteColor];
        cell.lrcLabel.progress = 0;
    }

    PornNetLrcLine *lrcLine  = self.lrcLines[indexPath.row];
    
    cell.lrcLabel.text = lrcLine.text;
    
    return cell;
}

- (void)setLrcName:(NSString *)lrcName
{
    _lrcName = [lrcName copy];
    
    self.lrcLines = [PornNetLrcTool lrcToolWithLrcName:lrcName];
    
    [self.tableView reloadData];
    
    // 让tableView的顶部滚动到中间
    [self.tableView setContentOffset:CGPointMake(0, - self.bounds.size.height * 0.5) animated:YES];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    // show lrc
    NSInteger count = self.lrcLines.count;
    for (int i = 0; i < count; i++) {
        // 1. get i's lrc
        PornNetLrcLine *lrcLine = self.lrcLines[i];
        // 2. get i+1's lrc
        NSInteger nextIndex = i + 1;
        if (nextIndex > count - 1)  break;
        PornNetLrcLine *nextLrcLine = self.lrcLines[nextIndex];
        // 3.如果当前时间大雨等于i位置歌词位置的时间，并且小于i+1位置的歌词，那么让i位置的歌词显示在中间
        // 这个方法会调用频繁，如果当前行已经是i,就不需要再滚动，直到进入下一个时间段
        if (currentTime >= lrcLine.time && currentTime < nextLrcLine.time && self.currentIndex != i) {
            // 3.1 获取i位置的indexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            if (self.currentIndex > i) { // 如果不判断一下的话，切换到下一首的时候，可能因为lastIndexPath的刷新出错。因为下一首歌的行数可能小于之前保存的self.currentIndex
                self.currentIndex = i;
            }
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];

            // 记录当前显示行
            self.currentIndex = i;
            
            // 让歌词文字变大
            // 刷新i位置的cell
            [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            // 设置外面歌词label的显示文字
            self.extraLrcLabel.text = lrcLine.text;
            
            [self drawLockImage];
        }
        
        // 让文字有渐变过程
        if (self.currentIndex == i) {
            // 取出对应的cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            PornNetLrcCell *lrcCell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // 计算当前的进度
            CGFloat progress = (currentTime - lrcLine.time) / (nextLrcLine.time - lrcLine.time);
            lrcCell.lrcLabel.progress = progress;
            
            // 设置外面歌词label的进度
            self.extraLrcLabel.progress = progress;
        }
    }
}

#pragma mark -  <绘制锁屏界面图片>
- (void)drawLockImage
{
    // 1.取出三句歌词
    // 1.1.取出当前句歌词
    PornNetLrcLine *currentLrcLine = self.lrcLines[self.currentIndex];
    
    // 1.2 取出上一句歌词
    NSInteger lastLrcIndex = self.currentIndex - 1;
    PornNetLrcLine *lastLrcLine = nil;
    if (lastLrcIndex >= 0) {
        lastLrcLine = self.lrcLines[lastLrcIndex];
    }
    // 1.3 取出下一句歌词
    NSInteger nextLrcIndex = self.currentIndex + 1;
    PornNetLrcLine *nextLrcLine = nil;
    if (nextLrcIndex < self.lrcLines.count) {
        nextLrcLine = self.lrcLines[nextLrcIndex];
    }
    
    // 2.取出当前歌曲的icon对应的UIImage对象
    PornNetMusic *playingMusic = [PornNetMusicTool playingMusic];
    UIImage *playingImage = [UIImage imageNamed:playingMusic.icon];
    
    // 3.开始绘制
    // 3.1.开启上下文
    UIGraphicsBeginImageContextWithOptions(playingImage.size, YES, 0);
    // 3.2.将图片绘制到上下文中
    [playingImage drawInRect:CGRectMake(0, 0, playingImage.size.width, playingImage.size.height)];
    
    // 3.3.将三句歌词绘制到上下文中
    // 3.3.1 歌词的文字属性
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attributes setObject:[UIFont systemFontOfSize:14.0] forKey:NSFontAttributeName];
    // 3.3.1.1 居中显示
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    [attributes setObject:style forKey:NSParagraphStyleAttributeName];
    // 3.3.2 定义一些常量
    CGFloat width = playingImage.size.width;
    CGFloat height = playingImage.size.height;
    CGFloat textHeight = 25;
    // 3.3.3 绘制当前句
    CGRect currentRect = CGRectMake(0, height - 2 * textHeight, width, textHeight);
    [currentLrcLine.text drawInRect:currentRect withAttributes:attributes];
    // 3.3.4 绘制上一句
    CGRect lastRect = CGRectMake(0, height - 3 * textHeight, width, textHeight);
    [lastLrcLine.text drawInRect:lastRect withAttributes:attributes];
    // 3.3.5 绘制下一句
    CGRect nextRect = CGRectMake(0, height - textHeight, width, textHeight);
    [nextLrcLine.text drawInRect:nextRect withAttributes:attributes];
    
    // 4.生成新的图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    // 6.通知代理
    if ([self.lrcViewDelegate respondsToSelector:@selector(lrcView:image:)]) {
        [self.lrcViewDelegate lrcView:self image:lockImage];
    }
}


@end
