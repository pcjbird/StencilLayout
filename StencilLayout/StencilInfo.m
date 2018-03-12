//
//  StencilInfo.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilInfo.h"
#import "StencilDataParseUtil.h"
#import "UIColor+StencilHexString.h"
#import "StencilStringUtil.h"

@implementation StencilItemStyle

@synthesize widthType;
@synthesize fixedWidth;
@synthesize widthRatio;
@synthesize heightType;
@synthesize fixedHeight;
@synthesize heightRatioBaseWidth;
@synthesize option_additional_width;
@synthesize option_additional_height;
@synthesize defaultLayoutType;
@synthesize bHighlightSupport;
@synthesize highlightColor;

-(BOOL)parseData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) return FALSE;
    widthType = (StencilItemWidthType)[StencilDataParseUtil getDataAsInt:[data objectForKey:@"widthType"]];
    fixedWidth = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"fixedWidth"]];
    widthRatio = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"widthRatio"]];
    heightType = (StencilItemHeightType)[StencilDataParseUtil getDataAsInt:[data objectForKey:@"heightType"]];
    fixedHeight = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"fixedHeight"]];
    heightRatioBaseWidth = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"heightRatioBaseWidth"]];
    option_additional_width = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"option-additional-width"]];
    option_additional_height = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"option-additional-height"]];
    defaultLayoutType = [StencilDataParseUtil getDataAsInt:[data objectForKey:@"defaultLayoutType"]];
    bHighlightSupport = [StencilDataParseUtil getDataAsBool:[data objectForKey:@"bHighlightSupport"]];
    NSString *hexColor = [StencilDataParseUtil getDataAsString:[data objectForKey:@"highlightHexColor"]];
    highlightColor = hexColor ? [UIColor stencilColorWithHexString:hexColor] : nil;
    return TRUE;
}

@end

@implementation StencilSectionStyle
@synthesize style_id;
@synthesize start_version;
@synthesize section_margin_top;
@synthesize section_margin_left;
@synthesize section_margin_bottom;
@synthesize section_margin_right;
@synthesize content_margin_top;
@synthesize content_margin_left;
@synthesize content_margin_bottom;
@synthesize content_margin_right;
@synthesize item_interitem_spacing;
@synthesize item_line_spacing;
@synthesize heightType;
@synthesize option_additional_height;
@synthesize maxItems;
@synthesize item_merge_layout;
@synthesize itemStyles;
@synthesize background;

-(BOOL)parseData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) return FALSE;
    style_id = [StencilDataParseUtil getDataAsString:[data objectForKey:@"style-id"]];
    start_version =[StencilDataParseUtil getDataAsString:[data objectForKey:@"start-version"]];
    section_margin_top = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"section-margin-top"]];
    section_margin_left = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"section-margin-left"]];
    section_margin_bottom = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"section-margin-bottom"]];
    section_margin_right = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"section-margin-right"]];
    content_margin_top = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"content-margin-top"]];
    content_margin_left = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"content-margin-left"]];
    content_margin_bottom = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"content-margin-bottom"]];
    content_margin_right = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"content-margin-right"]];
    item_interitem_spacing = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"item-interitem-spacing"]];
    item_line_spacing = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"item-line-spacing"]];
    heightType = (StencilSectionHeightType)[StencilDataParseUtil getDataAsInt:[data objectForKey:@"heightType"]];
    option_additional_height = [StencilDataParseUtil getDataAsFloat:[data objectForKey:@"option-additional-height"]];
    maxItems = [StencilDataParseUtil getDataAsInt:[data objectForKey:@"maxitems"]];
    item_merge_layout = [StencilDataParseUtil getDataAsBool:[data objectForKey:@"item-merge-layout"]];
    NSString *hexColor = [StencilDataParseUtil getDataAsString:[data objectForKey:@"background"]];
    background = hexColor ? [UIColor stencilColorWithHexString:hexColor] : nil;
    itemStyles = [NSMutableArray array];
    for (NSDictionary*dict in [data objectForKey:@"item-styles"])
    {
        StencilItemStyle *itemStyle = [[StencilItemStyle alloc] init];
        [itemStyle parseData:dict];
        [itemStyles addObject:itemStyle];
    }
    return TRUE;
}

-(BOOL)isAvailableForCurrentClientVersion
{
    if(![StencilStringUtil isStringBlank:start_version])
    {
        NSString* bundleVersion = [[NSBundle mainBundle]  objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if([bundleVersion compare:start_version options:NSNumericSearch] == NSOrderedAscending)
        {
            return FALSE;
        }
    }
    return TRUE;
}
@end
