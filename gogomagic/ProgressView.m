//
//  ProgressView.m
//  gogomagic
//
//  Created by Chuan on 5/31/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@property (nonatomic, strong) NSLayoutConstraint *progressBarWidthConstraint;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *progressBar;

@end

@implementation ProgressView

- (void)dealloc {
    [self endProgress];
}

- (UIView *)progressBar {
    if (!_progressBar) {
        _progressBar = [UIView new];
        _progressBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_progressBar];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];

        self.progressBarWidthConstraint = [NSLayoutConstraint constraintWithItem:_progressBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        [self addConstraint:self.progressBarWidthConstraint];
    }
    return _progressBar;
}

- (void)setProgressBarColor:(UIColor *)progressBarColor {
    _progressBarColor = progressBarColor;
    self.progressBar.backgroundColor = _progressBarColor;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    self.progressBarWidthConstraint.constant = self.frame.size.width * _progress / self.maximumLimit;
}

- (void)beginProgress {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressing) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)endProgress {
    [self.timer invalidate];
    self.timer = nil;
    self.progress = 0;
}

- (void)progressing {
    if (self.progress >= self.maximumLimit) {
        [self endProgress];
        if ([self.delegate respondsToSelector:@selector(progressViewDidEndProgressing)]) {
            [self.delegate progressViewDidEndProgressing];
        }
        return;
    }
    
    self.progress = self.progress + 0.02;
}

@end
