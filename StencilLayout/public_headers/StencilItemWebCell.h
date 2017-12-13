//
//  StencilItemWebCell.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/10.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <StencilLayout/StencilItemCell.h>

@interface StencilItemWebCell : StencilItemCell

/*!
 *  A Boolean val indicate whether prefer to user WKWebView when it is available.
 */
@property(nonatomic, assign) BOOL preferWKWebView;

@end
