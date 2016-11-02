//
//  ViewController.m
//  音频播放器
//
//  Created by vera on 16/9/13.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "AudioPlayerManager.h"
#import "ParseLrcManager.h"

@interface ViewController ()
{
    NSTimer *_timer;
    
    /**
     *  当前播放mp3的序号
     */
    NSInteger _currentIndex;
    
    /**
     *  当前位于歌词的哪一行
     */
    NSInteger _numberOfLine;
}

/**
 *  进度
 */
@property (weak, nonatomic) IBOutlet UISlider *progessSlider;

/**
 *  音频总时间
 */
@property (nonatomic, assign) NSTimeInterval duration;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

/**
 *  显示歌词
 */
@property (weak, nonatomic) IBOutlet UITableView *lrcTableView;

/**
 *  总时间
 */
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;


/**
 *  播放列表
 */
@property (nonatomic, strong) NSMutableArray *playListArray;

- (IBAction)progessHandle:(UISlider *)sender;
- (IBAction)preButtonClick:(UIButton *)sender;
- (IBAction)nextButtonClick:(UIButton *)sender;

@end

@implementation ViewController



#pragma mark - 懒加载
- (NSMutableArray *)playListArray
{
    if (!_playListArray)
    {
        _playListArray = [NSMutableArray arrayWithObjects:@"梁静茹-偶阵雨",@"林俊杰-背对背拥抱",@"情非得已", nil];
    }
    
    return _playListArray;
}

/**
 *  获取音频的url
 *
 *  @param fileName <#fileName description#>
 *
 *  @return <#return value description#>
 */
- (NSURL *)urlWithFileName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    return [NSURL fileURLWithPath:path];
}

/**
 *  读取歌词内容
 *
 *  @param fileName <#fileName description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)lrcStringFromFileName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    /**
     *  修改滑块的图片
     */
    [self configSlider];
    
    /**
     *  初始化播放器
     */
    [self initPlayer];
    
    
    //上一首按钮不可用
    self.preButton.enabled = NO;
    
    //如果数组只有一首，则下首按钮也不可用
    if (self.playListArray.count == 1)
    {
        self.nextButton.enabled = NO;
    }
    
    /**
     *  初始化定时器
     */
    [self initTimer];
    
    /**
     *  解析歌词
     */
    [self parseLrc];
    
    [self.lrcTableView registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"Cell"];
}

/**
 *  解析歌词
 */
- (void)parseLrc
{
    NSString *name = [NSString stringWithFormat:@"%@.lrc",self.playListArray[_currentIndex]];
    [[ParseLrcManager sharedLrcManager] parseLrc:[self lrcStringFromFileName:name]];
    
    //刷新tableView
    [self.lrcTableView reloadData];
}

- (void)configSlider
{
    [self.progessSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
}

/**
 *  初始化播放器
 */
- (void)initPlayer
{
    NSString *mp3Name = [NSString stringWithFormat:@"%@.mp3",self.playListArray[_currentIndex]];
    
    //初始化播放播放器
    [[AudioPlayerManager sharedAudioPlayer] initPlayerWithUrl:[self urlWithFileName:mp3Name]];
    
    //总时间
    self.duration = [[AudioPlayerManager sharedAudioPlayer] duration];
    self.durationLabel.text = [self timeFormatterWithSeconds:self.duration];
    
}

/**
 *  初始化定时器
 */
- (void)initTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgessHandle) userInfo:nil repeats:YES];
    //暂停定时器
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - 更新进度和当前时间
- (void)updateProgessHandle
{
    //1.获取当前时间
    NSTimeInterval currentTime = [[AudioPlayerManager sharedAudioPlayer] currentTime];
    
    //2.获取格式化的时间
    NSString *timeString = [self timeFormatterWithSeconds:currentTime];
    
    //3.更新当前时间
    self.currentTimeLabel.text = timeString;
    
    //4.更新进度
    self.progessSlider.value = currentTime / self.duration;
    
    //5.更新歌词位置
    _numberOfLine = [[ParseLrcManager sharedLrcManager] numberOfLineWithCurrentTime:currentTime];
    
    //6.刷新tableView
    [self.lrcTableView reloadData];
    
    //7.使当前行位于中间
    [self.lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_numberOfLine inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

/**
 *  返回格式化的时间，mm:ss
 *
 *  @return <#return value description#>
 */
- (NSString *)timeFormatterWithSeconds:(NSTimeInterval)seconds
{
    int m = seconds / 60;
    int s = (int)seconds % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",m,s];
    
}

#pragma mark - 播放
/**
 *  播放
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    //播放
    if (sender.selected)
    {
        [[AudioPlayerManager sharedAudioPlayer] play];
        //启动定时器
        [_timer setFireDate:[NSDate distantPast]];
    }
    //暂停
    else
    {
        [[AudioPlayerManager sharedAudioPlayer] pause];
        
        //暂停定时器
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark - 修改进度
- (IBAction)progessHandle:(UISlider *)sender
{
    //范围0到1
    CGFloat value = sender.value;
    
    //修改时间
    [[AudioPlayerManager sharedAudioPlayer] updateAudioPlayerCurrentTime:_duration * value];
}

#pragma mark - 上一首
- (IBAction)preButtonClick:(UIButton *)sender
{
    self.nextButton.enabled = YES;
    
    //已经是第一首了
    if (_currentIndex <= 0)
    {
        return;
    }
    
   
    _currentIndex--;
    
    
    if (_currentIndex <= 0)
    {
        sender.enabled = NO;
    }
   
    
    
    //初始化播放器
    [self initPlayer];
    //解析歌词
    [self parseLrc];
    
    AudioPlayerManager *manager = [AudioPlayerManager sharedAudioPlayer];
    
    if ([manager isPlaying])
    {
        //播放
        [manager play];
    }
    
}

#pragma mark - 下一首
- (IBAction)nextButtonClick:(UIButton *)sender
{
    self.preButton.enabled = YES;
    
    //已经是最后一首了
    if (_currentIndex >= self.playListArray.count - 1)
    {
        
        return;
    }
    
    
    _currentIndex++;
    
    
    if (_currentIndex >= self.playListArray.count - 1)
    {
        sender.enabled = NO;
    }
    
    
    //初始化播放器
    [self initPlayer];
    //解析歌词
    [self parseLrc];
    
    
    AudioPlayerManager *manager = [AudioPlayerManager sharedAudioPlayer];
    
    if ([manager isPlaying])
    {
        //播放
        [manager play];
    }
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ParseLrcManager sharedLrcManager].wordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [ParseLrcManager sharedLrcManager].wordArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_numberOfLine == indexPath.row)
    {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

@end
