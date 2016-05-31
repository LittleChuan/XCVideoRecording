//
//  VideoView.h
//  gogomagic
//
//  Created by Chuan on 5/31/16.
//  Copyright © 2016 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#

@interface VideoView : UIView

@property (nonnull, nonatomic, strong) NSURL *videoURL;
@property (nonnull, nonatomic, strong) UIImage *coverImage;

@end
