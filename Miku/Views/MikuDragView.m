//
//  MikuDragView.m
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import "MikuDragView.h"
#import "MikuConfigManager.h"

@interface MikuDragView() <WebFrameLoadDelegate>

@property (nonatomic, assign) NSPoint lastDragLocation;

@end


@implementation MikuDragView

- (instancetype)init
{
    if (self = [super initWithFrame:NSMakeRect(500, 50, 200, 300)]) {
        
        self.hidden = YES;
        
        // 使用WebView导通器连接异次元
        self.mikuWebView = [[MikuWebView alloc] initWithFrame:self.bounds];
        self.mikuWebView.frameLoadDelegate = self;
        [self addSubview:self.mikuWebView];
    }
    
    return self;
}


- (void)mouseDown:(NSEvent *)theEvent
{
    // http://stackoverflow.com/questions/7195835/nsview-dragging-the-view
    
    // Convert to superview's coordinate space
    self.lastDragLocation = [self.superview convertPoint:[theEvent locationInWindow] fromView:nil];
}


/**
 *  添加负离子防御罩，启用时空拖拽
 *
 *  @param theEvent
 */
- (void)mouseDragged:(NSEvent *)theEvent
{
    // We're working only in the superview's coordinate space, so we always convert.
    NSPoint newDragLocation = [self.superview convertPoint:[theEvent locationInWindow] fromView:nil];
    NSPoint thisOrigin = self.frame.origin;
    thisOrigin.x += (-self.lastDragLocation.x + newDragLocation.x);
    thisOrigin.y += (-self.lastDragLocation.y + newDragLocation.y);
    [self setFrameOrigin:thisOrigin];
    
    self.lastDragLocation = newDragLocation;
}


/**
 *  设置是否隐藏，隐藏时停止动作，显示时继续动作
 *
 *  @param hidden 是否隐藏
 */
- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if (hidden) {
        [self.mikuWebView pause];
    } else {
        [self.mikuWebView play];
    }
}


/**
 *  异次元空间加载完毕的代码
 *
 *  @param sender
 *  @param frame
 */
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    //等待异次元空间加载完毕，设置用户选择的属性
    MikuConfigManager *configManager = [MikuConfigManager sharedManager];
    [self.mikuWebView setMusicType:configManager.musicType];
    [self.mikuWebView setIsKeepDancing:configManager.isEnableKeepDancing];
    [self setCustomPlayList];
}


/**
 *  设置用户自定义的播放列表
 */
- (void)setCustomPlayList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *musicFolderPath = [NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES) lastObject];
    if (![fileManager fileExistsAtPath:musicFolderPath]) {
        return;
    }
    
    // 获取音乐文件夹下所有的音乐
    NSMutableArray *musicPaths = [[NSMutableArray alloc] init];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:musicFolderPath];
    NSString *musicSubPath;
    while (musicSubPath = [directoryEnumerator nextObject]) {
        if ([musicSubPath hasSuffix:@".mp3"]) {
            NSString *musicPath = [musicFolderPath stringByAppendingPathComponent:musicSubPath];
            musicPath = [musicPath stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
            musicPath = [NSString stringWithFormat:@"'%@'", musicPath];
            [musicPaths addObject:musicPath];
        }
    }
    
    if (musicPaths.count == 0) {
        return;
    }
    
    NSString *songs = [musicPaths componentsJoinedByString:@","];
    NSString *script = [NSString stringWithFormat:@"control.setPlayList([%@])", songs];
    [self.mikuWebView stringByEvaluatingJavaScriptFromString:script];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
