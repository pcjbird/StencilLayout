//
//  StencilItemImageCell.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/10.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilItemImageCell.h"

@interface StencilItemImageCell()

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView;
@end

@implementation StencilItemImageCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void) configWithItem:(StencilItem*)item
{
    [super configWithItem:item];
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholder:nil options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:nil];
}

@end
