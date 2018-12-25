//
//  JABannerView.h
//  JAPhotosBrower
//
//  Created by Jater on 2018/12/21.
//  Copyright © 2018年 Jater. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JABannerView;

NS_ASSUME_NONNULL_BEGIN

@protocol JABannerDelegate <NSObject>

- (void)bannerView:(JABannerView *)bannerView didHorizontalScrollAtIndex:(NSInteger)index preIndex:(NSInteger)preIndex precent:(CGFloat)precent;

@end

@interface JABannerView : UIView

@property (nonatomic, weak) id<JABannerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *imageHeightArray;

- (void)configList:(NSArray <__kindof NSString *> *)linkList;

@end

NS_ASSUME_NONNULL_END
