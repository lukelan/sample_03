#import "TableFooterDragRefreshView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewSizeShortcuts.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define kTableRefreshHeaderLastUpdatedFont [UIFont systemFontOfSize:12.0f]
#define kTableRefreshHeaderStatusFont [UIFont boldSystemFontOfSize:13.0f]
#define kTableRefreshHeaderBackgroundColor RGBCOLOR(226, 231, 237)
#define kTableRefreshHeaderTextColor RGBCOLOR(87, 108, 137)
#define kTableRefreshHeaderTextShadowColor [UIColor colorWithWhite:0.9 alpha:1]
#define kTableRefreshHeaderTextShadowOffset CGSizeMake(0.0f, 1.0f)


#define kImagePosVisible CGRectMake(19, 0, 60/2, 62/2)
#define kImagePosHidden  CGRectMake(19, 0 - 62/2, 60/2, 62/2)

@implementation TableFooterDragRefreshView

- (id) initWithFrame:(CGRect)aFrame
{
	if (self = [super initWithFrame:aFrame])
	{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = kTableRefreshHeaderBackgroundColor;
		self.clipsToBounds = true;

    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, self.width, 20)];
    _statusLabel.autoresizingMask =
      UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    _statusLabel.font             = kTableRefreshHeaderStatusFont;
    _statusLabel.textColor        = kTableRefreshHeaderTextColor;
    _statusLabel.shadowColor      = kTableRefreshHeaderTextShadowColor;
    _statusLabel.shadowOffset     = kTableRefreshHeaderTextShadowOffset;
    _statusLabel.backgroundColor  = [UIColor clearColor];
    _statusLabel.textAlignment    = NSTextAlignmentCenter;
    [self setStatus:TTTableFooterDragRefreshPullToLoadMore];
    [self addSubview:_statusLabel];

    _arrowImage = [[UIImageView alloc] initWithFrame:kImagePosHidden];
    _arrowImage.contentMode       = UIViewContentModeScaleAspectFit;
    _arrowImage.image             = [UIImage imageNamed:@"LoadingMoreBottom_PopUpBird"];
    [self addSubview:_arrowImage];

    _activityView = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = CGRectMake( 30, 12, 20, 20 );
    _activityView.hidesWhenStopped  = YES;
    [self addSubview:_activityView];
	}
	return self;
}

- (void)dealloc 
{
  [_activityView release];
  [_statusLabel release];
  [_arrowImage release];
  [super dealloc];
}

- (void)showActivity:(BOOL)shouldShow animated:(BOOL)animated 
{
  if (shouldShow) 
    [_activityView startAnimating];
  else 
    [_activityView stopAnimating];

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:(animated ? 0.2 : 0.0)];
  _arrowImage.alpha = (shouldShow ? 0.0 : 1.0);
  [UIView commitAnimations];
}

- (void)setImageActive:(BOOL)active 
{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.2];
  _arrowImage.frame = (active ? kImagePosVisible :	kImagePosHidden);
	[UIView commitAnimations];
}

- (void)setStatus:(TTTableFooterDragRefreshStatus)status
{
  switch (status) 
	{
    case TTTableFooterDragRefreshReleaseToLoadMore: 
		{
      [self showActivity:NO animated:NO];
      [self setImageActive:YES];
      _statusLabel.text = @"Release to load more...";
      break;
    }
    case TTTableFooterDragRefreshPullToLoadMore: 
		{
      [self showActivity:NO animated:NO];
      [self setImageActive:NO];
      _statusLabel.text = @"Pull up to load more...";
      break;
    }
    case TTTableFooterDragRefreshLoading: 
		{
      [self showActivity:YES animated:YES];
      [self setImageActive:NO];
      _statusLabel.text = @"Loading...";
      break;
    }
    case TTTableFooterDragRefreshWait: 
		{
      [self showActivity:NO animated:NO];
      [self setImageActive:NO];
      _statusLabel.text = @"";
      break;
    }
  }
}

@end
