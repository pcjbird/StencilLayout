//
//  StencilModel.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/9.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilModel.h"

@implementation StencilItem

-(BOOL)parseData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) return FALSE;
    return TRUE;
}

@end

@implementation StencilSection

-(BOOL)parseData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) return FALSE;
    return TRUE;
}

@end
