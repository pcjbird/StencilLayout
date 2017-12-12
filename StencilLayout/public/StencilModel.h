//
//  StencilModel.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/9.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *@brief 模版项数据
 */
@interface StencilItem : NSObject
@property(nonatomic, assign) int               nId;
@property(nonatomic, assign) int               nRefId;
@property(nonatomic, assign) int               sortIndex;
@property(nonatomic, strong)NSString*          imageUrl;
@property(nonatomic, strong)NSString*          pageUrl;
@property(nonatomic, assign)int                layoutType;        //根据layoutType布局
@property(nonatomic, strong)NSString*          title;
@property(nonatomic, strong)NSString*          subTitle;
@property(nonatomic, strong)NSString*          desc;
@property(nonatomic, strong)id                 rawData;
@property(nonatomic, strong)NSDate*            updateTime;

- (BOOL) parseData:(NSDictionary*)data;

@end

/**
 *@brief 模版数据
 */
@interface StencilSection : NSObject
@property(nonatomic, strong)NSString*          styleId;
@property(nonatomic, assign) int               nId;
@property(nonatomic, assign) int               nRefId;
@property(nonatomic, assign) float             fMarginTop;
@property(nonatomic, assign)BOOL               bShowTitle;
@property(nonatomic, assign)BOOL               bShowIcon;
@property(nonatomic, strong)NSString*          iconUrl;
@property(nonatomic, strong)NSString*          title;
@property(nonatomic, assign)BOOL               bMore;
@property(nonatomic, strong)NSString*          moreTitle;
@property(nonatomic, strong)NSString*          moreIconUrl;
@property(nonatomic, assign)int                sortIndex;
@property(nonatomic, strong)NSString*          moreUrl;
@property(nonatomic, strong)id                 rawData;
@property(nonatomic, strong)NSMutableArray*    items;

- (BOOL) parseData:(NSDictionary*)data;

@end
