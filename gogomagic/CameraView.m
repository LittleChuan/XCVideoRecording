//
//  CameraView.m
//  gogomagic
//
//  Created by Chuan on 5/20/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import "CameraView.h"

#import <GPUImage/GPUImage.h>
#import <Masonry/Masonry.h>

@interface CameraView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray *viewArray;
@property (nonatomic, assign) BOOL isSpread;

@end

@implementation CameraView

- (void)setFilterArray:(NSArray<GPUImageFilter *> *)filterArray {
    if (filterArray.count < 9 || _filterArray != nil)
        return;
    _filterArray = filterArray;
    
    for (int i = 0; i < 9; i++) {
        GPUImageView *imageView = [GPUImageView new];
        imageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        imageView.tag = i;
        [self.containerView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self);
            make.leading.equalTo(self.containerView).with.mas_equalTo(self.frame.size.width * (i % 3));
            make.top.equalTo(self.containerView).with.mas_equalTo(self.frame.size.height * (i / 3));
        }];
        
        [_filterArray[i] addTarget:imageView];
    }
    
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        [self addSubview:_containerView];
        
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self).with.multipliedBy(3.f);
            make.center.equalTo(self);
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedFilter:)];
        [_containerView addGestureRecognizer:tapGesture];
    }
    return _containerView;
}

- (void)tappedFilter:(UITapGestureRecognizer *)tap {
    if (!self.isSpread)
        return;
    
    if (tap.state == UIGestureRecognizerStateRecognized) {
        for (UIView *view in self.containerView.subviews) {
            if (CGRectContainsPoint(view.frame, [tap locationInView:self.containerView])) {
                self.filter = self.filterArray[view.tag];
                [self fold];
            }
        }
    }
}

- (void)spread {
    self.isSpread = YES;
    [UIView animateWithDuration:0.4 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1 / 3.f, 1 / 3.f);
    } completion:^(BOOL finished) {
        self.layer.anchorPoint               = CGPointMake(.5, .5);
        self.containerView.layer.anchorPoint = CGPointMake(.5, .5);
    }];
}

- (void)fold {
    self.isSpread = NO;
    
    NSInteger currentSelected            = [self.filterArray indexOfObject:self.filter];
    self.layer.anchorPoint               = CGPointMake(1 - (currentSelected % 3) / 2.f, 1 - (currentSelected / 3) / 2.f);
    self.containerView.layer.anchorPoint = CGPointMake((currentSelected % 3) / 2.f, (currentSelected / 3) / 2.f);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    }];
}

@end
