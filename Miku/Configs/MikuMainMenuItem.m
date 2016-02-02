//
//  MikuMainMenuItem.m
//  ActivatePowerMode
//
//  Created by Jobs on 16/1/15.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import "Miku.h"
#import "MikuConfigManager.h"
#import "MikuMainMenuItem.h"
#import "MikuWebView.h"

@interface MikuMainMenuItem ()

@property(nonatomic, strong) NSMenu *configMenu;
@property(nonatomic, strong) NSMenuItem *pluginMenuItem;
@property(nonatomic, strong) NSMenuItem *playControlMenuItem;
@property(nonatomic, strong) NSMenuItem *playTypeMenuItem;
@property(nonatomic, strong) NSMenuItem *musicSourceMenuItem;
@property(nonatomic, strong) NSMenuItem *keepDancingMenuItem;
@property(nonatomic, strong) NSMenuItem *musicTypeMenuItem;
//
@property(nonatomic, strong) NSMenu *playControlMenu;
@property(nonatomic, strong) NSMenuItem *playControlBeforeMenuItem;
@property(nonatomic, strong) NSMenuItem *playControlReplayMenuItem;
@property(nonatomic, strong) NSMenuItem *playControlAfterMenuItem;
//
@property(nonatomic, strong) NSMenu *playTypeMenu;
@property(nonatomic, strong) NSMenuItem *playTypeSequenceMenuItem;
@property(nonatomic, strong) NSMenuItem *playTypeRandomMenuItem;
@property(nonatomic, strong) NSMenuItem *playTypeSingleMenuItem;
//
@property(nonatomic, strong) NSMenu *musicSourceMenu;
@property(nonatomic, strong) NSMenuItem *musicSourceCustomMenuItem;
@property(nonatomic, strong) NSMenuItem *musicSourceItunesMenuItem;
//
@property(nonatomic, strong) NSMenu *musicTypeMenu;
@property(nonatomic, strong) NSMenuItem *musicDefaultMenuItem;
@property(nonatomic, strong) NSMenuItem *musicNormalMenuItem;
@property(nonatomic, strong) NSMenuItem *musicMuteMenuItem;
//
@property(nonatomic, weak) MikuConfigManager *configManager;
@property(nonatomic, weak) MikuWebView *mikuWebView;

@end

@implementation MikuMainMenuItem

- (instancetype)init {
  if (self = [super init]) {
    _configManager = [MikuConfigManager sharedManager];
    _mikuWebView = [Miku sharedPlugin].mikuDragView.mikuWebView;

    [self instituteMenu];
    [self institutePlayTypeSubMenu];
    [self institutePlayControlSubMenu];
    [self instituteMusicTypeSubMenu];
    [self instituteMusicSouceSubMenu];
  }

  return self;
}

- (void)instituteMenu {
  self.title = [NSString stringWithFormat:@"Miku (v%@)", PluginVersion];

  _configMenu = [[NSMenu alloc] init];
  _configMenu.autoenablesItems = NSOffState;
  self.submenu = _configMenu;

  // Init Main Menu Item
  _pluginMenuItem =
      [self menuItemWithTitle:@"Enable" action:@selector(clickPluginMenuItem)];
  _pluginMenuItem.state = _configManager.isEnablePlugin;

  _keepDancingMenuItem =
      [self menuItemWithTitle:@"Enable keep Dancing"
                       action:@selector(clickKeepDancingMenuItem)];
  _keepDancingMenuItem.state = _configManager.isEnableKeepDancing;
  _keepDancingMenuItem.enabled = _configManager.isEnablePlugin;

  _playControlMenuItem = [self menuItemWithTitle:@"Play Control" action:nil];
  _playControlMenuItem.enabled = _configManager.isEnablePlugin;

  _playTypeMenuItem = [self menuItemWithTitle:@"Play Type" action:nil];
  _playTypeMenuItem.enabled = _configManager.isEnablePlugin;

  _musicSourceMenuItem = [self menuItemWithTitle:@"Music Source" action:nil];
  _musicSourceMenuItem.enabled = _configManager.isEnablePlugin;

  _musicTypeMenuItem = [self menuItemWithTitle:@"Music Type" action:nil];
  _musicTypeMenuItem.enabled = _configManager.isEnablePlugin;
  // Add Main Menu Item
  [_configMenu addItem:_pluginMenuItem];
  [_configMenu addItem:_keepDancingMenuItem];
  [_configMenu addItem:_playControlMenuItem];
  [_configMenu addItem:_playTypeMenuItem];
  [_configMenu addItem:_musicSourceMenuItem];
  [_configMenu addItem:_musicTypeMenuItem];
}

