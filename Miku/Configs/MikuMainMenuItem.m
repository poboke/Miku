//
//  MikuMainMenuItem.m
//  ActivatePowerMode
//
//  Created by Jobs on 16/1/15.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import "MikuMainMenuItem.h"
#import "MikuConfigManager.h"
#import "MikuWebView.h"
#import "Miku.h"

typedef NS_ENUM(NSUInteger, MenuItemType) {
    kMenuItemTypeEnablePlugin = 1,
    kMenuItemTypeEnableKeepDancing,
    kMenuItemTypePlayItunesMusic,
    kMenuItemTypeEnableMusicDefault,
    kMenuItemTypeEnableMusicNormal,
    kMenuItemTypeEnableMusicMute,
    kMenuItemTypeUpdateItunesPlist,
};


@interface MikuMainMenuItem ()

@property (nonatomic, strong) NSMenuItem *keepDancingMenuItem;

@property (nonatomic, strong) NSMenuItem *musicMenuItem;
@property (nonatomic, strong) NSMenuItem *musicDefaultMenuItem;
@property (nonatomic, strong) NSMenuItem *musicNormalMenuItem;
@property (nonatomic, strong) NSMenuItem *musicMuteMenuItem;

@property (nonatomic, strong) NSMenuItem *playItunesMusicMenuItem;
@property (nonatomic, strong) NSMenuItem *updateItunesMusicMenuItem;

@end


@implementation MikuMainMenuItem

- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = [NSString stringWithFormat:@"Miku (v%@)", PluginVersion];
        
        NSMenu *configMenu = [[NSMenu alloc] init];
        configMenu.autoenablesItems = NSOffState;
        self.submenu = configMenu;
        
        MikuConfigManager *configManager = [MikuConfigManager sharedManager];
        
        NSMenuItem *pluginMenuItem = [self menuItemWithTitle:@"Enable" type:kMenuItemTypeEnablePlugin];
        pluginMenuItem.state = configManager.isEnablePlugin;
        [configMenu addItem:pluginMenuItem];
        
        self.keepDancingMenuItem = [self menuItemWithTitle:@"Enable keep Dancing" type:kMenuItemTypeEnableKeepDancing];
        self.keepDancingMenuItem.state = configManager.isEnableKeepDancing;
        self.keepDancingMenuItem.enabled = configManager.isEnablePlugin;
        [configMenu addItem:self.keepDancingMenuItem];
        
        self.playItunesMusicMenuItem = [self menuItemWithTitle:@"Play iTunes Music" type:kMenuItemTypePlayItunesMusic];
        self.playItunesMusicMenuItem.state = configManager.isPlayItunesMusic;
        self.playItunesMusicMenuItem.enabled = configManager.isEnablePlugin;
        [configMenu addItem:self.playItunesMusicMenuItem];
        
        self.updateItunesMusicMenuItem = [self menuItemWithTitle:@"Update iTunes Music Plist" type:kMenuItemTypeUpdateItunesPlist];
        [configMenu addItem:self.updateItunesMusicMenuItem];
        
        // MusicType Menu Item Begin
        
        self.musicMenuItem = [[NSMenuItem alloc] init];
        self.musicMenuItem.title = @"Music Type";
        self.musicMenuItem.enabled = configManager.isEnablePlugin;
        [configMenu addItem:self.musicMenuItem];
        
        NSMenu *musicConfigMenu = [[NSMenu alloc] init];
        musicConfigMenu.autoenablesItems = NSOffState;
        self.musicMenuItem.submenu = musicConfigMenu;
        
        MikuMusicType musicType = configManager.musicType;
        
        self.musicDefaultMenuItem = [self menuItemWithTitle:@"Default  🔈" type:kMenuItemTypeEnableMusicDefault];
        self.musicDefaultMenuItem.state = (musicType == MikuMusicTypeDefault);
        [musicConfigMenu addItem:self.musicDefaultMenuItem];
        
        self.musicNormalMenuItem = [self menuItemWithTitle:@"Normal  🔊" type:kMenuItemTypeEnableMusicNormal];
        self.musicNormalMenuItem.state = (musicType == MikuMusicTypeNormal);
        [musicConfigMenu addItem:self.musicNormalMenuItem];
        
        self.musicMuteMenuItem = [self menuItemWithTitle:@"Mute      🔇" type:kMenuItemTypeEnableMusicMute];
        self.musicMuteMenuItem.state = (musicType == MikuMusicTypeMute);
        [musicConfigMenu addItem:self.musicMuteMenuItem];
        
        // MusicType Menu Item End
        

        
    }
    
    return self;
}


- (NSMenuItem *)menuItemWithTitle:(NSString *)title type:(MenuItemType)type
{
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    menuItem.title = title;
    menuItem.tag = type;
    menuItem.state = NSOffState;
    menuItem.target = self;
    menuItem.action = @selector(clickMenuItem:);
    return menuItem;
}


