//
//  UIColor+StencilHexString.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (StencilHexString)

+ (UIColor *) stencilColorWithHexString: (NSString *) hexString;
+ (UIColor *) stencilColorWithHexString: (NSString *) hexString alpha:(CGFloat)alpha;

@end
