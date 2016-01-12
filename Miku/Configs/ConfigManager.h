//
//  ConfigManager.h
//  ActivatePowerMode
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigManager : NSObject

@property (nonatomic, assign, getter=isEnablePlugin) BOOL enablePlugin;

+ (instancetype)sharedManager;

@end