- (void)clickMenuItem:(NSMenuItem *)menuItem
{
    menuItem.state = !menuItem.state;
    
    MikuConfigManager *configManager = [MikuConfigManager sharedManager];
    MikuWebView *mikuWebView = [Miku sharedPlugin].mikuDragView.mikuWebView;
    
    MenuItemType type = menuItem.tag;
    
    switch (type) {
            
        case kMenuItemTypeEnablePlugin: {
            configManager.enablePlugin = !configManager.isEnablePlugin;
            [Miku sharedPlugin].enablePlugin = configManager.isEnablePlugin;
            self.keepDancingMenuItem.enabled = configManager.isEnablePlugin;
            self.musicMenuItem.enabled = configManager.isEnablePlugin;
            break;
        }
            
        case kMenuItemTypeEnableKeepDancing: {
            configManager.enableKeepDancing = !configManager.isEnableKeepDancing;
            [mikuWebView setIsKeepDancing:configManager.isEnableKeepDancing];
            break;
        }
            
        case kMenuItemTypePlayItunesMusic: {
            configManager.playItunesMusic = !configManager.isPlayItunesMusic;
            [mikuWebView setIsPlayItunesMusic:configManager.isPlayItunesMusic];
            break;
        }
            
        case kMenuItemTypeEnableMusicDefault: {
            configManager.musicType = MikuMusicTypeDefault;
            [mikuWebView setMusicType:configManager.musicType];
            self.musicNormalMenuItem.state = NSOffState;
            self.musicMuteMenuItem.state = NSOffState;
            break;
        }
            
        case kMenuItemTypeEnableMusicNormal: {
            configManager.musicType = MikuMusicTypeNormal;
            [mikuWebView setMusicType:configManager.musicType];
            self.musicDefaultMenuItem.state = NSOffState;
            self.musicMuteMenuItem.state = NSOffState;
            break;
        }
            
        case kMenuItemTypeEnableMusicMute: {
            configManager.musicType = MikuMusicTypeMute;
            [mikuWebView setMusicType:configManager.musicType];
            self.musicDefaultMenuItem.state = NSOffState;
            self.musicNormalMenuItem.state = NSOffState;
            break;
        }
        
        case kMenuItemTypeUpdateItunesPlist: {
            [self touchUpInsideCreateItunesMenuItem];
            configManager.playItunesMusic = YES;
            [mikuWebView setIsPlayItunesMusic:configManager.isPlayItunesMusic];
            self.updateItunesMusicMenuItem.state = NSOffState;
            self.playItunesMusicMenuItem.state = NSOnState;
            break;
        }
    }
}

- (void)touchUpInsideCreateItunesMenuItem
{
    // Do any additional setup after loading the view.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *mikuConfigPath = [@"~/MikuConfig" stringByExpandingTildeInPath];
    if (![fileManager fileExistsAtPath:mikuConfigPath]) {
        [fileManager createDirectoryAtPath:mikuConfigPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *mikuConfigPlistPath = [mikuConfigPath stringByAppendingPathComponent:@"/MikuConfig.plist"];
    if (![fileManager fileExistsAtPath:mikuConfigPlistPath]) {
        [fileManager createFileAtPath:mikuConfigPlistPath contents:nil attributes:nil];
    }
    
    NSError *error = [[NSError alloc]init];
    NSMutableArray *itunesMusicPaths = [NSMutableArray array];
    //Get Music Path
    NSString *userMusicPath =  NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, true).firstObject;
    //Get Vocalist
    NSString *vocalistSearchPath = [userMusicPath stringByAppendingPathComponent:@"/iTunes/iTunes Media/Music"];
    NSArray *vocalistPathArray = [fileManager contentsOfDirectoryAtPath:vocalistSearchPath error:&error];
    //
    for (NSString *path in vocalistPathArray) {
        //Get Album
        if (![path hasPrefix:@"."]) {
            NSString *ablumSearchPath = [vocalistSearchPath stringByAppendingPathComponent:path];
            NSArray *ablumPathArray = [fileManager contentsOfDirectoryAtPath:ablumSearchPath error:&error];
            //Get Music
            for (NSString *path in ablumPathArray) {
                if (![path hasPrefix:@"."]) {
                    NSString *musicSearchPath = [ablumSearchPath stringByAppendingPathComponent:path];
                    NSArray *musicPathArray = [fileManager contentsOfDirectoryAtPath:musicSearchPath error:&error];
                    for (NSString *path in musicPathArray) {
                        if ([path hasSuffix:@"mp3"] || [path hasSuffix:@"m4a"]) {
                            [itunesMusicPaths addObject:[musicSearchPath stringByAppendingPathComponent:path]];
                        }
                    }
                }
            }
        }
    }
    //Rewrite the config plist
    NSDictionary *mikuConfig = [[NSDictionary alloc] initWithContentsOfFile:mikuConfigPlistPath];
    [mikuConfig setValue:itunesMusicPaths forKey:@"iTunesMusicNames"];
    [mikuConfig writeToFile:mikuConfigPlistPath atomically:YES];
}

@end
