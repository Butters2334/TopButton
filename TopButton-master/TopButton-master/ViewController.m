//
//  ViewController.m
//  TopButton-master
//
//  Created by Ancc on 15/2/10.
//  Copyright (c) 2015年 Ancc. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+TopButton.h"
#define APPBOUNDS [UIScreen mainScreen].bounds/*设备的屏幕尺寸*/
#define APPW APPBOUNDS.size.width/*设备的宽*/
#define APPH APPBOUNDS.size.height/*设备的高*/

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *theView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPW,APPH)
                                                       style:UITableViewStylePlain];
    [theView setDelegate:self];
    theView.dataSource=self;
    [self.view addSubview:theView];
    
    [self addTopButton:theView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ({
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.text = [NSString stringWithFormat:@"row - %@",@(indexPath.row)];
        cell;
    });
}
@end
