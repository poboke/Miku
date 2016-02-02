//
//  MikuDragView.m
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import "MikuConfigManager.h"
#import "MikuDragView.h"

@interface MikuDragView () <WebFrameLoadDelegate>

@property(nonatomic, assign) NSPoint lastDragLocation;

@end

@implementation MikuDragView

- (instancetype)init {
  if (self = [super initWithFrame:NSMakeRect(500, 50, 200, 300)]) {

    self.hidden = YES;

    // 使用WebView导通器连接异次元
    self.mikuWebView = [[MikuWebView alloc] initWithFrame:self.bounds];
    self.mikuWebView.frameLoadDelegate = self;
    [self addSubview:self.mikuWebView];
  }

  return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
  // http://stackoverflow.com/questions/7195835/nsview-dragging-the-view

  // Convert to superview's coordinate space
  self.lastDragLocation =
      [self.superview convertPoint:[theEvent locationInWindow] fromView:nil];
}

/**
 *  添加负离子防御罩，启用时空拖拽
 *
 *  @param theEvent
 */
- (void)mouseDragged:(NSEvent *)theEvent {
  // We're working only in the superview's coordinate space, so we always
  // convert.
  NSPoint newDragLocation =
      [self.superview convertPoint:[theEvent locationInWindow] fromView:nil];
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
- (void)setHidden:(BOOL)hidden {
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
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
  //等待异次元空间加载完毕，设置用户选择的属性
  MikuConfigManager *configManager = [MikuConfigManager sharedManager];
  [self.mikuWebView setMusicType:configManager.musicType];
  [self.mikuWebView setIsKeepDancing:configManager.isEnableKeepDancing];
  [self setCustomPlayList];
}

/**
 *  设置用户自定义的播放列表
 */
- (void)setCustomPlayList {
  //
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSMutableArray *itunesMusics = [NSMutableArray array];

  // Upadate iTunes Music
  // Get iTunes Music Path
  NSString *itunesMusicPath = [MikuConfigManager sharedManager].itunesMusicPath;
  // Get All iTunes Musics
  NSDirectoryEnumerator *myDirectoryEnumerator =
      [fileManager enumeratorAtPath:itunesMusicPath];
  NSString *musicSubPath;
  while ((musicSubPath = [myDirectoryEnumerator nextObject]) != nil) {
    if ([musicSubPath hasSuffix:@".mp3"] || [musicSubPath hasSuffix:@".m4a"]) {
      NSString *musicPath =
          [itunesMusicPath stringByAppendingPathComponent:musicSubPath];
      musicPath = [musicPath stringByReplacingOccurrencesOfString:@"'"
                                                       withString:@"\\'"];
      musicPath = [NSString stringWithFormat:@"'%@'", musicPath];
      [itunesMusics addObject:musicPath];
    }
  }
  // Check Plist Exist
  NSString *mikuConfigPlistPath =
      [MikuConfigManager sharedManager].configPlistPath;
  NSMutableDictionary *mikuConfig =
      [[NSMutableDictionary alloc] initWithContentsOfFile:mikuConfigPlistPath];
  if (!mikuConfig) {
    mikuConfig = [NSMutableDictionary dictionary];
  }
  // Rewrite the config plist
  [mikuConfig setValue:itunesMusics forKey:@"iTunesMusics"];
  [mikuConfig writeToFile:mikuConfigPlistPath atomically:YES];

  NSArray *fileCustomMusics = mikuConfig[@"CustomMusics"];
  NSMutableArray *customMusics = [NSMutableArray array];
  for (NSString *musicPath in fileCustomMusics) {
    NSMutableString *tempStr = [[NSMutableString alloc] initWithString:musicPath];
    [tempStr deleteCharactersInRange:NSMakeRange(0, 1)];
    [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length - 1, 1)];
    if ([fileManager fileExistsAtPath:tempStr]) {
      [customMusics addObject:musicPath];
    }
  }

  // Play Music
  _mikuWebView.customSource = [customMusics componentsJoinedByString:@","];
  _mikuWebView.itunesSrouce = [itunesMusics componentsJoinedByString:@","];
  if ([MikuConfigManager sharedManager].musicSource == MikuMusicSourceCustom && customMusics.count != 0) {
    [_mikuWebView setMusicSource:MikuMusicSourceCustom];
  } else if ([MikuConfigManager sharedManager].musicSource == MikuMusicSourceItunes && itunesMusics.count != 0) {
    [_mikuWebView setMusicSource:MikuMusicSourceItunes];
  } else {
    [_mikuWebView setMusicSource:MikuMusicSourceDefault];
  }

  if ([MikuConfigManager sharedManager].playType == MikuPlayTypeRandom) {
    [_mikuWebView setMusicPlayType:[MikuConfigManager sharedManager].playType];
    [_mikuWebView musicPlayControl:MikuPlayControlRePlay];
  } else if ([MikuConfigManager sharedManager].playType == MikuPlayTypeSingle) {
    //上次关闭时单曲循环就重新从头播放
    [MikuConfigManager sharedManager].playType = MikuPlayTypeSequence;
  }
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
}

@end
