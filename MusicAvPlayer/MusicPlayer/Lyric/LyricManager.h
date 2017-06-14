//
//  LyricManager.h
//  今日头图
//
//  Created by 王亚军 on 2017/6/7.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LyricPickerView;

@interface LyricManager : NSObject

+ (LyricManager *)sharedManager;

@property (nonatomic, strong) LyricPickerView * lyricView;

@property (nonatomic, assign) NSUInteger index;

- (NSMutableArray *)getMusicLyricInfoDetailWithLyricUrl:(NSString *)url;

//- (NSData *)getDataPathWithGroupId:(NSNumber *)groupId;

- (NSString *)timeToSecond:(NSString *)formatTime;

- (NSString *)timeToSecond2:(NSString *)formatTime ;

@end
