//
//  StencilLayoutViewController.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/9.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilLayout.h"
#import "StencilLayoutViewController.h"
#import "StencilFlowLayout.h"
#import "StencilSectionManager.h"
#import "StencilSectionTitleCell.h"
#import "StencilSectionFooterCell.h"
#import "StencilAdditionalHeaderCell.h"
#import "StencilItemCell.h"
#import "StencilStringUtil.h"

#define defaultClickInterval 0.5f  //默认时间间隔

@interface StencilLayoutViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray	 *		_headers;
    NSMutableArray	 *		_dataSource;
    NSMutableArray   *      _cellNibNames;
}

@end

@implementation StencilLayoutViewController

-(instancetype)init
{
    if(self = [super init])
    {
        _clickTimeInterval = defaultClickInterval;
        _isIgnoreEvent = NO;
    }
    return self;
}

-(void)SetupCollectionView
{
    if(!_collectionView)
    {
        StencilFlowLayout*flowLayout = [[StencilFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addSubview:_collectionView];
        NSArray *constraints_h=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView)];
        
        NSArray *constraints_v=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView)];
        
        [self.view addConstraints:constraints_h];
        [self.view addConstraints:constraints_v];
    }
    _headers = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    _cellNibNames = [NSMutableArray array];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //header
    if(self.delegate &&[self.delegate respondsToSelector:@selector(stencilLayoutViewControllerSectionHeaderNibName:)])
    {
        NSString *nibName = [self.delegate stencilLayoutViewControllerSectionHeaderNibName:self];
        if([nibName isKindOfClass:[NSString class]] && [nibName length] > 0)
        {
            [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:nibName];
        }
    }
    //footer
    if(self.delegate &&[self.delegate respondsToSelector:@selector(stencilLayoutViewControllerSectionFooterNibName:)])
    {
        NSString *nibName = [self.delegate stencilLayoutViewControllerSectionFooterNibName:self];
        if([nibName isKindOfClass:[NSString class]] && [nibName length] > 0)
        {
            [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:nibName];
        }
    }
    //cells
    if(self.delegate &&[self.delegate respondsToSelector:@selector(stencilLayoutViewControllerCellNibNames:)])
    {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[StencilLayoutViewController class]] pathForResource:@"StencilLayout" ofType:@"bundle"]];
        
        //image
        [self.collectionView registerNib:[UINib nibWithNibName:@"StencilItemImageCell" bundle:bundle] forCellWithReuseIdentifier:@"StencilItemImageCell"];
        [_cellNibNames addObject:@"StencilItemImageCell"];
        //web
        [self.collectionView registerNib:[UINib nibWithNibName:@"StencilItemWebCell" bundle:bundle] forCellWithReuseIdentifier:@"StencilItemWebCell"];
        [_cellNibNames addObject:@"StencilItemWebCell"];
        //others
        NSArray *nibNames = [self.delegate stencilLayoutViewControllerCellNibNames:self];
        if([nibNames isKindOfClass:[NSArray class]])
        {
            for(NSString* nibName in nibNames)
            {
                if([nibName length] > 0)[self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:nibName];
            }
            [_cellNibNames addObjectsFromArray:nibNames];
        }
    }
    //additional header
    if(self.headerDataSource && [self.headerDataSource respondsToSelector:@selector(stencilLayoutViewControllerAdditionalHeaderNibNames:)])
    {
        NSArray *nibNames = [self.headerDataSource stencilLayoutViewControllerAdditionalHeaderNibNames:self];
        if([nibNames isKindOfClass:[NSArray class]])
        {
            for(NSString* nibName in nibNames)
            {
                if([nibName length] > 0)[self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:nibName];
            }
            [_cellNibNames addObjectsFromArray:nibNames];
        }
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0f)
    {
        if([self.collectionView respondsToSelector:@selector(setPrefetchingEnabled:)])
        {
            [self.collectionView setPrefetchingEnabled:NO];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetupCollectionView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setAdditionalHeaderDataSource:(NSArray*)ds
{
    [_headers removeAllObjects];
    if([ds isKindOfClass:[NSArray class]])[_headers addObjectsFromArray:ds];
    [self.collectionView reloadData];
    SDKLog(@"更新AdditionalHeader数据源，重新加载界面。");
}

-(void) loadWithDataSource:(NSArray*)ds replaceOld:(BOOL)bReplace
{
    if(bReplace)[_dataSource removeAllObjects];
    if([ds isKindOfClass:[NSArray class]])[_dataSource addObjectsFromArray:ds];
    [self.collectionView reloadData];
    SDKLog(@"更新模版内容数据源，重新加载界面。（替换旧数据：%@）", bReplace ? @"是" : @"否");
}

-(BOOL) isCellNibNameRegistered:(NSString*)cellNibName
{
    if([StencilStringUtil isStringBlank:cellNibName]) return FALSE;
    for (NSString* nibName in _cellNibNames) {
        if([nibName isEqualToString:cellNibName])
        {
            return  TRUE;
        }
    }
    return FALSE;
}

#pragma mark UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(collectionView == self.collectionView)
    {
        SDKLog(@"numberOfSections:%d",(int)([_headers count] + [_dataSource count]));
        return ([_headers count] + [_dataSource count]);
    }
    return 0;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section < [_headers count])
    {
        SDKLog(@"numberOfItemsInHeaderSection:%d(header section index:%d)", 1, (int)section);
        return 1;
    }
    section = section - [_headers count];
    StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
    if(self.collectionView && self.collectionView == collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle)
                {
                    if (sectionStyle.item_merge_layout)
                    {
                         SDKLog(@"numberOfItemsInContentSection:%d(content section index:%d)", 1, (int)section);
                        return 1;
                    }
                    else
                    {
                        if (sectionStyle.maxItems > 0)
                        {
                            SDKLog(@"numberOfItemsInContentSection:%d(content section index:%d)", (int)MIN([adSection.items count], sectionStyle.maxItems), (int)section);
                            return MIN([adSection.items count], sectionStyle.maxItems);
                        }
                        SDKLog(@"numberOfItemsInContentSection:%d(content section index:%d)", (int)[adSection.items count], (int)section);
                        return [adSection.items count];
                    }
                }
                else
                {
                    SDKLog(@"can not find section style: %@", adSection.styleId);
                }
            }
        }
    }
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section < [_headers count])
    {
        SDKLog(@"referenceSizeForHeaderInSection:%@(header section index:%d)", NSStringFromCGSize(CGSizeZero), (int)section);
        return CGSizeZero;
    }
    section = section - [_headers count];
    StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if(adSection.bShowTitle && sectionStyle && [sectionStyle isAvailableForCurrentClientVersion])
                {
                    CGFloat height = SDK_AUTOLAYOUTSPACE(48);
                    if(self.delegate && [self.delegate respondsToSelector:@selector(heightForStencilLayoutViewControllerVisibleSectionHeader:)])
                    {
                        height = [self.delegate heightForStencilLayoutViewControllerVisibleSectionHeader:self];
                    }
                    CGSize headersize =  CGSizeMake(CGRectGetWidth(collectionView.bounds) - SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_left) - SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_right), height);
                    SDKLog(@"referenceSizeForHeaderInSection:%@(content section index:%d)", NSStringFromCGSize(headersize), (int)section);
                    return headersize;
                }
            }
        }
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        if(indexPath.section < [_headers count])
        {
            SDK_RAISE_EXCEPTION(@"顶部附加视图（AdditionalHeader）不支持Section Header！");
            return nil;
        }
        NSInteger section = indexPath.section - [_headers count];
        if(self.delegate &&[self.delegate respondsToSelector:@selector(stencilLayoutViewControllerSectionHeaderNibName:)])
        {
            NSString *nibName = [self.delegate stencilLayoutViewControllerSectionHeaderNibName:self];
            if([nibName isKindOfClass:[NSString class]])
            {
                StencilSectionTitleCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:nibName forIndexPath:indexPath];
                if([_dataSource isKindOfClass:[NSArray class]] && [_dataSource count] > section)
                {
                    StencilSection *adSection = [_dataSource objectAtIndex:section];
                    [cell configWithSection:adSection];
                    [cell setNeedsLayout];
                }
                return cell;
            }
        }
        SDK_RAISE_EXCEPTION(@"请确认stencilLayoutViewControllerSectionHeaderNibName:实现是否正确，无法实例化对应的StencilSectionTitleCell。");
        
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        if(indexPath.section < [_headers count])
        {
            SDK_RAISE_EXCEPTION(@"顶部附加视图（AdditionalHeader）不支持Section Footer！");
            return nil;
        }
        NSInteger section = indexPath.section - [_headers count];
        if(self.delegate &&[self.delegate respondsToSelector:@selector(stencilLayoutViewControllerSectionFooterNibName:)])
        {
            NSString *nibName = [self.delegate stencilLayoutViewControllerSectionFooterNibName:self];
            if([nibName isKindOfClass:[NSString class]])
            {
                StencilSectionFooterCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:nibName forIndexPath:indexPath];
                if([_dataSource isKindOfClass:[NSArray class]] && [_dataSource count] > section)
                {
                    StencilSection *adSection = [_dataSource objectAtIndex:section];
                    [cell configWithSection:adSection];
                    [cell setNeedsLayout];
                }
                return cell;
            }
        }
        SDK_RAISE_EXCEPTION(@"请确认stencilLayoutViewControllerSectionFooterNibName:实现是否正确，无法实例化对应的StencilSectionFooterCell。");
        
    }
    return nil;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < [_headers count])
    {
        if(self.headerDataSource && [self.headerDataSource respondsToSelector:@selector(stencilLayoutViewControllerAdditionalHeaderNibNames:)])
        {
            NSArray *nibNames = [self.headerDataSource stencilLayoutViewControllerAdditionalHeaderNibNames:self];
            if([nibNames isKindOfClass:[NSArray class]] && [nibNames count] > indexPath.section)
            {
                NSString* nibName = [nibNames objectAtIndex:indexPath.section];
                StencilAdditionalHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:nibName forIndexPath:indexPath];
                id ds = [_headers objectAtIndex:indexPath.section];
                [cell updateDataSource:ds];
                
                return cell;
            }
        }
        NSString *exception = [NSString stringWithFormat:@"无法为indexPath创建StencilAdditionalHeaderCell，indexPath:%@",[indexPath description]];
        SDK_RAISE_EXCEPTION(exception);
        return nil;
    }
    NSInteger section = indexPath.section - [_headers count];
    StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle && [sectionStyle isAvailableForCurrentClientVersion])
                {
                    StencilItemStyle *itemStyle = nil;
                    if (sectionStyle.item_merge_layout)
                    {
                        itemStyle = [sectionStyle.itemStyles firstObject];
                    }
                    else if([sectionStyle.itemStyles count] > indexPath.item)
                    {
                        itemStyle = [sectionStyle.itemStyles objectAtIndex:indexPath.item];
                    }
                    else if(sectionStyle.maxItems == 0)
                    {
                        itemStyle = [sectionStyle.itemStyles objectAtIndex:0];
                    }
                    if (itemStyle)
                    {
                        if (sectionStyle.item_merge_layout)
                        {
                            StencilItem* item =([adSection.items count] > indexPath.item) ? [adSection.items objectAtIndex:0] : nil;
                            int layoutType = (item && IsStencilItemLayoutByServer(item.layoutType)) ? item.layoutType : itemStyle.defaultLayoutType;
                            if(self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewControllerCellNibName:forLayoutType:)])
                            {
                                NSString *nibName = [self.delegate stencilLayoutViewControllerCellNibName:self forLayoutType:layoutType];
                                if(![self isCellNibNameRegistered:nibName])
                                {
                                    NSString *exception = [NSString stringWithFormat:@"尚未注册的UICollectionViewCell Nib，%@",nibName];
                                    SDK_RAISE_EXCEPTION(exception);
                                    return nil;
                                }
                                StencilItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:nibName forIndexPath:indexPath];
                                cell.parentViewController = self;
                                [cell configWithSection:adSection];
                                return cell;
                            }
                            NSString *exception = [NSString stringWithFormat:@"必须实现stencilLayoutViewControllerCellNibName:forLayoutType:"];
                            SDK_RAISE_EXCEPTION(exception);
                        }
                        else
                        {
                            if([adSection.items count] <= indexPath.item)
                            {
                                NSString *exception = [NSString stringWithFormat:@"非法的indexPath:%@",[indexPath description]];
                                SDK_RAISE_EXCEPTION(exception);
                                return nil;
                            }
                            StencilItem* item = [adSection.items objectAtIndex:indexPath.item];
                            int layoutType = (item && IsStencilItemLayoutByServer(item.layoutType)) ? item.layoutType : itemStyle.defaultLayoutType;
                            
                            int imageLayoutType = StencilItemLayoutLayoutType_Unknown;
                            int webLayoutType = StencilItemLayoutLayoutType_Unknown;
                            if(self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewControllerLayoutTypeForImage:)])
                            {
                                imageLayoutType = [self.delegate stencilLayoutViewControllerLayoutTypeForImage:self];
                            }
                            
                            if(self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewControllerLayoutTypeForWebView:)])
                            {
                                webLayoutType = [self.delegate stencilLayoutViewControllerLayoutTypeForWebView:self];
                            }
                            NSString *nibName = @"";
                            if(layoutType == imageLayoutType && imageLayoutType != StencilItemLayoutLayoutType_Unknown)
                            {
                                nibName = @"StencilItemImageCell";
                            }
                            else if(layoutType == webLayoutType && webLayoutType != StencilItemLayoutLayoutType_Unknown)
                            {
                                nibName = @"StencilItemWebCell";
                            }
                            else if(self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewControllerCellNibName:forLayoutType:)])
                            {
                                nibName = [self.delegate stencilLayoutViewControllerCellNibName:self forLayoutType:layoutType];
                            }
                            else
                            {
                                NSString *exception = [NSString stringWithFormat:@"必须实现stencilLayoutViewControllerCellNibName:forLayoutType:"];
                                SDK_RAISE_EXCEPTION(exception);
                            }
                            if(![self isCellNibNameRegistered:nibName])
                            {
                                NSString *exception = [NSString stringWithFormat:@"尚未注册的UICollectionViewCell Nib，%@",nibName];
                                SDK_RAISE_EXCEPTION(exception);
                                return nil;
                            }
                            StencilItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:nibName forIndexPath:indexPath];
                            cell.parentViewController = self;
                            [cell configWithItem:item];
                            return cell;
                        }
                    }
                }
            }
        }
    }
    NSString *exception = [NSString stringWithFormat:@"无法为indexPath创建UICollectionViewCell，indexPath:%@",[indexPath description]];
    SDK_RAISE_EXCEPTION(exception);
    return nil;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < [_headers count])
    {
        if(self.headerDataSource && [self.headerDataSource respondsToSelector:@selector(stencilLayoutViewController:heightForAdditionalHeaderAtIndex:)])
        {
            CGSize size = CGSizeMake(SDKScreenWidth, [self.headerDataSource stencilLayoutViewController:self heightForAdditionalHeaderAtIndex:indexPath.section]);
            SDKLog(@"sizeForItemAtIndexPath:%@(header section index:%d)", NSStringFromCGSize(size), (int)indexPath.section);
            return size;
        }
        SDKLog(@"sizeForItemAtIndexPath:%@(header section index:%d)", NSStringFromCGSize(CGSizeZero), (int)indexPath.section);
        return CGSizeZero;
    }
    NSInteger section = indexPath.section - [_headers count];
    StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle && [sectionStyle isAvailableForCurrentClientVersion])
                {
                    StencilItemStyle *itemStyle = nil;
                    if (sectionStyle.item_merge_layout)
                    {
                        itemStyle = [sectionStyle.itemStyles firstObject];
                    }
                    else if([sectionStyle.itemStyles count] > indexPath.item)
                    {
                        itemStyle = [sectionStyle.itemStyles objectAtIndex:indexPath.item];
                    }
                    else if(sectionStyle.maxItems == 0)
                    {
                        itemStyle = [sectionStyle.itemStyles objectAtIndex:0];
                    }
                    if (itemStyle)
                    {
                        if (sectionStyle.item_merge_layout)//Merge模式
                        {
                            CGFloat width = (itemStyle.widthType == StencilItemWidthType_Fix) ? itemStyle.fixedWidth : floorf((CGRectGetWidth(self.collectionView.bounds) - SDK_AUTOLAYOUTSPACE(sectionStyle.content_margin_left) - SDK_AUTOLAYOUTSPACE(sectionStyle.content_margin_right) - SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_left) - SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_right))*itemStyle.widthRatio);
                            
                            if(sectionStyle.heightType == StencilSectionHeightType_Auto)//系统自动计算模版高度
                            {
                                if(itemStyle.heightType == StencilItemHeightType_Ratio)
                                {
                                    CGSize size = CGSizeMake(width, width*itemStyle.heightRatioBaseWidth + itemStyle.option_additional_height + sectionStyle.option_additional_height);
                                    SDKLog(@"sizeForItemAtIndexPath:%@(content section index:%d)", NSStringFromCGSize(size), (int)section);
                                    return size;
                                }
                                else if(itemStyle.heightType == StencilItemHeightType_Fix)
                                {
                                    CGSize size = CGSizeMake(width, itemStyle.fixedHeight + itemStyle.option_additional_height + sectionStyle.option_additional_height);
                                    SDKLog(@"sizeForItemAtIndexPath:%@(content section index:%d)", NSStringFromCGSize(size), (int)section);
                                    return size;
                                }
                                else
                                {
                                    NSString *exception = [NSString stringWithFormat:@"Merge模式不支持自定义模版项高度，indexPath:%@",[indexPath description]];
                                    SDK_RAISE_EXCEPTION(exception);
                                    return CGSizeZero;
                                }
                            }
                            else//业务自己计算模版高度
                            {
                                if(self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewController:heightForMergedSection:sectionStyle:sectionWidth:)])
                                {
                                    CGFloat height = [self.delegate stencilLayoutViewController:self heightForMergedSection:adSection sectionStyle:sectionStyle sectionWidth:width];
                                    CGSize size = CGSizeMake(width, height);
                                    SDKLog(@"sizeForItemAtIndexPath:%@(content section index:%d)", NSStringFromCGSize(size), (int)section);
                                    return size;
                                }
                            }
                        }
                        else//非Merge模式
                        {
                            float width = (itemStyle.widthType == StencilItemWidthType_Fix) ? itemStyle.fixedWidth : floorf((CGRectGetWidth(self.collectionView.bounds) - SDK_AUTOLAYOUTSPACE(sectionStyle.content_margin_left) - SDK_AUTOLAYOUTSPACE(sectionStyle.content_margin_right) - SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_left) - SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_right))*itemStyle.widthRatio);
                            
                            
                            if(itemStyle.heightType == StencilItemHeightType_Ratio)
                            {
                                CGSize size = CGSizeMake(width, width*itemStyle.heightRatioBaseWidth + itemStyle.option_additional_height);
                                SDKLog(@"sizeForItemAtIndexPath:%@(content section index:%d)", NSStringFromCGSize(size), (int)section);
                                return size;
                            }
                            else if(itemStyle.heightType == StencilItemHeightType_Fix)
                            {
                                CGSize size = CGSizeMake(width, itemStyle.fixedHeight + itemStyle.option_additional_height);
                                SDKLog(@"sizeForItemAtIndexPath:%@(content section index:%d)", NSStringFromCGSize(size), (int)section);
                                return size;
                            }
                            else
                            {
                                if([adSection.items count] > indexPath.item)
                                {
                                    StencilItem * item = [adSection.items objectAtIndex:indexPath.item];
                                    if(self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewController:heightForCustomItem:itemStyle:itemWidth:)])
                                    {
                                        CGFloat height = [self.delegate stencilLayoutViewController:self heightForCustomItem:item itemStyle:itemStyle itemWidth:width];
                                        CGSize size = CGSizeMake(width, height);
                                        SDKLog(@"sizeForItemAtIndexPath:%@(content section index:%d)", NSStringFromCGSize(size), (int)section);
                                        return size;
                                    }
                                    else
                                    {
                                        NSString *exception = [NSString stringWithFormat:@"自定义模版项高度，必须实现stencilLayoutViewController:heightForCustomItem:itemStyle:itemWidth:"];
                                        SDK_RAISE_EXCEPTION(exception);
                                        return CGSizeZero;
                                    }
                                }
                                else
                                {
                                    SDKLog(@"Section:%@,非法的indexPath:%@", adSection.title, [indexPath description]);
                                    return CGSizeZero;
                                }
                            }
                        }
                    }
                    
                    SDKLog(@"无法找到模版%@样式！", sectionStyle.style_id);
                    return CGSizeZero;
                }
                
            }
        }
    }

    return CGSizeZero;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        if(section < [_headers count])
        {
            return UIEdgeInsetsZero;
        }
        section = section - [_headers count];
        StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle)
                {
                    return UIEdgeInsetsMake(SDK_AUTOLAYOUTSPACE(adSection.fMarginTop), SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_left), SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_bottom), SDK_AUTOLAYOUTSPACE(sectionStyle.section_margin_right));
                }
            }
        }
    }
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionContentAtIndex:(NSInteger)section
{
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        if(section < [_headers count])
        {
            return UIEdgeInsetsZero;
        }
        section = section - [_headers count];
        StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle)
                {
                    return UIEdgeInsetsMake(SDK_AUTOLAYOUTSPACE(sectionStyle.content_margin_top), SDK_AUTOLAYOUTSPACE(sectionStyle.content_margin_left), SDK_AUTOLAYOUTSPACE(sectionStyle.content_margin_bottom), SDK_AUTOLAYOUTSPACE(sectionStyle.content_margin_right));
                }
            }
        }
    }
    return UIEdgeInsetsZero;
}

