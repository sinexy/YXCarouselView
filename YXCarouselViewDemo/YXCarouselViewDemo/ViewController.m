//
//  ViewController.m
//  YXCarouselViewDemo
//
//  Created by yunxin bai on 2019/4/1.
//  Copyright © 2019 yunxin bai. All rights reserved.
//

#import "ViewController.h"
#import "YXCarouselView/YXCarouselView.h"

@interface ViewController ()<YXCarouselViewDelegate, YXCarouselViewDatasource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YXCarouselView *carouselView = [[YXCarouselView alloc] initWithRollingDirection:YXCarouselViewRollingDirectionVertical rollingDuration:3];
    carouselView.userInteractionEnabled = NO;
    [self.view addSubview:carouselView];
    carouselView.frame = CGRectMake(0, 180, self.view.bounds.size.width, 100);
    carouselView.backgroundColor = [UIColor orangeColor];
    carouselView.delegate = self;
    carouselView.dataSource = self;
    [carouselView reloadData];
    [carouselView start];
    
    
    
    YXCarouselView *carouselView1 = [[YXCarouselView alloc] initWithRollingDirection:YXCarouselViewRollingDirectionHorizontal rollingDuration:3];
    carouselView1.userInteractionEnabled = NO;
    [self.view addSubview:carouselView1];
    carouselView1.frame = CGRectMake(0, 300, self.view.bounds.size.width, 200);
    carouselView1.backgroundColor = [UIColor orangeColor];
    carouselView1.delegate = self;
    carouselView1.dataSource = self;
    [carouselView1 reloadData];
    [carouselView1 start];
    
}

- (NSInteger)numberOfItemsInCarouselView:(YXCarouselView *)carouselView {
    return 5;
}

- (void)carouselView:(YXCarouselView *)carouselView didSelectedIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (UIView *)carouselView:(YXCarouselView *)carouselView viewForItemAtIndex:(NSInteger)index {
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, 100, 20);
    label.text = [NSString stringWithFormat:@"这是第%zd个视图",index];
    return label;
}


@end
