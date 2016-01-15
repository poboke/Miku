//
//  ConfigManager.m
//  ActivatePowerMode
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import "ConfigManager.h"

static NSString * const MikuPluginConfigKeyEnablePlugin = @"MikuPluginConfigKeyEnablePlugin";
static NSString * const MikuPluginConfigMusicEnablePlugin = @"MikuPluginConfigMusicEnablePlugin";

@implementation ConfigManager

@synthesize enablePlugin = _enablePlugin;
@synthesize enableMusic = _enableMusic;

+ (instancetype)sharedManager
{
    static ConfigManager *_sharedManager;
    
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

- (BOOL)isEnableMusic
{
    if (!_enableMusic) {
        
        NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:MikuPluginConfigMusicEnablePlugin];
        
        if (!value) {
            // First time runing
            self.enableMusic = YES;
        } else {
            _enablePlugin = [value boolValue];
        }
    }
    
    return _enablePlugin;
}


- (void)setEnableMusic:(BOOL)enableMusic
{
    _enableMusic = enableMusic;
    [self setBoolValue:enableMusic forKey:MikuPluginConfigMusicEnablePlugin];
}

@end
