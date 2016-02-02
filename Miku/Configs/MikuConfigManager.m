//
//  MikuConfigManager.m
//  ActivatePowerMode
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import "MikuConfigManager.h"

static NSString *const MikuPluginConfigKeyEnablePlugin = @"MikuPluginConfigKeyEnablePlugin";
static NSString *const MikuPluginConfigKeyEnableKeepDancing = @"MikuPluginConfigKeyEnableKeepDancing";
static NSString *const MikuPluginConfigKeyMusicType = @"MikuPluginConfigKeyMusicType";
static NSString *const MikuPluginConfigKeyMusicSource = @"MikuPluginConfigKeyMusicSource";
static NSString *const MikuPluginConfigKeyPlayType = @"MikuPluginConfigKeyPlayType";
static NSString *const MikuPluginConfigKeyPlayControl = @"MikuPluginConfigKeyPlayControl";

@implementation MikuConfigManager

@synthesize enablePlugin = _enablePlugin;
@synthesize enableKeepDancing = _enableKeepDancing;
//
@synthesize musicType = _musicType;
@synthesize musicSource = _musicSource;
@synthesize playType = _playType;
//
@synthesize configPlistPath = _configPlistPath;
@synthesize itunesMusicPath = _itunesMusicPath;

+ (instancetype)sharedManager {
  static MikuConfigManager *_sharedManager;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[self alloc] init];
  });

  return _sharedManager;
}

#pragma mark - Syntax sugar

- (BOOL)boolValueForKey:(NSString *)aKey {
  return [[[NSUserDefaults standardUserDefaults] objectForKey:aKey] boolValue];
}

- (void)setBoolValue:(BOOL)boolValue forKey:(NSString *)aKey {
  [[NSUserDefaults standardUserDefaults] setObject:@(boolValue) forKey:aKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Property

- (BOOL)isEnablePlugin {
  if (!_enablePlugin) {

    NSNumber *value = [[NSUserDefaults standardUserDefaults]
        objectForKey:MikuPluginConfigKeyEnablePlugin];

    if (!value) {
      // First time runing
      self.enablePlugin = YES;
      self.enableKeepDancing = NO;
      self.musicType = 0;
      self.musicSource = 0;
      self.playType = 0;
      _enablePlugin = YES;
    } else {
      _enablePlugin = [value boolValue];
    }
  }

  return _enablePlugin;
}

- (void)setEnablePlugin:(BOOL)enablePlugin {
  _enablePlugin = enablePlugin;
  [self setBoolValue:enablePlugin forKey:MikuPluginConfigKeyEnablePlugin];
}

- (BOOL)isEnableKeepDancing {
  if (!_enableKeepDancing) {
    _enableKeepDancing =
        [self boolValueForKey:MikuPluginConfigKeyEnableKeepDancing];
  }

  return _enableKeepDancing;
}

- (void)setEnableKeepDancing:(BOOL)enableKeepDancing {
  _enableKeepDancing = enableKeepDancing;
  [self setBoolValue:enableKeepDancing
              forKey:MikuPluginConfigKeyEnableKeepDancing];
}

#pragma mark - Plugin Status

- (NSInteger)musicType {
  if (!_musicType) {
    NSNumber *value = [[NSUserDefaults standardUserDefaults]
        objectForKey:MikuPluginConfigKeyMusicType];
    _musicType = [value integerValue];
  }

  return _musicType;
}

- (void)setMusicType:(NSInteger)musicType {
  _musicType = musicType;
  [[NSUserDefaults standardUserDefaults]
      setObject:@(musicType)
         forKey:MikuPluginConfigKeyMusicType];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)musicSource {
  if (!_musicSource) {
    NSNumber *value = [[NSUserDefaults standardUserDefaults]
        objectForKey:MikuPluginConfigKeyMusicSource];
    _musicSource = [value integerValue];
  }

  return _musicSource;
}

- (void)setMusicSource:(NSInteger)musicSource {
  _musicSource = musicSource;
  [[NSUserDefaults standardUserDefaults]
      setObject:@(musicSource)
         forKey:MikuPluginConfigKeyMusicSource];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)playType {
  if (!_playType) {
    NSNumber *value = [[NSUserDefaults standardUserDefaults]
        objectForKey:MikuPluginConfigKeyPlayType];
    _playType = [value integerValue];
  }

  return _playType;
}

- (void)setPlayType:(NSInteger)playType {
  _playType = playType;
  [[NSUserDefaults standardUserDefaults] setObject:@(playType)
                                            forKey:MikuPluginConfigKeyPlayType];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Get Path

- (NSString *)configPlistPath {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  // Get Music Path
  NSString *userMusicPath = NSSearchPathForDirectoriesInDomains(
                                NSMusicDirectory, NSUserDomainMask, true)
                                .firstObject;
  // Check Plist Exist
  NSString *mikuConfigPlistPath =
      [userMusicPath stringByAppendingPathComponent:@"/MikuConfig.plist"];
  if (![fileManager fileExistsAtPath:mikuConfigPlistPath]) {
    [fileManager createFileAtPath:mikuConfigPlistPath
                         contents:nil
                       attributes:nil];
  }
  return mikuConfigPlistPath;
}

- (NSString *)itunesMusicPath {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  // Get Music Path
  NSString *userMusicPath = NSSearchPathForDirectoriesInDomains(
                                NSMusicDirectory, NSUserDomainMask, true)
                                .firstObject;
  // Get iTunes Music Path
  NSString *itunesMusicPath = [userMusicPath
      stringByAppendingPathComponent:@"/iTunes/iTunes Media/Music"];
  if (![fileManager fileExistsAtPath:itunesMusicPath]) {
    return @"";
  }
  return itunesMusicPath;
}

@end
