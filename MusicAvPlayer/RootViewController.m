//
//  RootViewController.m
//  MusicAvPlayer
//
//  Created by 王亚军 on 2017/6/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 100, [[UIScreen mainScreen] bounds].size.width - 100, 50);
    [btn setTitle:@"播放1" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag = 10;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton * btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(50, 200, [[UIScreen mainScreen] bounds].size.width - 100, 50);
    [btn1 setTitle:@"播放2" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.tag = 11;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];


    // Do any additional setup after loading the view.
}

- (void)btnClick:(UIButton *)sender{
    if (sender.tag == 10) {
        ViewController * view = [[ViewController alloc] init];
        NSString * lyric = @"http://www.4coder.cn/api/getLyricPath.ashx?groupId=6595";
        NSString * music = @"http://ting666.yymp3.net:81/new6/huangjiaju/5.mp3";
        [view initPlayerWithMusicUrl:music LyricUrl:lyric];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        ViewController * view = [[ViewController alloc] init];
        NSString * lyric = @"http://www.4coder.cn/api/getLyricPath.ashx?groupId=6395";
        NSString * music = @"http://ting666.yymp3.net:81/yymp3/01cn/03new/lishengjie1/003.mp3";
        [view initPlayerWithMusicUrl:music LyricUrl:lyric];
        [self.navigationController pushViewController:view animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
