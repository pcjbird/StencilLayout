//
//  StencilStringUtil.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/9.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StencilStringUtil : NSObject

/**
 *@brief 判断字符串是否为空
 *@param val 目标字符串
 *@return 是否为空
 */
+(BOOL) isStringBlank:(NSString*)val;


/**
 *@brief 判断字符串是否包含中文
 *@param val 目标字符串
 *@return 是否包含中文
 */
+(BOOL) isStringHasChineseCharacter:(NSString*)val;
@end
