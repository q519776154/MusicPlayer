//
//  ParseLrcManager.h
//  音频播放器
//
//  Created by vera on 16/9/14.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ParseLrcManager : NSObject

+ (instancetype)sharedLrcManager;

/**
 *  时间
 */
@property (nonatomic, strong) NSMutableArray *timeArray;

/**
 *  歌词
 */
@property (nonatomic, strong) NSMutableArray *wordArray;

/**
 *  开始解析歌词
 *
 *  @param lrc 歌词
 */
- (void)parseLrc:(NSString *)lrc;

/**
 *  当前在歌词的哪一行
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfLineWithCurrentTime:(CGFloat)currentTime;

@end
