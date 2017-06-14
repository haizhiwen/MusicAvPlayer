//
//  MusicAVPlayer.m
//  今日头图
//
//  Created by 王亚军 on 2017/6/8.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "MusicAVPlayer.h"
#import "AvPlayerView.h"
#import "LyricManager.h"

@interface MusicAVPlayer ()<PauseOrPlayerDelegate>

@property(nonatomic, strong) id         timeObserve;
@property (nonatomic, copy) NSString *  musicUrl;

@end

@implementation MusicAVPlayer

+ (MusicAVPlayer *)sharedMucisPlayer{
    static MusicAVPlayer * player = nil;
    if (!player) {
        player = [[MusicAVPlayer alloc] init];
    }
    return player;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
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
    self.playerView.pickeDataArray = lyricArray;
    ///初始化播放器
    _musicUrl = musicUrl;
    [self initPlayer];
}
- (void)reset{
    [self pause];
    [self.currentItem removeObserver:self forKeyPath:@"status"];
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
    [self setAutomaticallyWaitsToMinimizeStalling:NO];
    [self replaceCurrentItemWithPlayerItem:songItem];
    
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weakSelf handleProgress:time];
    }];
    [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
}
- (void)handleProgress:(CMTime)time{
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self play];
                });
            } break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
}
- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"播放完成");
    if ( self.timeObserve) {
        [self removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
    self.musicUrl = nil;
}
- (void)setContinueGoOn:(BOOL)goOn{
    if (goOn) {
        [self play];
    }else{
        [self pause];
    }
}


@end
