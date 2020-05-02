//
//  StencilLayoutViewController.h
//  StencilLayout
//
//  Created by pcjbird on 2016/11/9.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StencilLayout/StencilInfo.h>
#import <StencilLayout/StencilModel.h>
@class StencilLayoutViewController;

/**
 *@brief StencilLayoutViewControllerDelegate
 */
@protocol StencilLayoutViewControllerDelegate <NSObject>
@required
/**
 *@brief CellNibs数据源，用于registerNib
 *@param vc StencilLayoutViewController
 *@return nib name的字符串数组
 */
-(nullable NSArray*) stencilLayoutViewControllerCellNibNames:(nonnull StencilLayoutViewController*)vc;
/**
 *@brief 模版标题高度（非隐藏的）,不包含Addtional Header的部分，AddtionalHeader暂时不支持Section Header
 *@param vc StencilLayoutViewController
 *@return 标题高度
 */
-(CGFloat) heightForStencilLayoutViewControllerVisibleSectionHeader:(nonnull StencilLayoutViewController*)vc;
/**
 *@brief 返回指定布局类型对应的模版项Nib Name
 *@param vc StencilLayoutViewController
 *@param layoutType 布局类型
 *@return 模版项Nib Name
 */
-(nullable NSString*) stencilLayoutViewControllerCellNibName:(nonnull StencilLayoutViewController*)vc forLayoutType:(int)layoutType;
/**
 *@brief ImageCell对应的布局类型编号 （系统默认实现图片类型的模版）
 *@param vc StencilLayoutViewController
 *@return 布局类型编号
 */
-(int)stencilLayoutViewControllerLayoutTypeForImage:(nonnull StencilLayoutViewController*)vc;
/**
 *@brief WebCell对应的布局类型编号 （系统默认实现Web类型的模版）
 *@param vc StencilLayoutViewController
 *@return 布局类型编号
 */
-(int)stencilLayoutViewControllerLayoutTypeForWebView:(nonnull StencilLayoutViewController*)vc;
@optional
/**
 *@brief 点击模版项
 *@param vc StencilLayoutViewController
 *@param stencilItem 模版项
 */
-(void) stencilLayoutViewController:(nonnull StencilLayoutViewController*)vc didSelectStencilItem:(nonnull StencilItem*)stencilItem;

/**
 *@brief 结束显示模版项
 *@param vc StencilLayoutViewController
 *@param cell 对应的UICollectionViewCell
 *@param stencilItem 模版项
 */
-(void) stencilLayoutViewController:(nonnull StencilLayoutViewController*)vc endDisplayCell:(nonnull UICollectionViewCell*)cell stencilItem:(nonnull StencilItem*)stencilItem;
/**
 *@brief Merge模式的模版高度计算，只有Section的heightType设置成1的模版才会调用该方法
 *@param vc StencilLayoutViewController
 *@param adSection section
 *@param sectionStyle section样式
 *@param sectionWidth 模版宽度
 *@return 模版高度
 */
-(CGFloat) stencilLayoutViewController:(nonnull StencilLayoutViewController*)vc heightForMergedSection:(nonnull StencilSection *)adSection sectionStyle:(nonnull StencilSectionStyle*)sectionStyle sectionWidth:(CGFloat)sectionWidth;
/**
 *@brief 非Merge模式，自定义类型高度的模版项高度，只有当item的heightType设置成2的模版项才会调用该方法
 *@param vc StencilLayoutViewController
 *@param item 模版项数据
 *@param itemStyle 模版项样式
 *@param itemWidth 模版项宽度
 *@return 模版项高度
 */
-(CGFloat) stencilLayoutViewController:(nonnull StencilLayoutViewController*)vc  heightForCustomItem:(nonnull StencilItem*)item itemStyle:(nonnull StencilItemStyle*)itemStyle itemWidth:(CGFloat)itemWidth;
/**
 *@brief 模版标题Nib Name
 *@param vc StencilLayoutViewController
 *@return 模版标题的Nib Name
 */
-(nullable NSString*) stencilLayoutViewControllerSectionHeaderNibName:(nonnull StencilLayoutViewController*)vc;
/**
 *@brief 模版Footer Nib Name
 *@param vc StencilLayoutViewController
 *@return 模版Footer的Nib Name
 */
