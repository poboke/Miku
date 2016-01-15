//
//  Miku.m
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import "Miku.h"
#import "ConfigManager.h"
#import "IDESourceCodeEditor+Miku.h"

@interface Miku()
@end


@implementation Miku

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    // Load only into Xcode
    NSString *identifier = [NSBundle mainBundle].bundleIdentifier;
    if (![identifier isEqualToString:@"com.apple.dt.Xcode"]) {
        return;
    }
    
    [self sharedPlugin];
}


+ (instancetype)sharedPlugin
{
    static Miku *_sharedPlugin;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPlugin = [[self alloc] init];
    });
    
    return _sharedPlugin;
}


- (instancetype)init
{
    if (self = [super init]) {
        
        self.mikuDragView = [[MikuDragView alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
    }
    
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    [self addPluginsMenu];
    
    if ([ConfigManager sharedManager].isEnablePlugin) {
        [self switchEnablePlugin];
    }
}


- (void)addPluginsMenu
{
    // Add Plugins menu next to Window menu
    NSMenu *mainMenu = [NSApp mainMenu];
    NSMenuItem *pluginsMenuItem = [mainMenu itemWithTitle:@"Plugins"];
    if (!pluginsMenuItem) {
        pluginsMenuItem = [[NSMenuItem alloc] init];
        pluginsMenuItem.title = @"Plugins";
        pluginsMenuItem.submenu = [[NSMenu alloc] initWithTitle:pluginsMenuItem.title];
        NSInteger windowIndex = [mainMenu indexOfItemWithTitle:@"Window"];
        [mainMenu insertItem:pluginsMenuItem atIndex:windowIndex];
    }
    
    // Add Subitem
    NSMenuItem *subMenuItem = [[NSMenuItem alloc] init];
    subMenuItem.title = @"Enable Miku";
    subMenuItem.target = self;
    subMenuItem.action = @selector(toggleMenu:);
    subMenuItem.tag = MenuPluginItem;
    subMenuItem.state = [ConfigManager sharedManager].isEnablePlugin;
    [pluginsMenuItem.submenu addItem:subMenuItem];
    
    // Add Subitem
    NSMenuItem *musicMenuItem = [[NSMenuItem alloc] init];
    musicMenuItem.title = @"Enable Music";
    musicMenuItem.target = self;
    musicMenuItem.tag = MenuMusicItem;
    musicMenuItem.action = @selector(toggleMenu:);
    musicMenuItem.state = [ConfigManager sharedManager].isEnableMusic;
    [pluginsMenuItem.submenu addItem:musicMenuItem];
}


- (void)toggleMenu:(NSMenuItem *)menuItem
{
    menuItem.state = !menuItem.state;
    
    if (menuItem.tag == MenuPluginItem) {
        
        self.mikuDragView.hidden = !self.mikuDragView.isHidden;
        
        [ConfigManager sharedManager].enablePlugin = ![ConfigManager sharedManager].isEnablePlugin;
        
    } else {
        
        self.mikuDragView.mute = !menuItem.state;
        
        [ConfigManager sharedManager].enableMusic = ![ConfigManager sharedManager].isEnableMusic;
        
    }
}


- (void)switchEnablePlugin
{
    [IDESourceCodeEditor hookMiku];
    self.mikuDragView.hidden = !self.mikuDragView.isHidden;
    self.mikuDragView.mute = ![ConfigManager sharedManager].isEnableMusic;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
