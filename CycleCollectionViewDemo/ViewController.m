//
//  ViewController.m
//  CycleCollectionViewDemo
//
//  Created by xhj on 15/9/1.
//  Copyright (c) 2015年 XHJ. All rights reserved.
//

#import "ViewController.h"

#import "CycleCollectionView.h"

@interface ViewController ()

@property (strong, nonatomic) CycleCollectionView *banner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.banner = [[CycleCollectionView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, 200)];
    UIColor *r = [UIColor redColor];
    UIColor *g = [UIColor greenColor];
    UIColor *b = [UIColor blueColor];
    self.banner.dataSource = @[r,g,b];
    [self.view addSubview:self.banner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
