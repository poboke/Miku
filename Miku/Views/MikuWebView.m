//
//  MikuWebView.m
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import "MikuWebView.h"

@implementation MikuWebView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        
        self.drawsBackground = NO;
        
        // 连接本地的异次元空间，因为加载远程的异次元空间速度太慢
        NSString *pluginPath = @"~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/Miku.xcplugin";
        NSBundle *pluginBundle = [NSBundle bundleWithPath:[pluginPath stringByExpandingTildeInPath]];
        NSString *htmlPath = [pluginBundle pathForResource:@"index"
                                                    ofType:@"html"
                                               inDirectory:@"miku-dancing.coding.io"];
        NSURL *htmlUrl = [NSURL fileURLWithPath:htmlPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:htmlUrl];
        [self.mainFrame loadRequest:request];
    }
    
    return self;
}


- (NSView *)hitTest:(NSPoint)aPoint
{
    // http://stackoverflow.com/questions/9073975/cocoa-webview-ignore-mouse-events-in-areas-without-content
    
    return (NSView *)[self nextResponder];
}


- (void)play
{
    [self stringByEvaluatingJavaScriptFromString:@"control.play()"];
}


- (void)pause
{
    [self stringByEvaluatingJavaScriptFromString:@"control.pause()"];
}


- (void)addPlayingTime:(NSInteger)seconds
{
    NSString *script = [NSString stringWithFormat:@"control.addFrame(%li)", seconds];
    [self stringByEvaluatingJavaScriptFromString:script];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
