//
//  AutoScrollView.h
//  跳转框架的搭建
//
//  Created by xhj on 15/8/31.
//  Copyright (c) 2015年 MLS. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, PageControllerAlignment){
    PageControllerAlignmentLeft,
    PageControllerAlignmentMiddle,
    PageControllerAlignmentRight
};

@interface CycleCollectionView : UIView
/**
 *  图片轮播模型数据源
 */
@property (copy, nonatomic) NSArray *dataSource;
/**
 *  轮播指示器的相对位置
 */
@property (assign, nonatomic) PageControllerAlignment pageControllerAlignment;

/**
 *  轮播当前选中的下标
 */
@property (assign, nonatomic) NSInteger selectedIndex;
@end
