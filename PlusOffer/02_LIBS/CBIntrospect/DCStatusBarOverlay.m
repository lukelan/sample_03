//
//  DCStatusBarOverlay.m
//
//  Copyright 2011 Domestic Cat. All rights reserved.
//

#import "DCStatusBarOverlay.h"
#import "CBMacros.h"

@implementation DCStatusBarOverlay
@synthesize leftLabel, rightLabel;

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];

#if ! CB_HAS_ARC
	[leftLabel release];
	[rightLabel release];

	[super dealloc];
#endif
}

#pragma mark Setup

- (id)init
{
    if ((self = [super initWithFrame:CGRectZero]))
	{
		self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        UIFont *statusBarFont = [UIFont systemFontOfSize:12];
		UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
		CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
		CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
		CGFloat barHeight = statusBarFont.lineHeight + 2;
		if (UIInterfaceOrientationIsLandscape(orientation))
			self.frame = CGRectMake(0, 0, screenHeight, barHeight);
		else
			self.frame = CGRectMake(0, 0, screenWidth, barHeight);
		self.backgroundColor = [UIColor blackColor];

		self.leftLabel = CB_AutoRelease([[UILabel alloc] initWithFrame:CGRectOffset(self.frame, 2.0f, 0.0f)])
		self.leftLabel.backgroundColor = [UIColor clearColor];
		self.leftLabel.textAlignment = NSTextAlignmentLeft;
		self.leftLabel.font = statusBarFont;
		self.leftLabel.textColor = [UIColor colorWithWhite:0.97f alpha:1.0f];
		self.leftLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self addSubview:self.leftLabel];

		self.rightLabel = CB_AutoRelease([[UILabel alloc] initWithFrame:CGRectOffset(self.frame, -2.0f, 0.0f)]);
		self.rightLabel.backgroundColor = self.leftLabel.backgroundColor;
		self.rightLabel.font = statusBarFont;
		self.rightLabel.textAlignment = NSTextAlignmentRight;
		self.rightLabel.textColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		self.rightLabel.autoresizingMask = self.leftLabel.autoresizingMask;
		[self addSubview:self.rightLabel];

		UITapGestureRecognizer *gestureRecognizer = CB_AutoRelease([[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)])
		[self addGestureRecognizer:gestureRecognizer];

		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBarFrame) name:UIDeviceOrientationDidChangeNotification object:nil];
	}

	return self;
}

- (void)updateBarFrame
{
	// current interface orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

	CGFloat pi = (CGFloat)M_PI;
	if (orientation == UIDeviceOrientationPortrait)
	{
		self.transform = CGAffineTransformIdentity;
		self.frame = CGRectMake(0, 0, screenWidth, self.frame.size.height);
	}
	else if (orientation == UIDeviceOrientationLandscapeLeft)
	{
		self.transform = CGAffineTransformMakeRotation(pi * (90) / 180.0f);
		self.frame = CGRectMake(screenWidth - self.frame.size.width, 0, self.frame.size.width, screenHeight);
	}
	else if (orientation == UIDeviceOrientationLandscapeRight)
	{
		self.transform = CGAffineTransformMakeRotation(pi * (-90) / 180.0f);
		self.frame = CGRectMake(0, 0, self.frame.size.width, screenHeight);
	}
	else if (orientation == UIDeviceOrientationPortraitUpsideDown)
	{
		self.transform = CGAffineTransformMakeRotation(pi);
		self.frame = CGRectMake(0, screenHeight - self.frame.size.height, screenWidth, self.frame.size.height);
	}
}

#pragma mark Actions

- (void)tapped
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kDCIntrospectNotificationStatusBarTapped object:nil];
}

@end