- (void)instituteMusicTypeSubMenu {
  // MusicType Menu Item Begin

  _musicTypeMenu = [[NSMenu alloc] init];
  _musicTypeMenu.autoenablesItems = NSOffState;
  _musicTypeMenuItem.submenu = _musicTypeMenu;

  MikuMusicType musicType = _configManager.musicType;

  _musicDefaultMenuItem =
      [self menuItemWithTitle:@"Slow With Miku  🔈"
                       action:@selector(clickMusicDefaultMenuItem)];
  _musicDefaultMenuItem.state = (musicType == MikuMusicTypeDefault);

  _musicNormalMenuItem =
      [self menuItemWithTitle:@"Not Slow With Miku  🔊"
                       action:@selector(clickMusicNormalMenuItem)];
  _musicNormalMenuItem.state = (musicType == MikuMusicTypeNormal);

  _musicMuteMenuItem =
      [self menuItemWithTitle:@"Mute      🔇"
                       action:@selector(clickMusicMuteMenuItem)];
  _musicMuteMenuItem.state = (musicType == MikuMusicTypeMute);

  [_musicTypeMenu addItem:_musicDefaultMenuItem];
  [_musicTypeMenu addItem:_musicNormalMenuItem];
  [_musicTypeMenu addItem:_musicMuteMenuItem];

  // MusicType Menu Item End
}

- (void)instituteMusicSouceSubMenu {
  _musicSourceMenu = [[NSMenu alloc] init];
  _musicSourceMenu.autoenablesItems = NSOffState;
  _musicSourceMenuItem.submenu = _musicSourceMenu;

  MikuMusicSource musicSource = _configManager.musicSource;

  _musicSourceCustomMenuItem =
      [self menuItemWithTitle:@"Custom Music"
                       action:@selector(clickMusicSourceCustomMenuItem)];
  _musicSourceCustomMenuItem.state = (musicSource == MikuMusicSourceCustom);

  _musicSourceItunesMenuItem =
      [self menuItemWithTitle:@"iTunes Music"
                       action:@selector(clickMusicSourceItunesMenuItem)];
  _musicSourceItunesMenuItem.state = (musicSource == MikuMusicSourceItunes);

  [_musicSourceMenu addItem:_musicSourceCustomMenuItem];
  [_musicSourceMenu addItem:_musicSourceItunesMenuItem];
}

- (void)institutePlayControlSubMenu {
  _playControlMenu = [[NSMenu alloc] init];
  _playControlMenu.autoenablesItems = NSOffState;
  _playControlMenuItem.submenu = _playControlMenu;

  _playControlBeforeMenuItem =
      [self menuItemWithTitle:@"Last Music"
                       action:@selector(clickPlayControlBeforeMenuItem)];
  _playControlReplayMenuItem =
      [self menuItemWithTitle:@"Replay Music"
                       action:@selector(clickPlayControlReplayMenuItem)];
  _playControlAfterMenuItem =
      [self menuItemWithTitle:@"Next Music"
                       action:@selector(clickPlayControlAfterMenuItem)];

  [_playControlMenu addItem:_playControlBeforeMenuItem];
  [_playControlMenu addItem:_playControlReplayMenuItem];
  [_playControlMenu addItem:_playControlAfterMenuItem];
}

- (void)institutePlayTypeSubMenu {
  _playTypeMenu = [[NSMenu alloc] init];
  _playTypeMenu.autoenablesItems = NSOffState;
  _playTypeMenuItem.submenu = _playTypeMenu;

  MikuPlayType playType = _configManager.playType;

  _playTypeSequenceMenuItem =
      [self menuItemWithTitle:@"Sequence"
                       action:@selector(clickPlayTypeSequenceMenuItem)];
  //上次关闭时单曲循环就重新从头播放
  _playTypeSequenceMenuItem.state =
      (playType == MikuPlayTypeSequence || playType == MikuPlayTypeSingle);

  _playTypeRandomMenuItem =
      [self menuItemWithTitle:@"Random"
                       action:@selector(clickPlayTypeRandomMenuItem)];
  _playTypeRandomMenuItem.state = (playType == MikuPlayTypeRandom);

  _playTypeSingleMenuItem =
      [self menuItemWithTitle:@"Single"
                       action:@selector(clickPlayTypeSingleMenuItem)];
  _playTypeSingleMenuItem.state = NSOffState;

  [_playTypeMenu addItem:_playTypeSequenceMenuItem];
  [_playTypeMenu addItem:_playTypeRandomMenuItem];
  [_playTypeMenu addItem:_playTypeSingleMenuItem];
}

- (NSMenuItem *)menuItemWithTitle:(NSString *)title action:(SEL)action {
  NSMenuItem *menuItem = [[NSMenuItem alloc] init];
  menuItem.title = title;
  menuItem.state = NSOffState;
  menuItem.target = self;
  menuItem.action = action;
  return menuItem;
}

