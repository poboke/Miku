//
//  Miku.h
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import "MikuDragView.h"
#import <AppKit/AppKit.h>

@interface Miku : NSObject

@property (nonatomic, assign, getter=isEnablePlugin) BOOL enablePlugin;
@property (nonatomic, strong) MikuDragView* mikuDragView;

+ (instancetype)sharedPlugin;

@end
