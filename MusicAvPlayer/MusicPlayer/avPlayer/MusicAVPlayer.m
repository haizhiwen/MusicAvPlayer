//
//  MusicAVPlayer.m
//  今日头图
//
//  Created by 王亚军 on 2017/6/8.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "MusicAVPlayer.h"
#import "LyricManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MusicAVPlayer ()<PauseOrPlayerDelegate>

@property(nonatomic, strong) id         timeObserve;
@property (nonatomic, copy) NSString *  musicUrl;

@property(nonatomic, assign) float currentTime;
@property(nonatomic, assign) BOOL isPlayering;

@end

@implementation MusicAVPlayer

+ (MusicAVPlayer *)sharedMucisPlayer{
    static MusicAVPlayer * player = nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        player = [[MusicAVPlayer alloc]init];
        
    });
    return player;
}

- (AvPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[AvPlayerView alloc] init];
        _playerView.delegate = self;
    }
    return _playerView;
}
- (void)musicPlayerWithUrl:(NSString *)musicUrl
               andLyricUrl:(NSString *)lyricurl{
    if ([musicUrl isEqualToString:_musicUrl]) {
        return;
    }
    ///获取歌词，赋值给view
    NSMutableArray *lyricArray = [[LyricManager sharedManager] getMusicLyricInfoDetailWithLyricUrl:lyricurl];
    [self.playerView setPickeDataArray:lyricArray];
    ///初始化播放器
    _musicUrl = musicUrl;
    [self initPlayer];
}
- (void)reset{
    [self pause];
    [self.currentItem removeObserver:self forKeyPath:@"status"];
    [self.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self replaceCurrentItemWithPlayerItem:nil];
    if (self.timeObserve) {
        [self removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initPlayer{
    [self reset];
    
    NSURL * url  = [NSURL URLWithString:self.musicUrl];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        [self setAutomaticallyWaitsToMinimizeStalling:NO];
    }
    [self replaceCurrentItemWithPlayerItem:songItem];
    
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weakSelf handleProgress:time];
    }];
    [self.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];

    [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
}
- (void)handleProgress:(CMTime)time{
    _currentTime = CMTimeGetSeconds(time);
    if (self.musicProgressBlock) {
        self.musicProgressBlock(time);
    }
    float total = CMTimeGetSeconds(self.currentItem.duration);
    [self.playerView handleProgress:time AndTotal:total];
}


//协议中的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:( void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:{
                //                self.status = SUPlayStatusReadyToPlay;
                NSLog(@"KVO：准备完毕，可以播放");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.currentItem seekToTime:CMTimeMake(0, 1)];
                    _isPlayering = YES;
                    [self play];
                });
            } break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        AVPlayerItem * songItem = object;

        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSLog(@"共缓冲%.2f",totalBuffer);

    }
}
- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"播放完成");
    if ( self.timeObserve) {
        [self removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.musicUrl = nil;
}
- (void)setContinueGoOn:(BOOL)goOn{
    _isPlayering = goOn;
    if (goOn) {
        [self play];
    }else{
        [self pause];
    }
}

//设置锁屏状态，显示的歌曲信息
- (void)configNowPlayingInfoCenter{
    //         NSDictionary *info = [self.musicList objectAtIndex:_playIndex];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //歌曲名称
    [dict setObject:@"不再犹豫" forKey:MPMediaItemPropertyTitle];
    
    //演唱者
    [dict setObject:@"黄家驹" forKey:MPMediaItemPropertyArtist];
    
    //专辑名
    [dict setObject:@"爱你一生" forKey:MPMediaItemPropertyAlbumTitle];
    
    //专辑缩略图
    UIImage *image = [UIImage imageNamed:@"img1.jpg"];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
    [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    
    //音乐剩余时长
//    [dict setObject:[NSNumber numberWithDouble:(CMTimeGetSeconds(self.currentItem.duration)-_currentTime)] forKey:MPMediaItemPropertyPlaybackDuration];
    
    //音乐当前播放时间 在计时器中修改
//    [dict setObject:[NSNumber numberWithDouble:_currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    //设置锁屏状态下屏幕显示播放音乐信息
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

@end
