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
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    // Do any additional setup after loading the view.
}

- (void)btnClick:(id)sender{
    ViewController * view = [[ViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
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
