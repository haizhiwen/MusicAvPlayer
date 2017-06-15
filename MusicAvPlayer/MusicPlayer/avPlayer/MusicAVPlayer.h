//
//  MusicAVPlayer.h
//  今日头图
//
//  Created by 王亚军 on 2017/6/8.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AvPlayerView.h"

@interface MusicAVPlayer : AVPlayer

+ (MusicAVPlayer *)sharedMucisPlayer;

@property (nonatomic, strong) AvPlayerView * playerView;

- (void)musicPlayerWithUrl:(NSString *)musicUrl
               andLyricUrl:(NSString *)lyricurl;

@property(nonatomic, copy) void(^musicProgressBlock)(CMTime time);

- (void)configNowPlayingInfoCenter;

@end
