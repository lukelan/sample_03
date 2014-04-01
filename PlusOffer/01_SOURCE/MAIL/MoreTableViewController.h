#import <Foundation/Foundation.h>
#import "TableFooterDragRefreshView.h"
#import "TableHeaderDragRefreshView.h"


@interface MoreTableViewController : UITableViewController
{
	bool isLoading;
	TableHeaderDragRefreshView *header;
	TableFooterDragRefreshView *footer;
}

@property (nonatomic, assign) float topInset;

- (void) startUpdate;
- (void) startLoadMore;
- (void) finishLoad;
- (void) setLastUpdate:(NSDate *)date;
- (void) animateOnFinishLoad;
- (void) adjustFooterPosition;

@end

