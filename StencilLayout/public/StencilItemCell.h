//
//  StencilItemCell.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/9.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StencilLayout/StencilModel.h>
#import <StencilLayout/StencilLayoutViewController.h>
@interface StencilItemCell : UICollectionViewCell

@property(nonatomic, weak)StencilLayoutViewController* parentViewController;
@property(nonatomic, assign) BOOL  isMergedCell;

-(void) configWithItem:(StencilItem*)item;
-(void) configWithSection:(StencilSection*)section;

+(CGFloat)customHeightForItem:(StencilItem*)item itemStyle:(StencilItemStyle*)itemStyle itemWidth:(CGFloat)itemWidth;
@end
