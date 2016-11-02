//
//  AudioPlayerManager.m
//  音视频播放器
//
//  Created by qianfeng on 16/9/14.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "AudioPlayerManager.h"

@interface AudioPlayerManager ()<AVAudioPlayerDelegate>
{
    //是否正在播放
    BOOL _isPlaying;
}

//音频播放器
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation AudioPlayerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //开启音频后台播放
        AVAudioSession *session = [AVAudioSession sharedInstance];
        //激活音频会话
        [session setActive:YES error:nil];
        //设置后台类型
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}

+ (instancetype)sharedAudioPlayer
{
    static AudioPlayerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

/**
 *  初始化播放器
 *
 *  @param url <#url description#>
 */
- (void)initPlayerWithUrl:(NSURL *)url
{
    
    //该类只能播放本地视频
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.delegate = self;
    //准备播放，减少缓冲时间
    [_audioPlayer prepareToPlay];
}

#pragma mark - 播放
/**
 *  播放
 */
- (void)play
{
    [_audioPlayer play];
    
    _isPlaying = YES;
}

#pragma mark - 暂停
/**
 *  暂停
 */
- (void)pause
{
    [_audioPlayer pause];
    
    _isPlaying = NO;
}

#pragma mark - 是否正在播放
/**
 *  是否正在播放
 *
 */
- (BOOL)isPlaying
{
    return _isPlaying;
}

#pragma mark - 修改播放器时间
/**
 *  修改播放器时间
 *
 *  @param currentTime <#currentTime description#>
 */
- (void)updateAudioPlayerCurrentTime:(CGFloat)currentTime
{
    _audioPlayer.currentTime = currentTime;
}

#pragma mark - 总时间
/**
 *  总时间
 *
 *  @return <#return value description#>
 */
- (NSTimeInterval)duration
{
    return _audioPlayer.duration;
}

#pragma mark - 获取当前时间
/**
 *  获取当前时间
 *
 *  @return <#return value description#>
 */
- (NSTimeInterval)currentTime
{
    return _audioPlayer.currentTime;
}

#pragma mark - AVAudioPlayerDelegate
/**
 *  播放完成的回调
 *
 *  @param player <#player description#>
 *  @param flag   <#flag description#>
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag)
    {
        //回调，切换下一首
    }
}


@end











