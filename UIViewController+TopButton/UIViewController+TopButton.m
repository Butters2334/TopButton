//
//  UIViewController+TopButton.m
//  muyingzhijia
//
//  Created by Ancc on 15/2/6.
//  Copyright (c) 2015年 ancc. All rights reserved.
//

#import "UIViewController+TopButton.h"
#import <objc/runtime.h>

///////////////////////////////////////////////////////////////////////////////////////////
#define APPBOUNDS [UIScreen mainScreen].bounds/*设备的屏幕尺寸*/
#define APPW APPBOUNDS.size.width/*设备的宽*/
#define APPH APPBOUNDS.size.height/*设备的高*/

///////////////////////////////////////////////////////////////////////////////////////////
typedef void(^scrollViewDidScrollBlock)(CGFloat);
/**
 *  KVO控制类,分类使用KVO监控的时候如果分类对应的实类也使用KVO的话,分类里面的KVO回调函数就不会被激活,这里专门建立了一个控制器类来做这个事情-专门用于监控KVO回调函数
 * @author Anccccccc, 15-02-06 23:02:26
 */
@interface KVO_Control:NSObject
@property (nonatomic,copy)scrollViewDidScrollBlock scrollBlock;
-(instancetype)initWithBlock:(scrollViewDidScrollBlock)block;
@end
@implementation KVO_Control
-(instancetype)initWithBlock:(scrollViewDidScrollBlock)block
{
    self = [super init];
    if(self && block)
    {
        self.scrollBlock=block;
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //    [self setScrollViewContentOffSet:object];
    if([object isKindOfClass:UIScrollView.class])
    {
        if(self.scrollBlock)
        {
            self.scrollBlock(((UIScrollView*)object).contentOffset.y);
        }
    }
}
@end
///////////////////////////////////////////////////////////////////////////////////////////
#define TOPBUTTON_KEY "topButtonKey_for_objc"
#define SCROLLVIEW_KEY "scrollViewKey_for_objc"

@implementation UIViewController (TopButton)
/**
 *  添加一个点击可以回到滑动视图最顶点的按钮,按钮添加在vc类的根view上面
 *  传入scrollView来监控高度,当超过一定高度时显示按钮,否则不
 *
 *  @author Anccccccc, 15-02-06 17:02:42
 *
 *  @param scrollView 用于监控高度的滑动视图,超过约束的高度后显示按钮
 */
-(void)addTopButton:(UIScrollView *)scrollView
{
    //APPH-64-49-50 获取屏幕高度减去nav高度,tabbar高度,按钮自身加上间距
    //由于这边项目很多地方的scrollView的高度并不是常规的滑动高度,虽然这里直接获取高度更好,但是不适合这边的项目..
    CGFloat scrollViewHeight    =   scrollView.frame.size.height;
    CGFloat dcHeight            =   APPH;
//    判断nav是否被隐藏
//    if([VCNAV isHideTabBar])
//    {
//        dcHeight-=64;
//    }
//    判断UITabBar是否被隐藏,此处需要考虑不同项目的代码,暂且不论
//    if(![APPTABBAR isHideTabBar])
//    {
//        dcHeight-=49;
//    }
    dcHeight-=scrollView.frame.origin.y;
    //判断当前的滑动视图是否超过它应该的高度
    if(scrollViewHeight>dcHeight)
    {
        scrollViewHeight=dcHeight;
    }
    //减掉该分类按钮所需要的高度(40按钮,10px留白)
    scrollViewHeight-=50;
    //需要跟滑动视图对齐,所以需要相同的起点
    scrollViewHeight+=scrollView.frame.origin.y;
    UIButton *topButton = [[UIButton alloc]initWithFrame:CGRectMake(APPW-50, scrollViewHeight, 40, 40)];
    [topButton setImage:[UIImage imageNamed:@"topButtonImage"]
               forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(topButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    topButton.hidden=YES;
    //直接放置在滑动视图的父级上面,或者是当前根视图
    [scrollView.superview?scrollView.superview:self.view addSubview:topButton];
    
    //添加两个变量到全局(分类不能使用全局变量)
    objc_setAssociatedObject(self, &TOPBUTTON_KEY, topButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &SCROLLVIEW_KEY, scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    //添加监控
    __weak typeof(self) bself =self;
    KVO_Control *control = [[KVO_Control alloc]initWithBlock:^(CGFloat contentOffSetY){
        [bself setHiddenTopButton:contentOffSetY<300];
    }];
    objc_setAssociatedObject(self, &"kvo_control", control, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [scrollView addObserver:control forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:nil];
}
-(void)topButtonEvent:(UIButton *)topButton
{
    //在某些情况下,scrollView会有滑动间隔,暂时获取不到对应的值,暂时不使用api自带的滑动功能,改使用普通的滑动控制
    //[weak_scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    UIScrollView *scrollView = objc_getAssociatedObject(self, &SCROLLVIEW_KEY);
    [scrollView setContentOffset:CGPointZero animated:YES];
    [self setHiddenTopButton:YES];
}
-(void)setHiddenTopButton:(BOOL)hidden
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *topButton = objc_getAssociatedObject(self, &TOPBUTTON_KEY);
        if([topButton isKindOfClass:UIButton.class])
        {
            topButton.hidden=hidden;
        }
    });
}
@end