-(nullable NSString*) stencilLayoutViewControllerSectionFooterNibName:(nonnull StencilLayoutViewController*)vc;
/**
 *@brief 预处理链接，比如设置Cookie，其他对url进行预处理等
 *@param vc StencilLayoutViewController
 *@param pageUrl 原始url
 *@return 处理好的url地址
 */
-(nonnull NSString *) stencilLayoutViewController:(nonnull StencilLayoutViewController*)vc prepareWebUrl:(nonnull NSString*)pageUrl;

@end

/**
 *@brief StencilLayoutViewControllerAdditionalHeaderDataSource
 */
@protocol StencilLayoutViewControllerAdditionalHeaderDataSource <NSObject>
@optional
/**
 *@brief AdditionalHeaderCellNibs数据源，用于registerNib
 *@param vc StencilLayoutViewController
 *@return nib name的字符串数组
 */
-(nullable NSArray*) stencilLayoutViewControllerAdditionalHeaderNibNames:(nonnull StencilLayoutViewController*)vc;
/**
 *@brief AdditionalHeaderCell的高度
 *@param vc StencilLayoutViewController
 *@param index 索引，从0开始
 *@return AdditionalHeaderCell的高度
 */
-(CGFloat) stencilLayoutViewController:(nonnull StencilLayoutViewController*)vc heightForAdditionalHeaderAtIndex:(NSInteger)index;

@end

/**
 *@brief StencilLayoutViewControllerAdditionalFooterDataSource
 */
@protocol StencilLayoutViewControllerAdditionalFooterDataSource <NSObject>
@optional
/**
 *@brief AdditionalFooterCellNibs数据源，用于registerNib
 *@param vc StencilLayoutViewController
 *@return nib name的字符串数组
 */
-(nullable NSArray*) stencilLayoutViewControllerAdditionalFooterNibNames:(nonnull StencilLayoutViewController*)vc;
/**
 *@brief AdditionalFooterCell的高度
 *@param vc StencilLayoutViewController
 *@param index 索引，从0开始
 *@return AdditionalFooterCell的高度
 */
-(CGFloat) stencilLayoutViewController:(nonnull StencilLayoutViewController*)vc heightForAdditionalFooterAtIndex:(NSInteger)index;

@end

/**
 *@brief StencilLayoutViewController
 */
@interface StencilLayoutViewController : UIViewController

/**
 *@brief bool 类型   设置是否执行点UI方法
 */
@property (nonatomic, assign) BOOL isIgnoreEvent;

/**
*@brief 点击时间间隔
*/
@property (nonatomic, assign) NSTimeInterval clickTimeInterval;

/**
 *@brief collectionView容器
 */
@property (strong, nonatomic, readonly, nullable) UICollectionView *collectionView;

/**
 *@brief delegate
 */
@property(nullable, nonatomic, weak) id<StencilLayoutViewControllerDelegate> delegate;

/**
 *@brief additional header datasource
 */
@property(nullable, nonatomic, weak) id<StencilLayoutViewControllerAdditionalHeaderDataSource> headerDataSource;

/**
 *@brief additional footer datasource
 */
@property(nullable, nonatomic, weak) id<StencilLayoutViewControllerAdditionalFooterDataSource> footerDataSource;

/**
 *@brief 设置附加头部数据源
 *@param ds 数据源
 *@note 倘若头部某一section确实不需要填充数据源，请填写STENCILADDITIONALHEADERDATASOURCEPLACEHOLDER 数据源占位符，不能为空
 */
-(void) setAdditionalHeaderDataSource:(nullable NSArray*)ds;

/**
 *@brief 设置附加尾部数据源
 *@param ds 数据源
 *@note 倘若尾部某一section确实不需要填充数据源，请填写STENCILADDITIONALFOOTERDATASOURCEPLACEHOLDER 数据源占位符，不能为空
 */
-(void) setAdditionalFooterDataSource:(nullable NSArray*)ds;

/**
 *@brief 加载数据源
 *@param ds 数据源
 *@param bReplace 是否替换已有数据源
 */
-(void) loadWithDataSource:(nullable NSArray*)ds replaceOld:(BOOL)bReplace;

@end
