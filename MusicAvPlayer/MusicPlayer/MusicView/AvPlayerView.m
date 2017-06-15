//
//  AvPlayerView.m
//  今日头图
//
//  Created by 王亚军 on 2017/6/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "AvPlayerView.h"
#import "CircularProgressBar.h"
#import "LyricModel.h"
#import "LyricPickerView.h"

@interface AvPlayerView () <CircularProgressDelegate>
{
    CircularProgressBar *m_circularProgressBar;
}
@property (nonatomic, strong) LyricPickerView * lyricView;

@end

@implementation AvPlayerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        m_circularProgressBar = [[CircularProgressBar alloc] initWithFrame:CGRectMake(100, 50, [[UIScreen mainScreen] bounds].size.width - 200, [[UIScreen mainScreen] bounds].size.width - 200)];
        m_circularProgressBar.delegate = self;
        [self addSubview:m_circularProgressBar];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDetected)];
        singleTap.numberOfTapsRequired = 1;
        [m_circularProgressBar setUserInteractionEnabled:YES];
        [m_circularProgressBar addGestureRecognizer:singleTap];

        _lyricView = [[LyricPickerView alloc] init];
        _lyricView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.width - 200 + 50 , [[UIScreen mainScreen] bounds].size.width,120);
        _lyricView.userInteractionEnabled = NO;

        [self addSubview:_lyricView];
    }
    return self;
}

#pragma mark view

- (void)setPickeDataArray:(NSMutableArray *)pickeDataArray{
    _pickeDataArray = pickeDataArray;
    [self.lyricView setPickeDataArray:pickeDataArray];
    [self.lyricView reloadAllComponents];
    [self.lyricView selectRow:0 inComponent:0 animated:YES];
}

/**
 处理进度

 @param time 播放当前时间
 */
- (void)handleProgress:(CMTime)time AndTotal:(float)total{
    float current = CMTimeGetSeconds(time);
    if (current) {
        m_circularProgressBar.time_left = current;
 
        [self seleteIndexOfPickerView:current];
    }
    if (!m_circularProgressBar.totalTime) {
        if (total >= 0) {
            [m_circularProgressBar setTotalSecondTime:total];
            [m_circularProgressBar startTimer];
        }
    }
}
- (void)seleteIndexOfPickerView:(float)current{
    
    NSInteger index = [_lyricView selectedRowInComponent:0];
    if ([_pickeDataArray count] > index +1) {
        LyricModel * model = [_pickeDataArray objectAtIndex:index+1];
        NSLog(@"%f *****",[model.time floatValue]);
        NSLog(@"%f ____",current);
        float result = [model.time floatValue] - current;
        if (result < 0) {
            result = -result;
        }
        if (result < 0.5) {
            [_lyricView selectRow:index+1 inComponent:0 animated:YES];
        }
    }
}

#pragma mark progress delegate
- (void)singleTapDetected{
    NSLog(@"singleTapDetected");
    if (m_circularProgressBar.b_timerRunning) {
        if ([self.delegate respondsToSelector:@selector(setContinueGoOn:)]) {
            [self.delegate setContinueGoOn:NO];
        }
        [m_circularProgressBar pauseTimer];
    }else{
        if ([self.delegate respondsToSelector:@selector(setContinueGoOn:)]) {
            [self.delegate setContinueGoOn:YES];
        }
        [m_circularProgressBar startTimer];
    }
}

- (void)CircularProgressEnd{
}

@end
