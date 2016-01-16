//
//  MikuWebView.m
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import "MikuWebView.h"

@interface MikuWebView () <NSDraggingDestination>
@end


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


#pragma mark - Controls

/**
 *  播放
 */
- (void)play
{
    [self stringByEvaluatingJavaScriptFromString:@"control.play()"];
}


/**
 *  暂停
 */
- (void)pause
{
    [self stringByEvaluatingJavaScriptFromString:@"control.pause()"];
}


/**
 *  设置播放时间
 *
 *  @param seconds 秒数
 */
- (void)setPlayingTime:(NSInteger)seconds
{
    NSString *script = [NSString stringWithFormat:@"control.addFrame(%li)", seconds];
    [self stringByEvaluatingJavaScriptFromString:script];
}


/**
 *  设置是否一直跳舞，是的话就不会出现慢动作
 *
 *  @param isKeepDancing 是否一直跳舞
 */
- (void)setIsKeepDancing:(BOOL)isKeepDancing
{
    NSString *script = [NSString stringWithFormat:@"control.dance(%i)", isKeepDancing];
    [self stringByEvaluatingJavaScriptFromString:script];
}


/**
 *  设置音乐类型
 *
 *  @param musicType 音乐类型
 */
- (void)setMusicType:(MikuMusicType)musicType
{
    switch (musicType) {
            
        case MikuMusicTypeDefault:
            [self stringByEvaluatingJavaScriptFromString:@"control.mute(false)"];
            [self stringByEvaluatingJavaScriptFromString:@"control.music(false)"];
            break;
            
        case MikuMusicTypeNormal:
            [self stringByEvaluatingJavaScriptFromString:@"control.mute(false)"];
            [self stringByEvaluatingJavaScriptFromString:@"control.music(true)"];
            break;
            
        case MikuMusicTypeMute:
            [self stringByEvaluatingJavaScriptFromString:@"control.mute(true)"];
            break;
    }
}


#pragma mark - Drag music onto miku

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    
    if ([pasteboard.types containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}


- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pasteboard = [sender draggingPasteboard];

    NSArray *list = [pasteboard propertyListForType:NSFilenamesPboardType];
    NSString *fileURL = list.firstObject;

    NSString *script = [NSString stringWithFormat:@"control.setPlayList(['%@'])", fileURL];
    [self stringByEvaluatingJavaScriptFromString:script];
    
    return NO;
}

@end
