//
//  StencilDataParseUtil.h
//  SnailIOSHybrid
//
//  Created by pcjbird on 16/10/27.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StencilDataParseUtil : NSObject

+ (NSString*)getDataAsString:(id)data;
+ (BOOL) getDataAsBool:(id)data;
+ (int) getDataAsInt:(id)data;
+ (long) getDataAsLong:(id)data;
+ (float) getDataAsFloat:(id)data;
+ (double) getDataAsDouble:(id)data;
+ (NSDate*) getDataAsDate:(id)data;
+ (NSData*) toJSONData:(id)data;
+ (id) toJsonObject:(id)data;
+ (NSString*) toJSONString:(id)data;
+ (int) getDateAsAge:(NSDate*)date;

@end
