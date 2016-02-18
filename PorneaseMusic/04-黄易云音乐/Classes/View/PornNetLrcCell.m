//
//  PornNetLrcCell.m
//  04-黄易云音乐
//
//  Created by Minghe on 11/3/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import "PornNetLrcCell.h"
#import "PornNetLrcLabel.h"
#import "Masonry.h"

@implementation PornNetLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        PornNetLrcLabel *lrcLabel = [[PornNetLrcLabel alloc] init];
        [self.contentView addSubview:lrcLabel];
        self.lrcLabel = lrcLabel;
        
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.font = [UIFont systemFontOfSize:14.0];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LrcCell";
    PornNetLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PornNetLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
@end
