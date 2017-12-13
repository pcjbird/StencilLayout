//
//  StencilSectionManager.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StencilLayoutDefine.h"
#import "StencilInfo.h"

@interface StencilSectionManager : NSObject
{
    NSMutableDictionary* sectionStyles;
}

-(void) initSectionStyles:(NSString*) fileName background:(BOOL)isBackground complete:(StencilLayoutVoidBlock)block;
-(void) initSectionStyles:(NSString*) fileName background:(BOOL)isBackground withNotify:(BOOL)bNotify complete:(StencilLayoutVoidBlock)block;
-(StencilSectionStyle *)GetSectionStyle:(NSString*)styleId;

+(StencilSectionManager *)sharedInstance;

@end
