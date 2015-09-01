//
//  AutoScrollView.m
//  跳转框架的搭建
//
//  Created by xhj on 15/8/31.
//  Copyright (c) 2015年 MLS. All rights reserved.
//

#import "CycleCollectionView.h"
//#import "CollectionViewCell.h"



static CGFloat paddingLeft = 0;

static CGFloat paddingRight = 30;

static NSInteger repeatCount = 3;
#define COUNT 3


@interface CycleCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIPageControl *pageController;

@property (strong, nonatomic) NSMutableArray *colorArray;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;
@end

@implementation CycleCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void) setup{
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
//    init collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:self.collectionView];
    
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressDetected:)];
    self.longPressGesture.delegate = self;
    [self.collectionView addGestureRecognizer:self.longPressGesture];
    

    [self addSubview:self.pageController];

    [self startTimer];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [self.dataSource objectAtIndex:indexPath.item % COUNT ];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3 * repeatCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}



//停止滑动时调用。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentPage = (int)(offsetX / scrollView.frame.size.width) % COUNT;
    self.pageController.currentPage = currentPage;
    
    NSInteger actuallyImageIndex = (NSInteger)(self.collectionView.contentOffset.x / self.frame.size.width) % COUNT;
    if (self.collectionView.contentOffset.x == 0 || self.collectionView.contentOffset.x == (self.collectionView.contentSize.width - self.frame.size.width)) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(COUNT+ actuallyImageIndex) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self startTimer];
}

- (void) nextPage{
    UIScrollView *scrollView = self.collectionView;
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX += self.frame.size.width;
    scrollView.contentOffset = CGPointMake(offsetX, scrollView.contentOffset.y);
    NSInteger currentPage = (int)(offsetX / scrollView.frame.size.width) % COUNT;
    self.pageController.currentPage = currentPage;
    
    NSInteger actuallyImageIndex = (NSInteger)(self.collectionView.contentOffset.x / self.frame.size.width) % COUNT;
    if (self.collectionView.contentOffset.x == 0 || self.collectionView.contentOffset.x == (self.collectionView.contentSize.width - self.frame.size.width)) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(COUNT+ actuallyImageIndex) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    

}



- (void)resetPageController{
    _pageController.numberOfPages = self.dataSource.count;
    _pageController.currentPage = self.selectedIndex;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_pageController sizeToFit];
    CGFloat pageControllerHeight = [_pageController sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGRect frame =  _pageController.frame;
    frame.origin.x = 0;
    frame.origin.y = self.frame.size.height - pageControllerHeight;
    _pageController.frame = frame;
//    
//    NSLog(@"self.frame  ---- %@   frame:%@ ---- %d----",NSStringFromCGRect(self.frame), NSStringFromCGRect(frame),_pageController.numberOfPages);
}

- (UIPageControl *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageControl alloc] init];
    }
    return _pageController;
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self resetPageController];
}


- (void)longPressDetected:(UIGestureRecognizer *)gesture{
    UIGestureRecognizerState state = gesture.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            [self stopTimer];
            break;
        case UIGestureRecognizerStateEnded:
            [self startTimer];
            break;
        default:
            break;
    }
}



#pragma mark 定时器的相关方法
- (NSTimer *)timer{
    
    if(!_timer){
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (void) stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void) startTimer{
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


@end



