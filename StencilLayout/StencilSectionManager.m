//
//  StencilSectionManager.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//
#import "StencilLayout.h"
#import "StencilSectionManager.h"
#import "StencilDataParseUtil.h"
static StencilSectionManager *_instance;


@interface StencilSectionManager()
{
}
@end

@implementation StencilSectionManager

+(StencilSectionManager *)sharedInstance
{
    @synchronized(self)
    {
        if(_instance==nil)
        {
            _instance=[[StencilSectionManager alloc]init];
        }
    }
    return _instance;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        sectionStyles = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void) initSectionStyles:(NSString*) fileName background:(BOOL)isBackground complete:(StencilLayoutVoidBlock)block
{
    [self initSectionStyles:fileName background:isBackground withNotify:NO complete:block];
}

-(void) initSectionStyles:(NSString*) fileName background:(BOOL)isBackground withNotify:(BOOL)bNotify complete:(StencilLayoutVoidBlock)block
{
    if(isBackground)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [weakSelf initSectionStyles:fileName withNotify:bNotify complete:block];
        });
    }
    else
    {
        [self initSectionStyles:fileName withNotify:bNotify complete:block];
    }
    
}

-(void) initSectionStyles:(NSString*) fileName withNotify:(BOOL)bNotify complete:(StencilLayoutVoidBlock)block
{
    NSFileManager*fileManager =[NSFileManager defaultManager];
    
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
    NSString*path =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",fileName]];
    
    BOOL (^copyFileBlock)(BOOL bExist) = ^BOOL(BOOL bExist){
        NSString*resourcePath =[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
        NSError*error;
        if(bExist)
        {
            [fileManager removeItemAtPath:path error:&error];
        }
        [fileManager copyItemAtPath:resourcePath toPath:path error:&error];
        if([error isKindOfClass:[NSError class]])
        {
            SDKLog(@"从安装包中拷贝文件%@.json到Document目录失败，原因：%@.",fileName, error.localizedDescription);
            return FALSE;
        }
        return TRUE;
    };
    
    if([fileManager fileExistsAtPath:path]== NO)
    {
        SDKLog(@"Document目录下%@.json文件不存在,准备从安装包中拷贝文件到Document目录.",fileName);
        BOOL bSuccess = copyFileBlock(NO);
        if(!bSuccess)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block)block();
            });
            return;
        }
        SDKLog(@"从安装包中拷贝文件%@.json到Document目录完成.",fileName);
    }
    else
    {
        NSString*resourcePath =[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
        NSData *jsonDataOfMainBundle = [[NSFileManager defaultManager] contentsAtPath:resourcePath];
        NSDictionary *mainDict = [StencilDataParseUtil toJsonObject:jsonDataOfMainBundle];
        if(![mainDict isKindOfClass:[NSDictionary class]])
        {
            SDKLog(@"安装包中模板文件%@.json无法解析，格式不正确.",fileName);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block)block();
            });
            return;
        }
        NSString* versionA = [StencilDataParseUtil getDataAsString:[mainDict objectForKey:@"version"]];
        NSString* updateA = [StencilDataParseUtil getDataAsString:[mainDict objectForKey:@"update"]];
        
        NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:path];
        NSDictionary *dict = [StencilDataParseUtil toJsonObject:jsonData];
        if(![dict isKindOfClass:[NSDictionary class]])
        {
            SDKLog(@"Document目录下模板文件%@.json无法解析，格式不正确.",fileName);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block)block();
            });
            return;
        }
        NSString* versionB = [StencilDataParseUtil getDataAsString:[dict objectForKey:@"version"]];
        NSString* updateB = [StencilDataParseUtil getDataAsString:[dict objectForKey:@"update"]];
        
        if(![versionB isKindOfClass:[NSString class]] || ![updateB isKindOfClass:[NSString class]] || [versionB compare:versionA options:NSNumericSearch] == NSOrderedAscending || [updateB compare:updateA options:NSNumericSearch] == NSOrderedAscending)
        {
            SDKLog(@"安装包目录下%@.json文件已更新,准备从安装包中拷贝文件到Document目录.",fileName);
            BOOL bSuccess = copyFileBlock(YES);
            if(!bSuccess)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block)block();
                });
                return;
            }
            SDKLog(@"从安装包中拷贝文件%@.json到Document目录完成.",fileName);
        }
    }
    
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:path];
    NSDictionary *dict = [StencilDataParseUtil toJsonObject:jsonData];
    if(![dict isKindOfClass:[NSDictionary class]])
    {
        SDKLog(@"Document目录下模板文件%@.json无法解析，格式不正确.",fileName);
        dispatch_async(dispatch_get_main_queue(), ^{
            if(block)block();
        });
        return;
    }
    self.version = [StencilDataParseUtil getDataAsString:[dict objectForKey:@"version"]];
    self.update = [StencilDataParseUtil getDataAsString:[dict objectForKey:@"update"]];
    self.comment = [StencilDataParseUtil getDataAsString:[dict objectForKey:@"comment"]];
    NSArray *library = [dict objectForKey:@"library"];
    [sectionStyles removeAllObjects];
    for (NSDictionary*sectionStyleDict in library)
    {
        StencilSectionStyle *sectionStyle = [[StencilSectionStyle alloc] init];
        [sectionStyle parseData:sectionStyleDict];
        [sectionStyles setObject:sectionStyle forKey:sectionStyle.style_id];
    }
    SDKLog(@"初始化StencilLayout模版样式库%@完成.",path);
    dispatch_async(dispatch_get_main_queue(), ^{
        if(bNotify)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:STENCIL_LAYOUT_STYLE_UPDATED_NOTIFICATION object:nil];
            SDKLog(@"StencilLayout模版样式库更新通知.");
        }
        if(block)block();
    });
}

-(StencilSectionStyle *)GetSectionStyle:(NSString*)styleId
{
    return [sectionStyles objectForKey:styleId];
}


@end
