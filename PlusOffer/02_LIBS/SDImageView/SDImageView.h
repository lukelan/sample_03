//
//  SDImageView.h
//  123Phim
//
//  Created by phuonnm on 7/18/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/SDWebImageManager.h>

@interface SDImageView : UIImageView

@property (nonatomic, assign) BOOL isResized;
@property (nonatomic, copy) NSString *cacheKey;
@property (nonatomic, copy) NSURL *curURL;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url needResize:(BOOL)isNeedResize;
- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock;

@end
