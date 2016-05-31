//
//  VideoView.m
//  gogomagic
//
//  Created by Chuan on 5/31/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import "VideoView.h"

#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>

@interface VideoView ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation VideoView

@synthesize player = _player;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - AVPlayer
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)newplayer
{
    [(AVPlayerLayer*)[self layer] setPlayer:newplayer];
}

- (void)setVideoFillMode:(NSString *)fillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
    playerLayer.videoGravity = fillMode;
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    self.playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
    
    self.playButton.hidden = NO;
}

- (void)play {
    [self.player play];
    self.playButton.hidden = YES;
    self.coverImageView.hidden = YES;
}

- (void) videoNotification:(NSNotification*) notification
{
    NSString* notificationName = [notification name];
    if ([notificationName isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]) {
        [self.playerItem seekToTime:kCMTimeZero];
        self.playButton.hidden = NO;
        self.coverImageView.hidden = NO;
    }
}

#pragma mark - player cover
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton new];
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        _playButton.layer.cornerRadius = 25.f;
        _playButton.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        [self.coverImageView addSubview:_playButton];
        
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.coverImageView);
        }];
    }
    return _playButton;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_coverImageView];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self);
        }];
    }
    return _coverImageView;
}

- (void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    self.coverImageView.image = _coverImage;
}

@end
