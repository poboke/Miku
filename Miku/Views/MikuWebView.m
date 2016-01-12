//
//  MikuWebView.m
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import "MikuWebView.h"

@implementation MikuWebView

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


- (void)addFrame:(NSInteger)frame
{
    NSString *script = [NSString stringWithFormat:@"control.addFrame(%li)", frame];
    [self stringByEvaluatingJavaScriptFromString:script];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
