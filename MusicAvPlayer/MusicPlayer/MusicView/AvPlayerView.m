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

        [self addSubview:self.lyricView];
    }
    return self;
}

#pragma mark view
- (LyricPickerView *)lyricView{
    if (!_lyricView) {
        _lyricView = [[LyricPickerView alloc] init];
        _lyricView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.width - 200 + 50 , [[UIScreen mainScreen] bounds].size.width,120);
        _lyricView.delegate = self;
        _lyricView.dataSource = self;
        _lyricView.userInteractionEnabled = NO;
    }
    return _lyricView;
}
- (void)setPickeDataArray:(NSMutableArray *)pickeDataArray{
    _pickeDataArray = pickeDataArray;
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
#pragma mark pickerView delegate
//调用协议中的方法
//   <1>设置选择器控件显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//   <2>设置选择器显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickeDataArray count];
}
//   设置每行显示的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //根据行号获取数组中对应的内容
    //行号的下标从0开始
    LyricModel * model = [_pickeDataArray objectAtIndex:row];
    return model.message;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 15;
}
//-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    LyricModel * model = [_pickerArray objectAtIndex:row];
//    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:model.message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
//    return string;
//}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
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
