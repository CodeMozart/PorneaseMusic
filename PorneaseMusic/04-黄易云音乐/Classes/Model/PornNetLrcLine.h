//
//  PornNetLrcLine.h
//  04-黄易云音乐
//
//  Created by Minghe on 11/3/15.
//  Copyright © 2015 AVFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PornNetLrcLine : NSObject
@property (assign, nonatomic) NSTimeInterval time;/**< <#注释#> */
@property (copy, nonatomic) NSString *text;/**< <#注释#> */

- (instancetype)initWithLrcString:(NSString *)lrclineString;
+ (instancetype)lrcLineWithString:(NSString *)lrclineString;
@end
