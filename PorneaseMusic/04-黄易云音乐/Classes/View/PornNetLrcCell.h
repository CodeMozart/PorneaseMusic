//
//  PornNetLrcCell.h
//  04-黄易云音乐
//
//  Created by Minghe on 11/3/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PornNetLrcLabel;
@interface PornNetLrcCell : UITableViewCell

@property (weak, nonatomic) PornNetLrcLabel *lrcLabel;/**< 歌词的label */

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
