//
//  JABannerView.m
//  JAPhotosBrower
//
//  Created by Jater on 2018/12/21.
//  Copyright © 2018年 Jater. All rights reserved.
//

#import "JABannerView.h"

typedef NS_ENUM(NSInteger, ScrollDirection) {
    ScrollDirectionLeft,
    ScrollDirectionMiddle,
    ScrollDirectionRight
};

@interface JABannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *currentImageView;

@property (nonatomic, strong) UIImageView *otherImageView;

@property (nonatomic, strong) NSMutableArray *imageListArray;
@end

static NSString *const kkeyPath = @"contentOffset";

#define WIDTH CGRectGetWidth(self.bounds)
#define HEIGHT CGRectGetHeight(self.bounds)


@implementation JABannerView {
    NSArray *_colors;
    NSInteger _curIndex;
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:kkeyPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self drawUI];
        self.imageListArray = [NSMutableArray array];
        self.imageHeightArray = [NSMutableArray array];
        _colors = @[UIColor.redColor, UIColor.blueColor];
    }
    return self;
}

- (void)drawUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(3*CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    self.currentImageView.backgroundColor = UIColor.redColor;
    self.otherImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.otherImageView.backgroundColor = UIColor.blueColor;
    
    [self.scrollView setContentOffset:CGPointMake(WIDTH, 0)];
    
    [self.scrollView addSubview:self.currentImageView];
    [self.scrollView addSubview:self.otherImageView];
    
    [self.scrollView addObserver:self forKeyPath:kkeyPath options:NSKeyValueObservingOptionNew context:nil];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
}

- (void)configList:(NSArray <__kindof NSString *> *)linkList {
    if (linkList.count == 0) {
        return;
    }
    sself.scrollView.scrollEnabled = sself.imageListArray.count > 1;
    if (!sself.currentImageView.image) {
        sself.currentImageView.image = image;
        if ([self.delegate respondsToSelector:@selector(bannerView:didHorizontalScrollAtIndex:preIndex:precent:)]) {
            [self.delegate bannerView:self didHorizontalScrollAtIndex:0 preIndex:0 precent:1];
        }

    
    
    
    [linkList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        __weak typeof(self) wself = self;
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:obj] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            __strong typeof(wself) sself = wself;
            if (error) {
                NSLog(@"error %@", error);
                return;
            }
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            if (!image) {
                return;
            }
            CGFloat imageHeight = UIScreen.mainScreen.bounds.size.width/image.size.width*image.size.height;
            [sself.imageHeightArray addObject:@(imageHeight)];
            [sself.imageListArray addObject:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                }
            });
        }];
        [task resume];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat contentOff_x = scrollView.contentOffset.x;
    if (contentOff_x < WIDTH) {
        [self.scrollView setContentOffset:CGPointMake(WIDTH, 0)];
        self.currentImageView.image = self.otherImageView.image;
        CGRect curImageRect = self.currentImageView.frame;
        NSInteger leftIndex = _curIndex-1;
        if (leftIndex < 0) {
            leftIndex = self.imageListArray.count-1;
        }
        _curIndex = leftIndex;
        curImageRect.size.height = [_imageHeightArray[_curIndex] floatValue];
        self.currentImageView.frame = curImageRect;
    } else if (contentOff_x > WIDTH) {
        [self.scrollView setContentOffset:CGPointMake(WIDTH, 0)];
        self.currentImageView.image = self.otherImageView.image;
        CGRect curImageRect = self.currentImageView.frame;
        NSInteger rightIndex = _curIndex+1;
        if (rightIndex >= self.imageListArray.count) {
            rightIndex = 0;
        }
        _curIndex = rightIndex;
        curImageRect.size.height = [_imageHeightArray[_curIndex] floatValue];
        self.currentImageView.frame = curImageRect;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    CGRect curImageRect = self.currentImageView.frame;
    curImageRect.size.height = CGRectGetHeight(self.scrollView.frame);
    self.currentImageView.frame = curImageRect;
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kkeyPath]) {
        CGFloat contentOffset_x = self.scrollView.contentOffset.x;
        CGFloat current_x = CGRectGetMinX(self.currentImageView.frame);
        
        ScrollDirection direction = ScrollDirectionMiddle;
        if (contentOffset_x < current_x) {
            direction = ScrollDirectionLeft;
        } else if (contentOffset_x > current_x) {
            direction = ScrollDirectionRight;
        }
        
        switch (direction) {
            case ScrollDirectionLeft: {
                NSInteger leftIndex = _curIndex-1;
                if (leftIndex < 0) {
                    leftIndex = self.imageListArray.count-1;
                }
                CGFloat curHeight = [_imageHeightArray[_curIndex] floatValue];
                CGFloat otherHeight = [_imageHeightArray[leftIndex] floatValue];
                CGFloat differenceHeight = otherHeight - curHeight;
                BOOL otherThanCur = YES;
                if (curHeight > otherHeight) {
                    otherThanCur = NO;
                    differenceHeight = curHeight - otherHeight;
                }
                CGFloat progress = 1-contentOffset_x/WIDTH;
                NSLog(@"differenceHeight*progress %f", differenceHeight*progress);
                if (otherThanCur) {
                    self.otherImageView.frame = CGRectMake(0, 0, WIDTH, curHeight+differenceHeight*progress);
                } else {
                    self.otherImageView.frame = CGRectMake(0, 0, WIDTH, curHeight-differenceHeight*progress);
                }
                self.otherImageView.image = _imageListArray[leftIndex];
                if ([self.delegate respondsToSelector:@selector(bannerView:didHorizontalScrollAtIndex:preIndex:precent:)]) {
                    [self.delegate bannerView:self didHorizontalScrollAtIndex:leftIndex preIndex:_curIndex precent:progress];
                }
            }
                
                break;
            case ScrollDirectionRight: {
                NSInteger rightIndex = _curIndex+1;
                if (rightIndex >= self.imageListArray.count) {
                    rightIndex = 0;
                }
                CGFloat curHeight = [_imageHeightArray[_curIndex] floatValue];
                CGFloat otherHeight = [_imageHeightArray[rightIndex] floatValue];
                CGFloat differenceHeight = otherHeight - curHeight;
                BOOL otherThanCur = YES;
                if (curHeight > otherHeight) {
                    otherThanCur = NO;
                    differenceHeight = curHeight - otherHeight;
                }
                CGFloat progress = contentOffset_x/WIDTH-1;
                
                if (otherThanCur) {
                    self.otherImageView.frame = CGRectMake(WIDTH*2, 0, WIDTH, curHeight+differenceHeight*progress);
                } else {
                    self.otherImageView.frame = CGRectMake(WIDTH*2, 0, WIDTH, curHeight-differenceHeight*progress);
                }
                self.otherImageView.image = _imageListArray[rightIndex];
                if ([self.delegate respondsToSelector:@selector(bannerView:didHorizontalScrollAtIndex:preIndex:precent:)]) {
                    [self.delegate bannerView:self didHorizontalScrollAtIndex:rightIndex preIndex:_curIndex precent:progress];
                }
            }
                break;
            default:
                break;
        }
    }
}

@end
