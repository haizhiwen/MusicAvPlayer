//
//  LyricManager.m
//  今日头图
//
//  Created by 王亚军 on 2017/6/7.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"
#import "LyricPickerView.h"

@interface LyricManager ()

@end

@implementation LyricManager

+ (LyricManager *)sharedManager{
    static LyricManager * manager = nil;
    if (!manager) {
        manager = [[LyricManager alloc] init];
    }
    return manager;
}

- (NSData *)getDataPathWithUrl:(NSString*)urlString{
    NSData * _data;
    
    NSString * cachePath = [self getCachePath];
    
    NSString* filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lrc",[urlString pathExtension]]];
    
    NSInteger size = [[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] objectForKey:NSFileSize] integerValue];
    
    if (!size) {
        NSFileManager* mgr = [NSFileManager defaultManager];
        [mgr createFileAtPath:filePath contents:nil attributes:nil];
        NSFileHandle * write = [NSFileHandle fileHandleForWritingAtPath:filePath];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [write writeData:data];
        _data = data;
    }else{
        _data = [NSData dataWithContentsOfFile:filePath];
    }
    
    return _data;
}

/**
 获取文件夹目录是否存在
 */
- (NSString *)getCachePath{
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *lyricPath = [NSString stringWithFormat:@"%@/musiclyric",caches];
    if (![[NSFileManager defaultManager] fileExistsAtPath:lyricPath]) {
        NSError *error = nil;
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:lyricPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (isSuccess) {
            NSLog(@"创建成功:%@",lyricPath);
        }else{
            NSLog(@"创建%@ 失败=%@",lyricPath,error);
        }
    }else{
        NSLog(@"文件夹存在:%@",lyricPath);
    }
    return lyricPath;
}

- (NSMutableArray *)getMusicLyricInfoDetailWithLyricUrl:(NSString *)url{
    NSMutableArray * pickerArray = [NSMutableArray array];
    
    NSData * data = [self getDataPathWithUrl:url];
    NSString *contentString = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    
    NSArray *array = [contentString componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < [array count]; i++) {
        NSString *lineString = [array objectAtIndex:i];
        
        NSArray *lineArray = [lineString componentsSeparatedByString:@"]"];
        
        if ([lineArray[0] length] > 8) {
            ////[00:00.010]
            NSString *str1 = [lineString substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [lineString substringWithRange:NSMakeRange(6, 1)];
            
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                
                for (int i = 0; i < lineArray.count - 1; i++) {
                    
                    NSString *lrcString = [lineArray objectAtIndex:lineArray.count - 1];
                    
                    //分割区间求歌词时间
                    NSString *timeString = [[LyricManager sharedManager] timeToSecond:[lineArray objectAtIndex:i]];
                    
                    LyricModel * model = [[LyricModel alloc] init];
                    model.time = timeString;
                    model.message = lrcString;
                    [pickerArray addObject:model];
                }
            }
        }else if ([[lineArray objectAtIndex:0] length] > 5){
            
            NSString *str1 = [lineString substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [lineString substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"]"]) {
                NSRange starRange = [lineString rangeOfString:@"["];
                NSRange stopRange = [lineString rangeOfString:@"]"];
                NSString *timeString = [lineString substringWithRange:NSMakeRange(starRange.location , stopRange.location + 1)];
                
                NSString *minString = [timeString substringWithRange:NSMakeRange(1, 2)];
                NSString *secString = [timeString substringWithRange:NSMakeRange(4, 2)];
                if ([secString integerValue] == 0) {
                    if ([minString integerValue] == 0) {
                        NSLog(@"continue");
                        continue;
                    }
                }
                //                float timeLength = [minString floatValue] * 60 + [secString floatValue] / 1000;
                
                NSString *timeString2 = [[LyricManager sharedManager] timeToSecond2:timeString];
                
                NSString *lrcString = [lineArray objectAtIndex:lineArray.count - 1];
                
                LyricModel * model = [[LyricModel alloc] init];
                model.time = timeString2;
                model.message = lrcString;
                [pickerArray addObject:model];
                
            }
        }
    }
    return pickerArray;
}
-(NSString *)timeToSecond:(NSString *)formatTime {
    if (!formatTime || formatTime.length <= 0)
        return nil;
    if ([formatTime rangeOfString:@"["].length <= 0 && [formatTime rangeOfString:@"]"].length <= 0)
        return nil;

    NSString * minutes = [formatTime substringWithRange:NSMakeRange(1, 2)];
    NSString * second = [formatTime substringWithRange:NSMakeRange(4, 5)];
    float finishSecond = minutes.floatValue * 60 + second.floatValue;
    return [NSString stringWithFormat:@"%.2f",finishSecond];
}

-(NSString *)timeToSecond2:(NSString *)formatTime {
    if (!formatTime || formatTime.length <= 0)
        return nil;
    if ([formatTime rangeOfString:@"["].length <= 0 && [formatTime rangeOfString:@"]"].length <= 0)
        return nil;
    
    NSString * minutes = [formatTime substringWithRange:NSMakeRange(1, 2)];
    NSString * second = [formatTime substringWithRange:NSMakeRange(4, 2)];
    float finishSecond = minutes.floatValue * 60 + second.floatValue;
    return [NSString stringWithFormat:@"%.2f",finishSecond];
}

@end