- (UIColor*)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout backColorForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        if(section < [_headers count])
        {
            return [UIColor clearColor];
        }
        section = section - [_headers count];
        StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle)
                {
                    return sectionStyle.background ? sectionStyle.background :[UIColor clearColor];
                }
            }
        }
    }
    return [UIColor clearColor];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        if(section < [_headers count])
        {
            return 0;
        }
        section = section - [_headers count];
        StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle)
                {
                    return floorf(SDK_AUTOLAYOUTSPACE(sectionStyle.item_line_spacing));
                }
            }
        }
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        if(section < [_headers count])
        {
            return 0;
        }
        section = section - [_headers count];
        StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle)
                {
                    return floorf(SDK_AUTOLAYOUTSPACE(sectionStyle.item_interitem_spacing));
                }
            }
        }
    }
    return 0;
}

#pragma mark --UICollectionViewDelegate

- (void)setIgnoreEvent:(id)isIgnoreEv
{
    _isIgnoreEvent = [isIgnoreEv boolValue];
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickTimeInterval > 0)
    {
        self.isIgnoreEvent = YES;
        [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.clickTimeInterval];
    }
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        if(indexPath.section < [_headers count])
        {
            return;
        }
        NSInteger section = indexPath.section - [_headers count];
        StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle)
                {
                    if (!sectionStyle.item_merge_layout)
                    {
                        if(indexPath.item >= [adSection.items count]) return;
                        StencilItem* item =[adSection.items objectAtIndex:indexPath.item];
                        if([item isKindOfClass:[StencilItem class]] && self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewController:didSelectStencilItem:)])
                        {
                            [self.delegate stencilLayoutViewController:self didSelectStencilItem:item];
                        }
                    }
                }
                
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView && collectionView == self.collectionView && [_dataSource isKindOfClass:[NSArray class]])
    {
        if(indexPath.section < [_headers count])
        {
            return;
        }
        NSInteger section = indexPath.section - [_headers count];
        StencilSectionManager *sectionManager = [StencilSectionManager sharedInstance];
        @synchronized(_dataSource)
        {
            if ([_dataSource count] > section)
            {
                StencilSection *adSection = [_dataSource objectAtIndex:section];
                StencilSectionStyle* sectionStyle = [sectionManager GetSectionStyle:adSection.styleId];
                if (sectionStyle)
                {
                    if (!sectionStyle.item_merge_layout)
                    {
                        if(indexPath.item >= [adSection.items count]) return;
                        StencilItem* item =[adSection.items objectAtIndex:indexPath.item];
                        if([item isKindOfClass:[StencilItem class]] && self.delegate && [self.delegate respondsToSelector:@selector(stencilLayoutViewController:endDisplayCell:stencilItem:)])
                        {
                            [self.delegate stencilLayoutViewController:self endDisplayCell:cell stencilItem:item];
                        }
                    }
                }
                
            }
        }
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isIgnoreEvent)
    {
        SDKLog(@"忽略的点击事件，点击事件间隔：%fs。", self.clickTimeInterval);
        return NO;
    };
    return YES;
}

@end
