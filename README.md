# YXCarouselView


一个轻量级的轮播图，使用简单。

只用实现两个数据源方法和一个代理方法，基本可满足日常开发需要

```
- (NSInteger)numberOfItemsInCarouselView:(YXCarouselView *)carouselView;
- (UIView *)carouselView:(YXCarouselView *)carouselView viewForItemAtIndex:(NSInteger)index;
- (void)carouselView:(YXCarouselView *)carouselView didSelectedIndex:(NSInteger)index;
```

效果视频：
<!--<iframe height=498 width=510 src="https://github.com/sinexy/YXCarouselView/blob/master/carousel.mov" frameborder=0 allowfullscreen></iframe>-->

<video controls="" preload="none" poster=""><source src="https://github.com/sinexy/YXCarouselView/blob/master/carousel.mov"></video>


具体使用方法见 Demo

