//
//  LyricPickerView.m
//  MusicAvPlayer
//
//  Created by 王亚军 on 2017/6/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "LyricPickerView.h"
#import "LyricModel.h"

@implementation LyricPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
- (void)setPickeDataArray:(NSMutableArray *)pickeDataArray{
    _pickeDataArray = pickeDataArray;
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

@end
