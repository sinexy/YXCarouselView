//
//  YXCarouselView.h
//  YXCarouselViewDemo
//
//  Created by yunxin bai on 2019/4/1.
//  Copyright © 2019 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXCarouselView;

typedef enum : NSUInteger {
    
    YXCarouselViewRollingDirectionVertical,  // 垂直方向
    YXCarouselViewRollingDirectionHorizontal,  // 水平方向
    
} YXCarouselViewRollingDirection;

@protocol YXCarouselViewDelegate <NSObject>

@optional
- (void)carouselView:(YXCarouselView *)carouselView didSelectedIndex:(NSInteger)index;

@end

@protocol YXCarouselViewDatasource <NSObject>

- (NSInteger)numberOfItemsInCarouselView:(YXCarouselView *)carouselView;

- (UIView *)carouselView:(YXCarouselView *)carouselView viewForItemAtIndex:(NSInteger)index;

@end



@interface YXCarouselView : UIView

@property (nonatomic, weak) id<YXCarouselViewDelegate> delegate;
@property (nonatomic, weak) id<YXCarouselViewDatasource> dataSource;
/** 只有一个视图时，是否滚动 默认不滚动*/
@property (nonatomic, assign) BOOL isScrollForOne;


@property (nonatomic, strong, readonly) NSIndexPath *indexPath;


- (instancetype)initWithRollingDirection:(YXCarouselViewRollingDirection)direction rollingDuration:(NSTimeInterval)duration;
/** 开始自动轮播 */
- (void)start;
/** 停止自动轮播 */
- (void)remove;
/** 刷新数据 */
- (void)reloadData;

@end


