//
//  ViewController.m
//  JAPhotosBrower
//
//  Created by Jater on 2018/12/21.
//  Copyright © 2018年 Jater. All rights reserved.
//

#import "ViewController.h"
#import "JABannerView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, JABannerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.lightGrayColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    JABannerView *bannerView = [[JABannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    bannerView.delegate = self;
    self.tableView.tableHeaderView = bannerView;
    
    
    NSArray *dpPicList = @[@"77VeFOuzAxaccfcGLAASBooXa5nAFx_-lC_tzWbcV_yPDYDDZX7IV0xLQfDEUj1TB0DyA-onVGQLyuwJq6V6CA.webp",
    @"cBKJdZafbSXk7QXy6WqsHTIPf_FgS9kT-UMk_tZUvrSAk4lcdoerhNnOu98jR0Bbc85PxhdAUxMDoaUwNgvjnNL3T7QoZqeOSG4CiVzlFxs.webp",
    @"ZrPZ4TVqrqKyIQb0G-5ApzA_mOqX-8AlhBlChh1STs3_pVIiktzaDC8BKQHiPIiIgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"CWd1jKXreQ7KCyiIP3KZThhb0Wqs7v7JtOaMYiS1WOuHWTOWjJLDkK3Muj8YZ3X0B0DyA-onVGQLyuwJq6V6CA.webp",
    @"MMojzwtt2R2i5YCYfx50cQ92P-gKcVq0yCIplJbjQA2r8Y0PBhN6zWOUq92oiJ18gAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"VeP30yXNgA0XDgKgnHE9MUbexQqiAlJpaGO3FaQLOQ3UPSStNvH_0XjYbGAQbUQkgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"Af5ZEt0C3RMAu0XaWe8-WwWaa0Af6F-ILJ-pn1-tgryDew_49RcTM7khCutGX-KIgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"4RANAf5NpA3gjAh_ojmKsvBxe8VPeI8x2AK2FqPYzWlgdba2yeMsJc8kDkidKbwBgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"V0nc1SfkBWAdeYsfFVD6drhcHzqMeHLc-R4fFZ2WiyhBcwUlB3pnODDQuDGQg0bLgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"2oglqpsz70-2W8fySJLuoJOckcEKSUlLzu5o2uYS8JaTdVRzeozAa9T0DWT2ZcKRgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"b_OYQS2qhqDigAYyaQ8DlDQwIdO9Iaz3Grnw1Fu9MdPoEswSqAaRQBHReVGBiyvIgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"CQ5fkNBItfE1NrlfmVlfq6I52K9vufuTU-1cSZ-7iEPVioFBOc86zK7McbJTQG8HgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"GG7JA6OU_SbyvzaGunlkbKq2x1Ety14S2ekvhnFQdqOYJCPj3zhTF7uFnMT45KnbB0DyA-onVGQLyuwJq6V6CA.webp",
    @"ZJ9t-GQJWSzEuTykEpPyukmxSrq3pBY7KicoMbPTd95Bw1HmopT0pH_Id9YVM3tdgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"nIY21BJgsvPP8yScZrBziM_oMVRkX2ZV6Pz5EP-_0BpoClqPTAkaY2SfAyWNhaGxgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"h2AhO27BGgaLsALbIjT8Bmqz_KHdBChbdqATRHKSVJN6k0y9cwqN858hCYm_w_mTgAGBz57lP_pNZ78Sx00kb9L3T7QoZqeOSG4CiVzlFxs.webp",
    @"C6r9V0WA9HuFjtxDYDzEaK2ekaSZ3IYAjQ24eeQU7lnt2D5U5y4i2exYGY9EXw4lB0DyA-onVGQLyuwJq6V6CA.webp",
     @"g1iWTkpFzeqThK8U3dJqYg-RtB-iJPnpniEnA_yvY-UPeauNuexwZLtOxH-L0vKxB0DyA-onVGQLyuwJq6V6CA.webp"];
    
    NSMutableArray *list = [NSMutableArray array];
    [dpPicList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *pic = [@"https://qcloud.dpfile.com/pc/" stringByAppendingString:obj];
        [list addObject:pic];
    }];
    [bannerView configList:list];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%@行", @(indexPath.row+1).stringValue];
    return cell;
}

#pragma mark - JABannerDelegate

- (void)bannerView:(JABannerView *)bannerView didHorizontalScrollAtIndex:(NSInteger)index preIndex:(NSInteger)preIndex precent:(CGFloat)precent {
    CGFloat target_H = [bannerView.imageHeightArray[index] floatValue];
    CGFloat banner_H = [bannerView.imageHeightArray[preIndex] floatValue];

    if (target_H > banner_H) {
        bannerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), banner_H+(target_H-banner_H)*precent);
    } else if (target_H < banner_H) {
        bannerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), banner_H-(banner_H-target_H)*precent);
    } else {
        bannerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), banner_H*precent);
    }
    self.tableView.tableHeaderView = bannerView;
}

@end
