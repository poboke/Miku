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
    MikuMusicTypeDefault,   //默认模式，慢动作时音乐播放会变慢
    MikuMusicTypeNormal,    //正常模式，慢动作时音乐播放不变慢
    MikuMusicTypeMute,      //静音模式
};

@interface MikuWebView : WebView

- (void)play;
- (void)pause;
- (void)setPlayingTime:(NSInteger)seconds;
- (void)setIsKeepDancing:(BOOL)isKeepDancing;
- (void)setMusicType:(MikuMusicType)musicType;

@end
