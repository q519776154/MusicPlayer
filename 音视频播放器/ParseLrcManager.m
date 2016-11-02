//
//  ParseLrcManager.m
//  音频播放器
//
//  Created by vera on 16/9/14.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "ParseLrcManager.h"

@implementation ParseLrcManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeArray = [NSMutableArray array];
        _wordArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedLrcManager
{
    static ParseLrcManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

/**
 *  开始解析歌词
 *
 *  @param lrc 歌词
 */
- (void)parseLrc:(NSString *)lrc
{
    //清除其他歌词
    [self.timeArray removeAllObjects];
    [self.wordArray removeAllObjects];
    
    NSArray *sepArray = [lrc componentsSeparatedByString:@"["];
        
    for (int i = 1; i < sepArray.count; i++)
    {
        NSArray *lrcArr = [sepArray[i] componentsSeparatedByString:@"]"];
        
        if (lrcArr.count == 2)
        {
            //添加时间
            [self.timeArray addObject:lrcArr[0]];
            //添加歌词
            [self.wordArray addObject:lrcArr[1]];
        }
    }
}

/**
 *  当前在歌词的哪一行
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfLineWithCurrentTime:(CGFloat)currentTime
{
    NSInteger index = 0;
    
    for (int i = 0; i < self.timeArray.count; i++)
    {
        NSArray *arr = [self.timeArray[i] componentsSeparatedByString:@":"];
        
        if (arr.count == 2)
        {
            //把时间转换为秒
            CGFloat seconds = [arr[0] intValue] * 60 + [arr[1] floatValue];
            
            if (seconds < currentTime)
            {
                index = i;
            }
            else
            {
                break;
            }
        }
    }
    
    return index;
}

@end
