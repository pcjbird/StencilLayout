//
//  StencilLayout.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//
//  框架名称:iOS模版布局框架SDK
//  框架功能:基于模版的布局模式，旨在支持广告位灵活配置，高效运营，UI动态生成，提高开发效率。
//  修改记录:
//     pcjbird    2017-12-13  Version:1.0.3 Build:201712130001
//                            1.修改CocoaPods下 resource bundle 打包方式
//     pcjbird    2017-12-12  Version:1.0.2 Build:201712120001
//                            1.修改图片依赖库为YYWebImage
//     pcjbird    2017-03-08  Version:1.0.1 Build:201703080001
//                            1.修复模块点击事件可能失效的问题
//     pcjbird    2016-11-21  Version:1.0.0 Build:201611210001
//                            1.首次发布SDK版本

#ifndef StencilLayout_h
#define StencilLayout_h

#import <UIKit/UIKit.h>

//! Project version number for StencilLayout.
FOUNDATION_EXPORT double StencilLayoutVersionNumber;

//! Project version string for StencilLayout.
FOUNDATION_EXPORT const unsigned char StencilLayoutVersionString[];

//未知的模版项布局类型
#define StencilItemLayoutLayoutType_Unknown     0
//根据客户端布局类型
#define StencilItemLayoutLayoutType_ByClient    1
//是否为服务端布局类型
#define IsStencilItemLayoutByServer(layout) (layout != StencilItemLayoutLayoutType_Unknown && layout != StencilItemLayoutLayoutType_ByClient)

//头部数据源占位符
#define STENCILADDITIONALHEADERDATASOURCEPLACEHOLDER @"StencilAdditionalHeaderDataSourcePlaceHolder"

//!模版样式更新通知
#define STENCIL_LAYOUT_STYLE_UPDATED_NOTIFICATION  @"StencilLayoutStyleUpdatedNotification"

// In this header, you should import all the public headers of your framework using statements like #import <StencilLayout/PublicHeader.h>
#import <StencilLayout/StencilModel.h>
#import <StencilLayout/StencilInfo.h>
#import <StencilLayout/StencilSectionTitleCell.h>
#import <StencilLayout/StencilItemCell.h>
#import <StencilLayout/StencilItemImageCell.h>
#import <StencilLayout/StencilItemWebCell.h>
#import <StencilLayout/StencilAdditionalHeaderCell.h>
#import <StencilLayout/StencilLayoutViewController.h>

/** StencilLayout错误定义
 */
typedef enum StencilLayoutError
{
    StencilLayoutError_Common = 5000,
}StencilLayoutError;

/**
 *@brief StencilLayout
 */
@interface StencilLayout : NSObject

/** 
 *@brief 获取SDK版本号
 *@return 版本号
 */
+ (NSString*)getSDKVersion;

/**
 *@brief 获取SDK Build版本号
 *@return Build 版本号
 */
+ (NSString*)getSDKBuildVersion;

/**
 *@brief 设置默认模版样式配置文件名
 *@param fileName 默认模版样式配置的文件名，文件名不包含后缀（.json）
 *@note  模版配置文件为json格式，这里的默认模版配置文件是打包在App里的，如果不设置，则默认文件名为“StencilSectionStyle”，该函数必须在startWithStencilStyleUrl:debugMode:之前调用。
 */
+ (void) setDefaultStencilStyle:(NSString*)fileName;


/** 
 *@brief 初始化StencilLayout SDK
 *@param stencilStyleUrl 存放模版样式配置的链接
 *@param bDebug 是否调试模式
 */
+ (void)startWithStencilStyleUrl:(NSString*)stencilStyleUrl debugMode:(BOOL)bDebug;


@end

#endif
