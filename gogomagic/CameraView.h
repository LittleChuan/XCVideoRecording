//
//  CameraView.h
//  gogomagic
//
//  Created by Chuan on 5/20/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPUImageFilter;

@interface CameraView : UIView

@property (nonatomic, strong) NSArray<GPUImageFilter *> *filterArray;

@property (nonatomic, strong) GPUImageFilter *filter;

- (void)spread;
- (void)fold;

@end
