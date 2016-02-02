//
//  MikuConfigManager.h
//  ActivatePowerMode
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MikuConfigManager : NSObject

@property(nonatomic, assign, getter=isEnablePlugin) BOOL enablePlugin;
@property(nonatomic, assign, getter=isEnableKeepDancing) BOOL enableKeepDancing;
@property(nonatomic, assign) NSInteger musicType;
@property(nonatomic, assign) NSInteger musicSource;
@property(nonatomic, assign) NSInteger playType;

@property(nonatomic, copy, readonly) NSString *configPlistPath;
@property(nonatomic, copy, readonly) NSString *itunesMusicPath;

+ (instancetype)sharedManager;

@end
