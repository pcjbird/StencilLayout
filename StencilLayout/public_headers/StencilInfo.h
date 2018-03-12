//
//  StencilInfo.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *@brief 模版项宽度类型
 */
typedef enum
{
    StencilItemWidthType_Ratio = 0,   //按比例
    StencilItemWidthType_Fix = 1,     //固定值
}StencilItemWidthType;

/**
 *@brief 模版项高度类型
 */
typedef enum
{
    StencilItemHeightType_Ratio = 0,   //按比例
    StencilItemHeightType_Fix = 1,     //固定值
    StencilItemHeightType_Custom = 2,  //自定义
}StencilItemHeightType;

/**
 *@brief 模版高度类型
 */
typedef enum
{
    StencilSectionHeightType_Auto = 0,   //模版系统自动计算
    StencilSectionHeightType_Custom = 1, //自定义由业务决定
}StencilSectionHeightType;

/**
 *@brief 模版项样式
 */
@interface StencilItemStyle : NSObject
{
    StencilItemWidthType    widthType;
    float                   fixedWidth;
    float                   widthRatio;
    StencilItemHeightType   heightType;
    float                   fixedHeight;
    float                   heightRatioBaseWidth;
    float                   option_additional_width;
    float                   option_additional_height;
    int                     defaultItemType;
    BOOL                    bHighlightSupport;
    UIColor*                highlightColor;
}
@property(nonatomic, readonly) StencilItemWidthType    widthType;
@property(nonatomic, readonly) float                   fixedWidth;
@property(nonatomic, readonly) float                   widthRatio;
@property(nonatomic, readonly) StencilItemHeightType   heightType;
@property(nonatomic, readonly) float                   fixedHeight;
@property(nonatomic, readonly) float                   heightRatioBaseWidth;
@property(nonatomic, readonly) float                   option_additional_width;
@property(nonatomic, readonly) float                   option_additional_height;
@property(nonatomic, readonly) int                     defaultLayoutType;
@property(nonatomic, readonly) BOOL                    bHighlightSupport;
@property(nonatomic, strong, readonly)UIColor*         highlightColor;
-(BOOL)parseData:(NSDictionary *)data;

@end


/**
 *@brief 模版样式
 */
@interface StencilSectionStyle : NSObject
{
    NSString*          style_id;
    float              item_interitem_spacing;
    float              item_line_spacing;
    int                maxItems;                  //0 表示无限
    BOOL               item_merge_layout;
    NSMutableArray*    itemStyles;
    UIColor*           background;
}
@property(nonatomic, readonly)NSString*          style_id;
@property(nonatomic, readonly)NSString*          start_version;
@property(nonatomic, readonly)float              section_margin_top;
@property(nonatomic, readonly)float              section_margin_left;
@property(nonatomic, readonly)float              section_margin_bottom;
@property(nonatomic, readonly)float              section_margin_right;
@property(nonatomic, readonly)float              content_margin_top;
@property(nonatomic, readonly)float              content_margin_left;
@property(nonatomic, readonly)float              content_margin_bottom;
@property(nonatomic, readonly)float              content_margin_right;
@property(nonatomic, readonly)float              item_interitem_spacing;
@property(nonatomic, readonly)float              item_line_spacing;
@property(nonatomic, readonly)float              option_additional_height;
@property(nonatomic, readonly)StencilSectionHeightType heightType;
@property(nonatomic, readonly)int                maxItems;                  //0 表示无限
@property(nonatomic, readonly)BOOL               item_merge_layout;
@property(nonatomic, strong, readonly)UIColor*   background;
@property(nonatomic, readonly)NSMutableArray*    itemStyles;

-(BOOL)parseData:(NSDictionary *)data;
-(BOOL)isAvailableForCurrentClientVersion;
@end
