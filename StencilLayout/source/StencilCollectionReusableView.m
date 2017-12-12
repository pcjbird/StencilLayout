//
//  StencilCollectionReusableView.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilCollectionReusableView.h"
#import "StencilFlowLayoutAttributes.h"

@implementation StencilCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    StencilFlowLayoutAttributes *customLayoutAttributes = (StencilFlowLayoutAttributes*)layoutAttributes;
    self.backgroundColor = customLayoutAttributes.sectionBackColor;
}

@end
