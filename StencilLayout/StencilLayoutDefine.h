//
//  StencilLayoutDefine.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#ifndef StencilLayoutDefine_h
#define StencilLayoutDefine_h


#define StencilLayoutDebugKey @"StencilLayoutDebugModeKey"

//! 是否调试模式.
#define bDebugMode  ([[[NSUserDefaults standardUserDefaults] objectForKey:StencilLayoutDebugKey] boolValue])

#define SDK_VERSION   @"1.1.2"

#define SDK_BUILD_VERSION   @"202005020001"

#define SDKLog(fmt, ...) (bDebugMode ? NSLog((@"[🐌StencilLayout] %s (line %d) " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) : nil)

#define SDK_RAISE_EXCEPTION(msg) ([NSException raise:@"[🐌StencilLayout]" format:@"%@ 【class name:%@, line:%@】",(msg),@(__PRETTY_FUNCTION__),@(__LINE__)])

#define SDK_ERROR_WITH_CODE_AND_MSG(ecode, msg)  [NSError errorWithDomain:@"StencilLayout" code:(ecode) userInfo:([NSDictionary dictionaryWithObjectsAndKeys:(msg), @"message", nil])]

#define SDK_GET_ERROR_MSG(err) (err ? ([err.userInfo objectForKey:@"message"] ? [err.userInfo objectForKey:@"message"] : [err localizedDescription]) : nil)

#define SDKScreenRect                          [[UIScreen mainScreen] bounds]
#define SDKScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define SDKScreenHeight                        [[UIScreen mainScreen] bounds].size.height

//自动间距
#define SDK_AUTOLAYOUTSPACE(pt) (pt*(SDKScreenWidth/375.0f))

//blocks
typedef void(^StencilLayoutVoidBlock)(void);

#endif /* StencilLayoutDefine_h */
