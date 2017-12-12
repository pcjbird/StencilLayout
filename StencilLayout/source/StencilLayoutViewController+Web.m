//
//  StencilLayoutViewController+Web.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/10.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilLayoutViewController+Web.h"

@implementation StencilLayoutViewController (Web)

-(nonnull NSString*)prepareForWebUrl:(nonnull NSString*)pageUrl
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewController:prepareWebUrl:)])
    {
        pageUrl = [self.delegate stencilLayoutViewController:self prepareWebUrl:pageUrl];
        return pageUrl;
    }
    return pageUrl;
}

@end
