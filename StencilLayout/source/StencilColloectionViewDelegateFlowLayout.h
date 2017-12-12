//
//  StencilColloectionViewDelegateFlowLayout.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/8.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#ifndef StencilColloectionViewDelegateFlowLayout_h
#define StencilColloectionViewDelegateFlowLayout_h

@protocol StencilColloectionViewDelegateFlowLayout<UICollectionViewDelegateFlowLayout>
@optional
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionContentAtIndex:(NSInteger)section;
- (UIColor*)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout backColorForSectionAtIndex:(NSInteger)section;
@end

#endif /* StencilColloectionViewDelegateFlowLayout_h */
