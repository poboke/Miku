//
//  IDESourceCodeEditor+Hook.m
//  ActivatePowerMode
//
//  Created by Jobs on 16/1/11.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import "IDESourceCodeEditor+Miku.h"
#import "Miku.h"

@implementation IDESourceCodeEditor (Miku)

+ (void)hookMiku
{
    [self jr_swizzleMethod:@selector(viewDidLoad)
                withMethod:@selector(miku_viewDidLoad)
                     error:nil];
    
    [self jr_swizzleMethod:@selector(textView:shouldChangeTextInRange:replacementString:)
                withMethod:@selector(miku_textView:shouldChangeTextInRange:replacementString:)
                     error:nil];
}


- (void)miku_viewDidLoad
{
    [self miku_viewDidLoad];
    
    // 创建超时空结界空间
    MikuDragView *mikuDragView = [Miku sharedPlugin].mikuDragView;
    [self.containerView addSubview:mikuDragView];
}


- (BOOL)miku_textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    // 给Miku充能量
    MikuWebView *mikuWebView = [Miku sharedPlugin].mikuDragView.mikuWebView;
    [mikuWebView setPlayingTime:10];
    
    return [self miku_textView:textView shouldChangeTextInRange:affectedCharRange replacementString:replacementString];
}

@end