#pragma mark - Play Control Action

- (void)clickPluginMenuItem {
  _pluginMenuItem.state = !_pluginMenuItem.state;

  _configManager.enablePlugin = !_configManager.isEnablePlugin;
  [Miku sharedPlugin].enablePlugin = _configManager.isEnablePlugin;

  for (int i = 1; i < _configMenu.numberOfItems; ++i) {
    NSMenuItem *tempItem = _configMenu.itemArray[i];
    tempItem.enabled = _configManager.isEnablePlugin;
  }
}

- (void)clickKeepDancingMenuItem {
  _keepDancingMenuItem.state = !_keepDancingMenuItem.state;
  _configManager.enableKeepDancing = !_configManager.isEnableKeepDancing;
  [_mikuWebView setIsKeepDancing:_configManager.isEnableKeepDancing];
}

#pragma mark - Play Control Action

- (void)clickPlayControlBeforeMenuItem {
  [_mikuWebView musicPlayControl:MikuPlayControlBefore];
}

- (void)clickPlayControlReplayMenuItem {
  [_mikuWebView musicPlayControl:MikuPlayControlRePlay];
}

- (void)clickPlayControlAfterMenuItem {
  [_mikuWebView musicPlayControl:MikuPlayControlAfter];
}

#pragma mark - Play Type Action

- (void)clickPlayTypeSequenceMenuItem {
  if (!_playTypeSingleMenuItem.state) {
    _configManager.playType = MikuPlayTypeSequence;
    [_mikuWebView setMusicPlayType:MikuPlayTypeSequence];
  }

  _playTypeSequenceMenuItem.state = NSOnState;
  _playTypeRandomMenuItem.state = NSOffState;
  _playTypeSingleMenuItem.state = NSOffState;
}

- (void)clickPlayTypeRandomMenuItem {
  if (!_playTypeRandomMenuItem.state) {
    _configManager.playType = MikuPlayTypeRandom;
    [_mikuWebView setMusicPlayType:MikuPlayTypeRandom];
  }

  _playTypeSequenceMenuItem.state = NSOffState;
  _playTypeRandomMenuItem.state = NSOnState;
  _playTypeSingleMenuItem.state = NSOffState;
}

- (void)clickPlayTypeSingleMenuItem {
  if (!_playTypeSingleMenuItem.state) {
    _configManager.playType = MikuPlayTypeSingle;
    [_mikuWebView setMusicPlayType:MikuPlayTypeSingle];
  }

  _playTypeSequenceMenuItem.state = NSOffState;
  _playTypeRandomMenuItem.state = NSOffState;
  _playTypeSingleMenuItem.state = NSOnState;
}

#pragma mark - Music Source Action

- (void)clickMusicSourceCustomMenuItem {
  _musicSourceCustomMenuItem.state = !_musicSourceCustomMenuItem.state;
  _musicSourceItunesMenuItem.state = NSOffState;

  if (_musicSourceCustomMenuItem.state) {
    _configManager.musicSource = MikuMusicSourceCustom;
    [_mikuWebView setMusicSource:_configManager.musicSource];
  } else {
    [_mikuWebView setMusicSource:MikuMusicSourceDefault];
  }
}

- (void)clickMusicSourceItunesMenuItem {
  _musicSourceItunesMenuItem.state = !_musicSourceItunesMenuItem.state;
  _musicSourceCustomMenuItem.state = NSOffState;

  if (_musicSourceItunesMenuItem.state) {
    _configManager.musicSource = MikuMusicSourceItunes;
    [_mikuWebView setMusicSource:_configManager.musicSource];
  } else {
    [_mikuWebView setMusicSource:MikuMusicSourceDefault];
  }
}

#pragma mark - Music Type Action

- (void)clickMusicDefaultMenuItem {
  _configManager.musicType = MikuMusicTypeDefault;
  [_mikuWebView setMusicType:_configManager.musicType];
  _musicDefaultMenuItem.state = NSOnState;
  _musicNormalMenuItem.state = NSOffState;
  _musicMuteMenuItem.state = NSOffState;
}

- (void)clickMusicNormalMenuItem {
  _configManager.musicType = MikuMusicTypeNormal;
  [_mikuWebView setMusicType:_configManager.musicType];
  _musicDefaultMenuItem.state = NSOffState;
  _musicNormalMenuItem.state = NSOnState;
  _musicMuteMenuItem.state = NSOffState;
}

- (void)clickMusicMuteMenuItem {
  _configManager.musicType = MikuMusicTypeMute;
  [_mikuWebView setMusicType:_configManager.musicType];
  _musicDefaultMenuItem.state = NSOffState;
  _musicNormalMenuItem.state = NSOffState;
  _musicMuteMenuItem.state = NSOnState;
}

@end
