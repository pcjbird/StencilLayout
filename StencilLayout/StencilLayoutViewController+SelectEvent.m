//
//  StencilLayoutViewController+SelectEvent.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/10.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilLayoutViewController+SelectEvent.h"
#import "StencilLayoutDefine.h"

@implementation StencilLayoutViewController (SelectEvent)

-(void) SelectStencilItem:(StencilItem*)item
{
    if(self.isIgnoreEvent)
    {
        SDKLog(@"忽略的点击事件，点击事件间隔：%fs。", self.clickTimeInterval);
        return;
    }
    if (self.clickTimeInterval > 0)
    {
        self.isIgnoreEvent = YES;
        [self performSelector:NSSelectorFromString(@"setIgnoreEvent:") withObject:@(NO) afterDelay:self.clickTimeInterval];
    }
    if([item isKindOfClass:[StencilItem class]] && self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewController:didSelectStencilItem:)])
    {
        [self.delegate stencilLayoutViewController:self didSelectStencilItem:item];
    }
}

@end
