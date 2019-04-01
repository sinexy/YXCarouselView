//
//  YXCarouselView.m
//  YXCarouselViewDemo
//
//  Created by yunxin bai on 2019/4/1.
//  Copyright © 2019 yunxin bai. All rights reserved.
//

#import "YXCarouselView.h"

@interface YXCarouselView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableDictionary *viewDictionaryM;

@property (nonatomic, strong) NSTimer *autoScrollTimer;
/** 滚动间隔时间 默认 3 秒*/
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSInteger currentSection; // 记录当前的组数
@property (nonatomic, assign) NSInteger currentRow; // 记录当前的行数
@property (nonatomic, assign) NSInteger totalItems;   // 总计有多少项
@property (nonatomic, assign) NSInteger totalSections;   // 总计有多少组
@property (nonatomic, assign) YXCarouselViewRollingDirection dircetion;
@property (nonatomic, strong, readwrite) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isDrag;  // 动手了
@end

@implementation YXCarouselView

const static NSInteger kScrollSectionMax = 100;
const static NSInteger kScrollSectionMiddle = kScrollSectionMax * 0.5;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.duration = 3;
        self.dircetion = YXCarouselViewRollingDirectionHorizontal;

    }
    return self;
}

- (instancetype)initWithRollingDirection:(YXCarouselViewRollingDirection)direction rollingDuration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        self.duration = duration;
        self.dircetion = direction;
        [self addSubview:self.collectionView];
        [self layoutCollectionView];
        [self initScrollLocation];
    }
    return self;
}

- (void)start {
    if ([self initNumbers]) {
        return;
    }
    [self startScroll];
    [[NSRunLoop mainRunLoop] addTimer:self.autoScrollTimer forMode:NSDefaultRunLoopMode];
}

- (void)remove {
    if (self.autoScrollTimer) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)reloadData {
    [self.viewDictionaryM removeAllObjects];
    [self.collectionView reloadData];
}


#pragma mark - Private Method

- (void)layoutCollectionView {
    // 左侧与父视图左侧对齐
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    // 右侧与父视图右侧对齐
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    // 顶部与父视图顶部对齐
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    // 底部与父视图底部对齐
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.flowLayout.itemSize = self.bounds.size;
    [self initScrollLocation];
}

- (void)initScrollLocation {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInCarouselView:)]) {
        self.totalItems = [self.dataSource numberOfItemsInCarouselView:self];
    }
    if (self.totalItems == 0) {
        return;
    }
    self.currentRow = 0;
    [self initNumbers];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentRow inSection:self.currentSection];
    if (self.dircetion == YXCarouselViewRollingDirectionVertical) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }else {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }

}

- (void)startScroll {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentRow inSection:self.currentSection];
    if (self.dircetion == YXCarouselViewRollingDirectionVertical) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }else {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }

    
    self.currentRow++;
    if (self.currentRow >= self.totalItems) {
        self.currentSection++;
        self.currentRow = 0;
    }
    if (self.currentSection >= kScrollSectionMax) {
        self.currentSection = kScrollSectionMiddle;
    }
    
}

- (BOOL)initNumbers {
    if (self.totalItems > 1) {
        self.totalSections = kScrollSectionMax;
        self.currentSection = kScrollSectionMiddle;
        return YES;
    }else {
        self.totalSections = self.isScrollForOne ? kScrollSectionMax : self.totalItems;
        self.currentSection = self.isScrollForOne ? kScrollSectionMiddle : self.totalItems;
        return self.isScrollForOne;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isDrag = YES;
}

#pragma mark - UICollectionView Delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInCarouselView:)]) {
        self.totalItems = [self.dataSource numberOfItemsInCarouselView:self];
    }
    [self initNumbers];

    return self.totalSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalItems;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *view = [self.viewDictionaryM objectForKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
    if (view) {
        [cell.contentView addSubview:view];
    }else {
        if ([self.dataSource respondsToSelector:@selector(carouselView:viewForItemAtIndex:)]) {
            view = [self.dataSource carouselView:self viewForItemAtIndex:indexPath.row];
            [self.viewDictionaryM setObject:view forKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
            [cell.contentView addSubview:view];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDrag && self.indexPath.row != indexPath.row && self.indexPath.section == indexPath.section) {  // 有拖拽
        self.currentRow = self.indexPath.row;
        self.isDrag = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectedIndex:)]) {
        [self.delegate carouselView:self didSelectedIndex:indexPath.row];
    }
}


#pragma mark - Setter and Getter
- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    [self remove];

}

- (void)setIsScrollForOne:(BOOL)isScrollForOne {
    _isScrollForOne = isScrollForOne;
    [self initNumbers];
    [self remove];
    [self initScrollLocation];

}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        _flowLayout.scrollDirection = self.dircetion == YXCarouselViewRollingDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSTimer *)autoScrollTimer {
    if (!_autoScrollTimer) {
        _autoScrollTimer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(startScroll) userInfo:nil repeats:YES];
    }
    return _autoScrollTimer;
}

- (NSMutableDictionary *)viewDictionaryM {
    if (!_viewDictionaryM) {
        _viewDictionaryM = [NSMutableDictionary dictionary];
    }
    return _viewDictionaryM;
}

#pragma mark - 释放定时器
- (void)dealloc {
    [self remove];
}
@end
