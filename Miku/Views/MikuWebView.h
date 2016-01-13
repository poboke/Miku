//
//  MikuWebView.h
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface MikuWebView : WebView

@property (nonatomic, assign) NSInteger webViewTag;

- (void)play;
- (void)pause;
- (void)addPlayingTime:(NSInteger)seconds;

@end
