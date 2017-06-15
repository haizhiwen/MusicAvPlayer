//
//  ViewController.m
//  MusicAvPlayer
//
//  Created by 王亚军 on 2017/6/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "ViewController.h"
#import "MusicAVPlayer.h"
#import "AvPlayerView.h"

@interface ViewController ()

@property (nonatomic, strong) MusicAVPlayer * avPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self configUI];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[MusicAVPlayer sharedMucisPlayer] configNowPlayingInfoCenter];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)initPlayerWithMusicUrl:(NSString *)musicurl
                      LyricUrl:(NSString *)lyricurl{
    self.avPlayer = [MusicAVPlayer sharedMucisPlayer];
    [self.avPlayer musicPlayerWithUrl:musicurl andLyricUrl:lyricurl];
}
- (void)configUI{
    AvPlayerView * view = self.avPlayer.playerView;
    view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width,  [[UIScreen mainScreen] bounds].size.height - 120);
    [self.view addSubview:view];
}



#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:
                NSLog(@"播放");

//                if (!_isPlayering) {
//                    [self.avPlayer play];
//                }
//                _isPlayering = !_isPlayering;
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"暂停");

//                if (_isPlayering) {
//                    [self pause];
//                }
//                _isPlayering = !_isPlayering;
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首 ");
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
