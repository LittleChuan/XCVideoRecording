//
//  ProgressView.h
//  gogomagic
//
//  Created by Chuan on 5/31/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressViewDelegate <NSObject>

@optional
- (void)progressViewDidEndProgressing;

@end

@interface ProgressView : UIView

@property (nullable, nonatomic, weak) id<ProgressViewDelegate> delegate;
@property (nonatomic, assign) float maximumLimit;
@property (nonatomic, assign) float progress;

- (void)beginProgress;
- (void)endProgress;

#pragma mark - appearance
@property (nonnull, nonatomic, strong) UIColor *progressBarColor;

@end
