//
//  StencilItemCell.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/9.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilItemCell.h"

@implementation StencilItemCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.isMergedCell = NO;
}

-(void) configWithItem:(StencilItem*)item
{
    self.isMergedCell = NO;
}

-(void) configWithSection:(StencilSection*)section
{
    self.isMergedCell = YES;
}

+(CGFloat)customHeightForItem:(StencilItem*)item itemStyle:(StencilItemStyle*)itemStyle itemWidth:(CGFloat)itemWidth
{
    return 0;
}
@end
