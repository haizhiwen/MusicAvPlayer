//
//  AvPlayerView.h
//  今日头图
//
//  Created by 王亚军 on 2017/6/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol PauseOrPlayerDelegate <NSObject>

- (void)setContinueGoOn:(BOOL)goOn;

@end

@interface AvPlayerView : UIView

@property (nonatomic, weak) id<PauseOrPlayerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *pickeDataArray;

- (void)handleProgress:(CMTime)time
              AndTotal:(float)total;


@end
