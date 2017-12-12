//
//  StencilLayout.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//
#ifndef StencilLayout_m
#define StencilLayout_m

#import "StencilLayout.h"
#import "StencilStringUtil.h"
#import "StencilSectionManager.h"

//! Project version number for StencilLayout.
//double StencilLayoutVersionNumber = 201611080001;
//! Project version string for StencilLayout.
//const unsigned char StencilLayoutVersionString[] = "201611080001";


//! StencilLayout是否已经初始化.
static BOOL bStencilLayoutInited = FALSE;

@interface StencilLayout()

@property(nonatomic, strong) NSString* stencilStyleFileName;
@property(nonatomic, strong) NSString* stencilStyleUrl;

+ (StencilLayout *) sharedLayout;

@end

@implementation StencilLayout

static StencilLayout* _sharedLayout = nil;

+ (StencilLayout *)sharedLayout
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedLayout) _sharedLayout=[[StencilLayout alloc] init];
        _sharedLayout.stencilStyleFileName = @"StencilSectionStyle";
    });
    return _sharedLayout;
}


+ (NSString*)getSDKVersion
{
    return SDK_VERSION;
}

+ (NSString*)getSDKBuildVersion
{
    return SDK_BUILD_VERSION;
}

+ (void) setDefaultStencilStyle:(NSString*)fileName
{
    if(bStencilLayoutInited)
    {
        SDKLog(@"函数setDefaultStencilStyle:必须在startWithStencilStyleUrl:debugMode:之前调用。");
        return;
    }
    if([StencilStringUtil isStringBlank:fileName])
    {
        SDKLog(@"设置默认模版样式配置文件名失败，文件名不能为空。");
        return;
    }
    [StencilLayout sharedLayout].stencilStyleFileName = fileName;
}

+ (void)startWithStencilStyleUrl:(NSString*)stencilStyleUrl debugMode:(BOOL)bDebug
{
    bStencilLayoutInited = TRUE;
    [[NSUserDefaults standardUserDefaults] setObject:@(bDebug) forKey:StencilLayoutDebugKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SDKLog(@"初始化StencilLayout模块.");
    if(bDebug)SDKLog(@"设置调试模式:%@.",@(bDebug));
    [StencilLayout sharedLayout].stencilStyleUrl = stencilStyleUrl;
    [[StencilSectionManager sharedInstance] initSectionStyles:[StencilLayout sharedLayout].stencilStyleFileName background:NO complete:^{
        [[StencilLayout sharedLayout] tryUpdateStencilStyle];
    }];
    SDKLog(@"StencilLayout模块初始化完成.");
}


-(void)tryUpdateStencilStyle
{
    if([StencilStringUtil isStringBlank:self.stencilStyleUrl])
    {
        SDKLog(@"您没有设置存放模版样式配置的链接，将不会更新远程模版样式配置。");
        return;
    }
    SDKLog(@"尝试更新远程模版样式到本地。");
    __weak typeof(self) weakSelf = self;
    NSMutableURLRequest *checkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.stencilStyleUrl]];
    checkRequest.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:checkRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if([connectionError isKindOfClass:[NSError class]])
        {
            SDKLog(@"请求远程模版样式配置信息URL地址%@，连接错误:%@.",weakSelf.stencilStyleUrl, connectionError.localizedDescription);
            return;
        }
        NSFileManager*fileManager =[NSFileManager defaultManager];
        NSError*error;
        NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString*documentsDirectory =[paths objectAtIndex:0];
        
        NSString*path =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",weakSelf.stencilStyleFileName]];
        
        if([fileManager fileExistsAtPath:path]== NO)
        {
            NSString*resourcePath =[[NSBundle mainBundle] pathForResource:weakSelf.stencilStyleFileName ofType:@"json"];
            [fileManager copyItemAtPath:resourcePath toPath:path error:&error];
        }
        
        NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:path];
        if(jsonData && [jsonData isEqualToData:data])
        {
            SDKLog(@"当前模版样式已经是最新版本。");
            return;
        }
        if([data writeToFile:path options:NSDataWritingAtomic error:&error])
        {
            [[StencilSectionManager sharedInstance] initSectionStyles:[StencilLayout sharedLayout].stencilStyleFileName background:YES withNotify:YES complete:^{
                SDKLog(@"更新远程模版样式到本地成功。");
            }];
        }
        else if([error isKindOfClass:[NSError class]])
        {
            SDKLog(@"尝试更新远程模版样式到本地发生错误：%@.", error.localizedDescription);
        }
    }];
}
@end

#endif
