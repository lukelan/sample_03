#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kHeaderDeltaY  -65.0
#define kHeaderInset    60.0


typedef enum {
  TTTableHeaderDragRefreshReleaseToReload,
  TTTableHeaderDragRefreshPullToReload,
  TTTableHeaderDragRefreshLoading,
  TTTableHeaderDragRefreshWait
} TTTableHeaderDragRefreshStatus;

@interface TableHeaderDragRefreshView : UIView 
{
  NSDate*                   _lastUpdatedDate;
  UILabel*                  _lastUpdatedLabel;
  UILabel*                  _statusLabel;
  //UIImageView*              _arrowImage;
  UIActivityIndicatorView*  _activityView;
}

- (void)setCurrentDate;
- (void)setUpdateDate:(NSDate*)date;
- (void)setStatus:(TTTableHeaderDragRefreshStatus)status;

@end
