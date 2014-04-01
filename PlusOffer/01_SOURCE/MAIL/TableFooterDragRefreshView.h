#import <Foundation/Foundation.h>

#define kFooterDeltaY 50.0
#define kFooterInset  45.0


typedef enum {
  TTTableFooterDragRefreshPullToLoadMore,
  TTTableFooterDragRefreshReleaseToLoadMore,
  TTTableFooterDragRefreshLoading,
  TTTableFooterDragRefreshWait
} TTTableFooterDragRefreshStatus;


@interface TableFooterDragRefreshView : UIView 
{
  UILabel*                  _statusLabel;
  UIImageView*              _arrowImage;
  UIActivityIndicatorView*  _activityView;
}

- (void)setStatus:(TTTableFooterDragRefreshStatus)status;

@end
