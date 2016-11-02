//
//  AudioPlayerManager.h
//  音视频播放器
//
//  Created by qianfeng on 16/9/14.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
//导入头文件
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, AudioPlayerLoopType)
{
    /**
     *  单曲循环
     */
    AudioPlayerLoopTypeLoop = -1,
    
    /**
     *  顺序播放
     */
    AudioPlayerLoopTypeSerial = 0,
    
    /**
     *  随机播放
     */
    AudioPlayerLoopTypeRandom = 1
};

@interface AudioPlayerManager : NSObject

+ (instancetype)sharedAudioPlayer;

/**
 *  初始化播放器
 *
 *  @param url <#url description#>
 */
- (void)initPlayerWithUrl:(NSURL *)url;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

/**
 *  是否正在播放
 *
 */
- (BOOL)isPlaying;

/**
 *  修改播放器时间
 *
 *  @param currentTime <#currentTime description#>
 */
- (void)updateAudioPlayerCurrentTime:(CGFloat)currentTime;

/**
 *  总时间
 *
 *  @return <#return value description#>
 */
- (NSTimeInterval)duration;

/**
 *  获取当前时间
 *
 *  @return <#return value description#>
 */
- (NSTimeInterval)currentTime;




@end
