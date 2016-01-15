//
//  Miku.h
//  Miku
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2016年 Jobs. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "MikuDragView.h"

@interface Miku : NSObject

@property (nonatomic, assign, getter=isEnablePlugin) BOOL enablePlugin;
@property (nonatomic, strong) MikuDragView *mikuDragView;

+ (instancetype)sharedPlugin;

@end
