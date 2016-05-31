//
//  EditController.m
//  gogomagic
//
//  Created by Chuan on 4/18/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import "EditController.h"
#import "VideoView.h"

#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>

@interface EditController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet VideoView *zf_player;

@property (strong, nonatomic) AVAsset *asset;

@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;

@property (strong, nonatomic) UIView *trimView;

@property (strong, nonatomic) UIView *timeBarView;

@property (strong, nonatomic) UICollectionView *coverCollectionView;

@property (strong, nonatomic) NSArray *covers;

@end

@implementation EditController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.zf_player.videoURL = movieURL;
//    self.zf_player.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
    
    self.timeBarView.hidden = NO;
    
    self.asset = [AVAsset assetWithURL:movieURL];
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    
    float durationSeconds = CMTimeGetSeconds(self.asset.duration);
    
    CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
    CMTime secondThird = CMTimeMakeWithSeconds(durationSeconds*2.0/3.0, 600);
    CMTime end = CMTimeMakeWithSeconds(durationSeconds, 600);
    NSArray *times = @[[NSValue valueWithCMTime:kCMTimeZero],
                       [NSValue valueWithCMTime:firstThird],
                       [NSValue valueWithCMTime:secondThird],
                       [NSValue valueWithCMTime:end]];
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        self.covers = [[self.covers mutableCopy] arrayByAddingObject:[UIImage imageWithCGImage:image]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.coverCollectionView reloadData];
        });
    }];
}

#pragma mark - trim
- (UIView *)trimView {
    if (!_trimView) {
        _trimView = [UIView new];
        _trimView.backgroundColor = [UIColor yellowColor];
        
        [self.zf_player addSubview:_trimView];
        
        [_trimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.zf_player);
            make.trailing.equalTo(self.zf_player);
            make.top.equalTo(self.coverCollectionView.mas_bottom);
            make.height.equalTo(@100);
        }];
        // start view
        
        // end view
        
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
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_timeBarView);
            make.leading.equalTo(_timeBarView).with.mas_equalTo(10);
            make.trailing.equalTo(_timeBarView).with.mas_equalTo(-10);
            make.height.mas_equalTo(1);
        }];
    }
    return _timeBarView;
}

#pragma mark - get cover
- (UICollectionView *)coverCollectionView {
    if (!_coverCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing          = 0;
        layout.minimumInteritemSpacing     = 0;
        layout.itemSize                    = CGSizeMake(self.view.frame.size.width / 4, self.view.frame.size.width / 4);
        
        _coverCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _coverCollectionView.delegate = self;
        _coverCollectionView.dataSource = self;
        [_coverCollectionView registerClass:[CoverCell class] forCellWithReuseIdentifier:@"CoverCell"];
        [self.view addSubview:_coverCollectionView];
        
        [_coverCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.zf_player.mas_leading);
            make.trailing.equalTo(self.zf_player.mas_trailing);
            make.top.equalTo(self.zf_player.mas_bottom);
            make.height.mas_equalTo(self.view.frame.size.width / 4);
        }];
    }
    
    return _coverCollectionView;
}

- (NSArray *)covers {
    if (!_covers) {
        _covers = @[];
    }
    return _covers;
}

#pragma mark - close
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collection delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.covers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoverCell" forIndexPath:indexPath];
    cell.cover = self.covers[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.zf_player.coverImage = self.covers[indexPath.item];
}

@end

@interface CoverCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CoverCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _imageView;
}

- (void)setCover:(UIImage *)cover {
    self.imageView.image = cover;
}

@end
