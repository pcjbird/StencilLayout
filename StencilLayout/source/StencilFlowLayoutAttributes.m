//
//  StencilFlowLayoutAttributes.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilFlowLayoutAttributes.h"

@implementation StencilFlowLayoutAttributes

+ (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath {
    
    StencilFlowLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind
                                                                                                    withIndexPath:indexPath];
    return layoutAttributes;
}

@end
