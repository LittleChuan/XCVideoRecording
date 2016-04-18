//
//  EditController.m
//  gogomagic
//
//  Created by Chuan on 4/18/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import "EditController.h"

#import <ZFPlayer/ZFPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface EditController ()

@property (weak, nonatomic) IBOutlet ZFPlayerView *zf_player;

@property (strong, nonatomic) AVAsset *asset;

@property (strong, nonatomic) UIView *trimView;

@property (strong, nonatomic) UIView *timeBarView;

@end

@implementation EditController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.zf_player.videoURL = movieURL;
    self.zf_player.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
    
    self.timeBarView.backgroundColor = [UIColor clearColor];
    
    self.asset = [AVAsset assetWithURL:movieURL];
    NSLog(@"%lld", self.asset.duration.value / self.asset.duration.timescale);
}

- (UIView *)trimView {
    if (!_trimView) {
        _trimView = [UIView new];
        _trimView.backgroundColor = [UIColor yellowColor];
        
        [self.zf_player addSubview:_trimView];
        
        [_trimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.zf_player.mas_leading);
            make.trailing.equalTo(self.zf_player.mas_trailing);
            make.bottom.equalTo(self.zf_player.mas_bottom);
            make.height.equalTo(@30);
        }];
        // start view
        
        // end view
        
        // time bar
        
        // commit button
        
        // reset button
        
    }
    return _trimView;
}

- (UIView *)timeBarView {
    if (!_timeBarView) {
        _timeBarView = [UIView new];
        
        [self.trimView addSubview:_timeBarView];
        
        [_timeBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.trimView).with.insets(UIEdgeInsetsMake(0, 30, 0, 30));
        }];
        
        // line
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor redColor];
        [_timeBarView addSubview:lineView];
        
        
    }
    return _timeBarView;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
