//
//  MikuConfigManager.m
//  ActivatePowerMode
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import "MikuConfigManager.h"

static NSString * const MikuPluginConfigKeyEnablePlugin = @"MikuPluginConfigKeyEnablePlugin";
static NSString * const MikuPluginConfigKeyEnableKeepDancing = @"MikuPluginConfigKeyEnableKeepDancing";
static NSString * const MikuPluginConfigKeyMusicType = @"MikuPluginConfigKeyMusicType";

@implementation MikuConfigManager

@synthesize enablePlugin = _enablePlugin;
@synthesize enableKeepDancing = _enableKeepDancing;
@synthesize musicType = _musicType;

+ (instancetype)sharedManager
{
    static MikuConfigManager *_sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}


#pragma mark - Syntax sugar

- (BOOL)boolValueForKey:(NSString *)aKey
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:aKey] boolValue];
}


- (void)setBoolValue:(BOOL)boolValue forKey:(NSString *)aKey
{
    [[NSUserDefaults standardUserDefaults] setObject:@(boolValue) forKey:aKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Property

- (BOOL)isEnablePlugin
{
    if (!_enablePlugin) {
        
        NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:MikuPluginConfigKeyEnablePlugin];
        
        if (!value) {
            // First time runing
            self.enablePlugin = YES;
            self.enableKeepDancing = NO;
            self.musicType = 0;
            _enablePlugin = YES;
        } else {
            _enablePlugin = [value boolValue];
        }
    }
    
    return _enablePlugin;
}


- (void)setEnablePlugin:(BOOL)enablePlugin
{
    _enablePlugin = enablePlugin;
    [self setBoolValue:enablePlugin forKey:MikuPluginConfigKeyEnablePlugin];
}


- (BOOL)isEnableKeepDancing
{
    if (!_enableKeepDancing) {
        _enableKeepDancing = [self boolValueForKey:MikuPluginConfigKeyEnableKeepDancing];
    }
    
    return _enableKeepDancing;
}


- (void)setEnableKeepDancing:(BOOL)enableKeepDancing
{
    _enableKeepDancing = enableKeepDancing;
    [self setBoolValue:enableKeepDancing forKey:MikuPluginConfigKeyEnableKeepDancing];
}


- (NSInteger)musicType
{
    if (!_musicType) {
        NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:MikuPluginConfigKeyMusicType];
        _musicType = [value integerValue];
    }
    
    return _musicType;
}


- (void)setMusicType:(NSInteger)musicType
{
    _musicType = musicType;
    [[NSUserDefaults standardUserDefaults] setObject:@(musicType) forKey:MikuPluginConfigKeyMusicType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
