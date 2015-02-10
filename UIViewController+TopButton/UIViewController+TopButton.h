//
//  UIViewController+TopButton.h
//  muyingzhijia
//
//  Created by Ancc on 15/2/6.
//  Copyright (c) 2015年 ancc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TopButton)
/**
 *  添加一个点击可以回到滑动视图最顶点的按钮,按钮添加在vc类的根view上面
 *  传入scrollView来监控高度,当超过一定高度时显示按钮,否则不
 *
 *  @author Anccccccc, 15-02-06 17:02:42
 *
 *  @param scrollView 用于监控高度的滑动视图,超过约束的高度后显示按钮
 */
-(void)addTopButton:(UIScrollView *)scrollView;
@end
