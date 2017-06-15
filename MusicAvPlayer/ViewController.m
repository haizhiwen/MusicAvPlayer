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
    
    [self initPlayer];
    [self configUI];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)initPlayer{
    self.avPlayer = [MusicAVPlayer sharedMucisPlayer];
    NSString * lyric = @"http://www.4coder.cn/api/getLyricPath.ashx?groupId=6595";
    NSString * music = @"http://ting666.yymp3.net:81/new6/huangjiaju/5.mp3";
    [self.avPlayer musicPlayerWithUrl:music andLyricUrl:lyric];
}
- (void)configUI{
    AvPlayerView * view = self.avPlayer.playerView;
    view.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width,  [[UIScreen mainScreen] bounds].size.height - 120);
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
