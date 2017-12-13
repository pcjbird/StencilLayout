//
//  StencilFlowLayout.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilFlowLayout.h"
#import "StencilLayoutDefine.h"
#import "StencilFlowLayoutAttributes.h"
#import "StencilColloectionViewDelegateFlowLayout.h"
#import "StencilCollectionReusableView.h"

static NSString *kDecorationReuseIdentifier = @"section_background";

@interface StencilFlowLayout()
{
    CGSize contentSize;
}
@property (nonatomic) NSMutableDictionary *cachedAttributes;
@property (nonatomic) NSMutableArray* currentLineAvailableCoords;
@property (nonatomic, strong) NSMutableDictionary *headerAttributes;
@property (nonatomic, strong) NSMutableDictionary *footerAttributes;
@property (nonatomic, strong) NSMutableDictionary *sectionbackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemAttributes;
@end

@implementation StencilFlowLayout

+ (Class)layoutAttributesClass
{
    return [StencilFlowLayoutAttributes class];
}

-(void)prepareLayout
{
    contentSize = CGSizeZero;
    self.cachedAttributes = [NSMutableDictionary dictionary];
    self.currentLineAvailableCoords = [NSMutableArray array];
    self.headerAttributes = [NSMutableDictionary dictionary];
    self.footerAttributes = [NSMutableDictionary dictionary];
    self.sectionbackgroundAttributes = [NSMutableDictionary dictionary];
    self.itemAttributes = [NSMutableDictionary dictionary];
    
    [self registerClass:[StencilCollectionReusableView class] forDecorationViewOfKind:kDecorationReuseIdentifier];
    
    [self updateItemLayout];
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesToReturn = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes* attr in [self.headerAttributes allValues])
    {
        CGRect rcIntersection = CGRectIntersection(rect, attr.frame);
        if (CGRectGetWidth(rcIntersection) > 0 && CGRectGetHeight(rcIntersection) > 0)
        {
            [attributesToReturn addObject:attr];
        }
    }
    for (UICollectionViewLayoutAttributes* attr in [self.sectionbackgroundAttributes allValues])
    {
        CGRect rcIntersection = CGRectIntersection(rect, attr.frame);
        if (CGRectGetWidth(rcIntersection) > 0 && CGRectGetHeight(rcIntersection) > 0)
        {
            attr.zIndex = attr.zIndex - 1;
            [attributesToReturn addObject:attr];
        }
    }
    for (UICollectionViewLayoutAttributes* attr in [self.itemAttributes allValues])
    {
        CGRect rcIntersection = CGRectIntersection(rect, attr.frame);
        if (CGRectGetWidth(rcIntersection) > 0 && CGRectGetHeight(rcIntersection) > 0)
        {
            [attributesToReturn addObject:attr];
        }
    }
    for (UICollectionViewLayoutAttributes* attr in [self.footerAttributes allValues])
    {
        CGRect rcIntersection = CGRectIntersection(rect, attr.frame);
        if (CGRectGetWidth(rcIntersection) > 0 && CGRectGetHeight(rcIntersection) > 0)
        {
            [attributesToReturn addObject:attr];
        }
    }
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [self.itemAttributes objectForKey:indexPath];
    
    if (!layoutAttributes)
    {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = nil;
    if (elementKind == UICollectionElementKindSectionHeader)
    {
        layoutAttributes = [self.headerAttributes objectForKey:indexPath];
    }
    else if(elementKind == UICollectionElementKindSectionFooter)
    {
        layoutAttributes = [self.footerAttributes objectForKey:indexPath];
    }
    if (!layoutAttributes)
    {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = nil;
    if ([elementKind isEqualToString:kDecorationReuseIdentifier])
    {
        layoutAttributes = [self.sectionbackgroundAttributes objectForKey:indexPath];
    }
    if (!layoutAttributes)
    {
        layoutAttributes = [StencilFlowLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    }
    return layoutAttributes;
}

-(BOOL) isCoord:(CGPoint)pt AvailableForSize:(CGSize)aSize maxRect:(CGRect)rcMax
{
    CGRect rc = CGRectMake((float)pt.x, (float)pt.y, (float)aSize.width, (float)aSize.height);
    if ((float)pt.x < (float)rcMax.origin.x || (float)pt.y < (float)rcMax.origin.y || ((float)CGRectGetMaxX(rc) - (float)CGRectGetMaxX(rcMax)) > 1.0f || ((float)CGRectGetMaxY(rc) - (float)CGRectGetMaxY(rcMax)) > 1.0f)
    {
        return FALSE;
    }
    for (UICollectionViewLayoutAttributes *attr in self.cachedAttributes.allValues)
    {
        CGRect rcIntersection = CGRectIntersection(rc, attr.frame);
        if (CGRectGetWidth(rcIntersection) > 1.0f && CGRectGetHeight(rcIntersection) > 1.0f)
        {
            return FALSE;
        }
    }
    return TRUE;
}

-(NSArray *)coordArrayForCGSize:(CGSize)aSize maxRect:(CGRect)rcMax
{
    NSArray *coord = nil;
    NSArray *ptFound = nil;
    for (NSArray* pt in self.currentLineAvailableCoords)
    {
        float x = [(NSNumber*)[pt objectAtIndex:0] floatValue];
        float y = [(NSNumber*)[pt objectAtIndex:1] floatValue];
        if ([self isCoord:CGPointMake(x, y) AvailableForSize:aSize maxRect:rcMax])
        {
            ptFound = pt;
            coord = @[@(x), @(y)];
            break;
        }
    }
    if (ptFound)
    {
        [self.currentLineAvailableCoords removeObject:ptFound];
    }
    return coord;
}


-(void) updateItemLayout
{
    //section 起点坐标
    CGPoint sectionOrigion = CGPointZero;
    CGSize sectionSize = CGSizeZero;
    CGSize  headerSize = CGSizeZero;
    CGSize itemContentSize = CGSizeZero;
    CGSize footerSize = CGSizeZero;
    
    BOOL isHorizontal = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);
    
    if  (isHorizontal)
    {
        SDKLog(@"StencilFlowLayout does not support horizontal layout!");
        return;
    }
    
    contentSize.width = CGRectGetWidth(self.collectionView.bounds);
    
    
    id <StencilColloectionViewDelegateFlowLayout> flowDataSource = (id <StencilColloectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++)
    {
        sectionSize = CGSizeZero;
        //section 间隙
        UIEdgeInsets sectionInsets = self.sectionInset;
        //content 间隙
        UIEdgeInsets itemContentInsets = self.itemContentInset;
        //content 背景颜色
        UIColor*  sectionBackground = [UIColor clearColor];
        //item 行距
        CGFloat minimumLineSpacing = self.minimumLineSpacing;
        //item 水平间隔
        CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
        
        if ([flowDataSource respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
        {
            sectionInsets = [flowDataSource collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        if ([flowDataSource respondsToSelector:@selector(collectionView:layout:insetForSectionContentAtIndex:)])
        {
            itemContentInsets = [flowDataSource collectionView:self.collectionView layout:self insetForSectionContentAtIndex:section];
        }
        
        if ([flowDataSource respondsToSelector:@selector(collectionView:layout:backColorForSectionAtIndex:)])
        {
            sectionBackground = [flowDataSource collectionView:self.collectionView layout:self backColorForSectionAtIndex:section];
        }
        
        if ([flowDataSource respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
        {
            minimumLineSpacing = [flowDataSource collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
        }
        
        if ([flowDataSource respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
        {
            minimumInteritemSpacing = [flowDataSource collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
        }
        
        //section 起点坐标
        sectionOrigion = CGPointMake(sectionInsets.left, sectionOrigion.y + sectionInsets.top + sectionInsets.bottom + headerSize.height + itemContentSize.height + footerSize.height);
        
        //section IndexPath
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        //section header
        CGRect rcSectionHeader = (CGRect){.size=self.headerReferenceSize};
        if ([flowDataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)])
        {
            rcSectionHeader = (CGRect){.size=[flowDataSource collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section]};
        }
        rcSectionHeader.origin.x = sectionOrigion.x;
        rcSectionHeader.origin.y = sectionOrigion.y;
        
        UICollectionViewLayoutAttributes *headerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:sectionIndexPath];
        headerLayoutAttributes.frame = rcSectionHeader;
        [self.headerAttributes setObject:headerLayoutAttributes forKey:sectionIndexPath];
        
        //size修正
        contentSize.width = fmaxf(contentSize.width, CGRectGetWidth(rcSectionHeader));
        contentSize.height += CGRectGetHeight(rcSectionHeader);
        headerSize = CGSizeMake(contentSize.width - sectionInsets.left - sectionInsets.right, CGRectGetHeight(rcSectionHeader));
        sectionSize.width = headerSize.width;
        sectionSize.height += headerSize.height;
        
        
        //section content
        BOOL bInitLine = TRUE;
        CGRect rcMax = CGRectZero;
        
        rcMax.origin = CGPointMake(sectionOrigion.x + itemContentInsets.left, sectionOrigion.y + headerSize.height + itemContentInsets.top);
        rcMax.size = CGSizeMake(contentSize.width - sectionInsets.left - itemContentInsets.left - sectionInsets.right - itemContentInsets.right, 0);
        itemContentSize.width = contentSize.width;
        
        [self.cachedAttributes removeAllObjects];
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < numberOfItems; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGRect previousFrame = CGRectZero;
            CGPoint bestOrigin = rcMax.origin;
            if (indexPath.item == 0)
            {
                bInitLine = TRUE;
            }
            else if (indexPath.item > 0)
            {
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
                UICollectionViewLayoutAttributes *previousAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
                previousFrame = previousAttributes.frame;
                bestOrigin = isHorizontal ? CGPointMake(previousFrame.origin.x, CGRectGetMaxY(previousFrame) + minimumLineSpacing) : CGPointMake(CGRectGetMaxX(previousFrame) + minimumInteritemSpacing, previousFrame.origin.y);
            }
            
            CGRect rcItem = (CGRect){.size = self.itemSize};
            if ([flowDataSource respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
            {
                
                rcItem = (CGRect){.size=[flowDataSource collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath]};
            }
            
            if (bInitLine)
            {
                if (rcMax.size.height < CGRectGetHeight(rcItem) && bestOrigin.x + rcItem.size.width <=CGRectGetMaxX(rcMax))
                {
                    rcMax.size.height = (float)CGRectGetHeight(rcItem);
                }
                
                bInitLine = [self isCoord:bestOrigin AvailableForSize:rcItem.size maxRect:rcMax];
            }
            NSArray *pt = [self coordArrayForCGSize:rcItem.size maxRect:rcMax];
            
            BOOL newline = (indexPath.item == 0) || ((![self isCoord:bestOrigin AvailableForSize:rcItem.size maxRect:rcMax])&&(!pt));
            
            if (newline)
            {
                [self.currentLineAvailableCoords removeAllObjects];
                bInitLine = TRUE;
                if (isHorizontal)
                {
                    rcItem.origin.y = 0;
                    if (indexPath.item == 0)
                    {
                        rcItem.origin.x = rcMax.origin.x;
                    }
                    else
                    {
                        rcItem.origin.x = rcMax.origin.x + rcMax.size.width + minimumLineSpacing;
                        rcMax.size.width+= CGRectGetWidth(rcItem) + minimumLineSpacing;
                    }
                }
                else
                {
                    rcItem.origin.x = rcMax.origin.x;
                    if (indexPath.item == 0)
                    {
                        rcItem.origin.y = (float)rcMax.origin.y;
                    }
                    else
                    {
                        rcItem.origin.y = rcMax.origin.y + rcMax.size.height +minimumLineSpacing;
                        rcMax.size.height+= CGRectGetHeight(rcItem) + minimumLineSpacing;
                    }
                }
                
            }
            else
            {
                if([self isCoord:bestOrigin AvailableForSize:rcItem.size maxRect:rcMax])
                {
                    rcItem.origin = bestOrigin;
                }
                else if(pt)
                {
                    float x = [(NSNumber*)[pt objectAtIndex:0] floatValue];
                    float y = [(NSNumber*)[pt objectAtIndex:1] floatValue];
                    rcItem.origin = CGPointMake(x, y);
                }
            }
            
            layoutAttributes.frame = rcItem;
            
            [self.currentLineAvailableCoords addObject:@[@(rcItem.origin.x), @(CGRectGetMaxY(rcItem) + minimumLineSpacing)]];
            
            [self.cachedAttributes setObject:layoutAttributes forKey:indexPath];
            [self.itemAttributes setObject:layoutAttributes forKey:indexPath];
        }
        
        
        contentSize.height += (float)rcMax.size.height+(float)sectionInsets.bottom+(float)sectionInsets.top;
        itemContentSize.height = (float)rcMax.size.height;
        
        StencilFlowLayoutAttributes *sectionbackLayoutAttributes = (StencilFlowLayoutAttributes*)[self layoutAttributesForDecorationViewOfKind:kDecorationReuseIdentifier atIndexPath:sectionIndexPath];
        sectionbackLayoutAttributes.sectionBackColor = sectionBackground;
        sectionbackLayoutAttributes.frame = CGRectMake(0, rcMax.origin.y, SDKScreenWidth, rcMax.size.height);
        [self.sectionbackgroundAttributes setObject:sectionbackLayoutAttributes forKey:sectionIndexPath];
        
        UICollectionViewLayoutAttributes *footerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:sectionIndexPath];
        CGRect rcSectionFooter = (CGRect){.size=self.footerReferenceSize};
        if ([flowDataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)])
        {
            rcSectionFooter = (CGRect){.size=[flowDataSource collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section]};
        }
        
        
        rcSectionFooter.origin.x = sectionOrigion.x;
        rcSectionFooter.origin.y = sectionOrigion.y + headerSize.height + itemContentSize.height;
        contentSize.width = fmaxf(contentSize.width, CGRectGetWidth(rcSectionFooter));
        contentSize.height += (float)CGRectGetHeight(rcSectionFooter);
        footerSize = CGSizeMake((float)contentSize.width, (float)rcSectionFooter.size.height + (float)sectionInsets.bottom);
        
        footerLayoutAttributes.frame = rcSectionFooter;
        
        [self.footerAttributes setObject:footerLayoutAttributes forKey:sectionIndexPath];
    }
    
}

- (CGSize)collectionViewContentSize
{
    return contentSize;
}


@end
