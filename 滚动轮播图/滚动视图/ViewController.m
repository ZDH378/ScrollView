//
//  ViewController.m
//  滚动视图
//
//  Created by 张东辉 on 2019/7/24.
//  Copyright © 2019 张东辉. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "ZDH_ScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZDH_ScrollView *zdh = [[ZDH_ScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds imageNames:@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"]];
    [zdh scrollWithTimeInterval:1];
    zdh.backgroundColor = [UIColor greenColor];
    [self.view addSubview:zdh];
   
   
    

}


@end
