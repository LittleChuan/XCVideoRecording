//
//  ViewController.m
//  gogomagic
//
//  Created by Chuan on 4/14/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import "ViewController.h"

#import "CameraView.h"

#import <GPUImage/GPUImage.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CameraView *imageView;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageFilter *filter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic, strong) NSArray<GPUImageFilter *> *filterArray;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
}

- (void)viewWillAppear:(BOOL)animated {
    [self resetCamera];
    self.filter = self.filterArray[4];
    self.imageView.filterArray = self.filterArray;
}

- (NSArray<GPUImageFilter *> *)filterArray {
    if (!_filterArray) {
        _filterArray = @[[GPUImageSepiaFilter new],
                         [GPUImageSketchFilter new],
                         [GPUImageSoftEleganceFilter new],
                         [GPUImageMonochromeFilter new],
                         [GPUImageVignetteFilter new],
                         [GPUImageAmatorkaFilter new],
                         [GPUImageSaturationFilter new],
                         [GPUImageHueFilter new],
                         [GPUImageMissEtikateFilter new],
                         ];
        
        [(GPUImageMonochromeFilter *)_filterArray[3] setColor:(GPUVector4){1.0f, 0.0f, 0.0f, 1.f}];
        [(GPUImageMonochromeFilter *)_filterArray[3] setIntensity:0.3];
        
        [(GPUImageSaturationFilter *)_filterArray[6] setSaturation:2.f];
        
        [(GPUImageHueFilter *)_filterArray[7] setHue:230];
        
        for (GPUImageFilter *filter in _filterArray) {
            [self.videoCamera addTarget:filter];
        }
    }
    return _filterArray;
}

- (void)setFilter:(GPUImageFilter *)filter {
    [_filter removeTarget:self.movieWriter];
    
    _filter = filter;
    
    [_filter addTarget:self.movieWriter];
}

- (void)resetCamera {
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    [self.videoCamera.inputCamera lockForConfiguration:nil];
    if ([self.videoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        self.videoCamera.inputCamera.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    }
    [self.videoCamera.inputCamera unlockForConfiguration];
    
    //    self.filter = [[GPUImageSepiaFilter alloc] init];
    
    //    filter = [[GPUImageTiltShiftFilter alloc] init];
    //    [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:0.65];
    //    [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:0.85];
    //    [(GPUImageTiltShiftFilter *)filter setBlurSize:1.5];
    //    [(GPUImageTiltShiftFilter *)filter setFocusFallOffRate:0.2];
    
    //    filter = [[GPUImageSketchFilter alloc] init];
    //    filter = [[GPUImageColorInvertFilter alloc] init];
    //    filter = [[GPUImageSmoothToonFilter alloc] init];
    //    GPUImageRotationFilter *rotationFilter = [[GPUImageRotationFilter alloc] initWithRotation:kGPUImageRotateRightFlipVertical];
    
//    [self.videoCamera addTarget:self.filter];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
    self.movieWriter.encodingLiveVideo = YES;
    //    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    //    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
    //    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1080.0, 1920.0)];
    //    [self.filter addTarget:self.imageView];
    
    [self.videoCamera startCameraCapture];
}

- (IBAction)start:(id)sender {
    [self.videoCamera.inputCamera lockForConfiguration:nil];
//    if ([self.videoCamera.inputCamera isFlashModeSupported:AVCaptureFlashModeOn]) {
//        self.videoCamera.inputCamera.flashMode = AVCaptureFlashModeOn;
//    }
//    if ([self.videoCamera.inputCamera isTorchModeSupported:AVCaptureTorchModeOn]) {
//        self.videoCamera.inputCamera.torchMode = AVCaptureTorchModeOn;
//    }
    [self.videoCamera.inputCamera unlockForConfiguration];
    
    [self.movieWriter startRecording];
    NSLog(@"start recording");
}

- (IBAction)stop:(id)sender {
    [self.videoCamera.inputCamera lockForConfiguration:nil];
//    if ([self.videoCamera.inputCamera isFlashModeSupported:AVCaptureFlashModeOff]) {
//        self.videoCamera.inputCamera.flashMode = AVCaptureFlashModeOff;
//    }
//    if ([self.videoCamera.inputCamera isTorchModeSupported:AVCaptureTorchModeOff]) {
//        self.videoCamera.inputCamera.torchMode = AVCaptureTorchModeOff;
//    }
    [self.videoCamera.inputCamera unlockForConfiguration];
    
    [self.movieWriter finishRecording];
    NSLog(@"finish recording");
    
    [self performSegueWithIdentifier:@"Edit" sender:self];
}

- (IBAction)delete:(id)sender {
//    [self resetCamera];
}

- (IBAction)showFilters:(id)sender {
    [self.imageView spread];
}

@end
