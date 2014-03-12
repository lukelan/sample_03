//
//  SDImageView.m
//  123Phim
//
//  Created by phuonnm on 7/18/13.
//  Copyright (c) 2013 Phuong. Nguyen Minh. All rights reserved.
//

#import "SDImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SDImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url completed:nil];
}

- (void)setImageWithURL:(NSURL *)url needResize:(BOOL)isNeedResize
{
    [self setImageWithURL:url completed:nil needResized:YES];
}

-(void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock needResized:(BOOL)isNeedResize
{
    _curURL = url;
    NSString *cacheKey = [SDWebImageManager sharedManager].cacheKeyFilter(url);
    if (self.cacheKey && [cacheKey isEqualToString:self.cacheKey])
    {
        return;
    }
    [self cancelCurrentImageLoad];
    if (self.cacheKey)
    {
        [[SDWebImageManager sharedManager].imageCache removeImageForKey:self.cacheKey fromDisk:NO];
    }
    [self setCacheKey:cacheKey];
    __block void (^returnBlock)() = ^void(UIImage *image, NSError *error, SDImageCacheType cacheType)
    {
        [self setCacheKey:@""];
        if (completedBlock)
        {
            completedBlock(image, error, cacheType);
        }
        if (isNeedResize)
        {
            CGRect frame = self.frame;
            frame.size.width = image.size.width/2;
            frame.size.height = image.size.height/2;
            [self setFrame:frame];
            self.isResized = YES;
        }
    };
    [super setImageWithURL:url completed:returnBlock];
}

-(void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url completed:completedBlock needResized:NO];
}

-(void)dealloc
{
    [self cancelCurrentImageLoad];
    if (self.cacheKey)
    {
        [[SDWebImageManager sharedManager].imageCache removeImageForKey:self.cacheKey fromDisk:NO];
    }
}

@end
