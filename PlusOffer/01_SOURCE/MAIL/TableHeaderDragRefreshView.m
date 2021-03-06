#import "TableHeaderDragRefreshView.h"
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


#define kImagePosVisible CGRectMake(19, self.frame.size.height - 62/2, 60/2, 62/2)
#define kImagePosHidden  CGRectMake(19, self.frame.size.height, 60/2, 62/2)


@implementation TableHeaderDragRefreshView


- (id)initWithFrame:(CGRect)frame 
{
  if(self = [super initWithFrame:frame]) 
	{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = kTableRefreshHeaderBackgroundColor;
		self.clipsToBounds = true;

    _lastUpdatedLabel = [[UILabel alloc]
                         initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f,
                                                  frame.size.width, 20.0f)];
    _lastUpdatedLabel.autoresizingMask =
      UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    _lastUpdatedLabel.font            = kTableRefreshHeaderLastUpdatedFont;
    _lastUpdatedLabel.textColor       = kTableRefreshHeaderTextColor;
    _lastUpdatedLabel.shadowColor     = kTableRefreshHeaderTextShadowColor;
    _lastUpdatedLabel.shadowOffset    = kTableRefreshHeaderTextShadowOffset;
    _lastUpdatedLabel.backgroundColor = [UIColor clearColor];
    _lastUpdatedLabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:_lastUpdatedLabel];

    _statusLabel = [[UILabel alloc]
                    initWithFrame:CGRectMake(0.0f, frame.size.height - 39,
                                             frame.size.width, 20.0f )];
    _statusLabel.autoresizingMask =
      UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    _statusLabel.font             = kTableRefreshHeaderStatusFont;
    _statusLabel.textColor        = kTableRefreshHeaderTextColor;
    _statusLabel.shadowColor      = kTableRefreshHeaderTextShadowColor;
    _statusLabel.shadowOffset     = kTableRefreshHeaderTextShadowOffset;
    _statusLabel.backgroundColor  = [UIColor clearColor];
    _statusLabel.textAlignment    = NSTextAlignmentCenter;
    [self setStatus:TTTableHeaderDragRefreshPullToReload];
    [self addSubview:_statusLabel];

    //_arrowImage = [[UIImageView alloc] initWithFrame:kImagePosHidden];
    //_arrowImage.contentMode       = UIViewContentModeScaleAspectFit;
    //_arrowImage.image             = [UIImage imageNamed:@"LoadingMoreTop_PopUpBird"];
    //[self addSubview:_arrowImage];

    _activityView = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = CGRectMake( 30.0f, frame.size.height - 38.0f, 20.0f, 20.0f );;
    _activityView.hidesWhenStopped  = YES;
    [self addSubview:_activityView];
  }
  return self;
}

- (void)dealloc 
{
	[_lastUpdatedDate release];
  [_activityView release];
  [_statusLabel release];
  //[_arrowImage release];
  [_lastUpdatedLabel release];
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
  //_arrowImage.alpha = (shouldShow ? 0.0 : 1.0);
  [UIView commitAnimations];
}

- (void)setImageActive:(BOOL)active
{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.2];
  //_arrowImage.frame = (active ? kImagePosVisible : kImagePosHidden);
	[UIView commitAnimations];
}

- (void)setUpdateDate:(NSDate*)newDate 
{
	[_lastUpdatedDate release];
	_lastUpdatedDate = [newDate retain];

	_statusLabel.top = self.frame.size.height - 48.0f;

  if (_lastUpdatedDate != NULL) 
	{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    _lastUpdatedLabel.text = [NSString stringWithFormat:@"Last updated: %@",
                              [formatter stringFromDate:_lastUpdatedDate]];
    [formatter release];
  } 
	else 
	{
    _lastUpdatedLabel.text = @"Last updated: never";
  }
}

- (void)setCurrentDate 
{
  [self setUpdateDate:[NSDate date]];
}

- (void)setStatus:(TTTableHeaderDragRefreshStatus)status 
{
  switch (status) 
	{
    case TTTableHeaderDragRefreshReleaseToReload: 
		{
      [self showActivity:NO animated:NO];
      [self setImageActive:YES];
      _statusLabel.text = @"Release to update...";
      break;
    }
    case TTTableHeaderDragRefreshPullToReload: 
		{
      [self showActivity:NO animated:NO];
      [self setImageActive:NO];
      _statusLabel.text = @"Pull down to update...";
      break;
    }
    case TTTableHeaderDragRefreshLoading: 
		{
      [self showActivity:YES animated:YES];
      [self setImageActive:NO];
      _statusLabel.text = @"Updating...";
      break;
    }
    case TTTableHeaderDragRefreshWait: 
		{
      [self showActivity:NO animated:NO];
      [self setImageActive:NO];
      _statusLabel.text = @"";
      break;
    }
  }
}

@end
