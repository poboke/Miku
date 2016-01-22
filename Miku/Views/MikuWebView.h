//
//  MikuWebView.h
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import <WebKit/WebKit.h>

//音乐类型
typedef NS_ENUM(NSUInteger, MikuMusicType) {
    MikuMusicTypeDefault = 0,   //默认模式，慢动作时音乐播放会变慢
    MikuMusicTypeNormal,    //正常模式，慢动作时音乐播放不变慢
    MikuMusicTypeMute,      //静音模式
};

//音乐源
typedef NS_ENUM(NSUInteger, MikuMusicSource) {
    MikuMusicSourceDefault = 0,   //默认背景音乐
    MikuMusicSourceCustom,    //自定义背景音乐
    MikuMusicSourceItunes,    //iTunes背景音乐
};

//播放类型
typedef NS_ENUM(NSUInteger, MikuPlayType) {
    MikuPlayTypeSequence = 0,   //默认模式，按照顺序播放
    MikuPlayTypeRandom,     //随机模式
    MikuPlayTypeSingle,     //单曲循环
};

//播放控制
typedef NS_ENUM(NSUInteger, MikuPlayControl) {
    MikuPlayControlBefore = 0,   //上一首
    MikuPlayControlRePlay,   //重头开始
    MikuPlayControlAfter,    //下一首
};



@interface MikuWebView : WebView

- (void)play;
- (void)pause;
- (void)setPlayingTime:(NSInteger)seconds;
- (void)setIsKeepDancing:(BOOL)isKeepDancing;

- (void)setMusicType:(MikuMusicType)musicType;
- (void)setMusicSource:(MikuMusicSource)musicSource;
- (void)setMusicPlayType:(MikuPlayType)playType;
- (void)musicPlayControl:(MikuPlayControl)playControl;

@property (nonatomic, copy) NSString *customSource;
@property (nonatomic, copy) NSString *itunesSrouce;

@end
