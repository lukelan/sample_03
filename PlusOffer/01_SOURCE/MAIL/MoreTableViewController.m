#import "MoreTableViewController.h"
#import "UIViewSizeShortcuts.h"


@implementation MoreTableViewController

@synthesize topInset;

- (void) viewDidLoad
{
	[super viewDidLoad];

	header = [[TableHeaderDragRefreshView alloc] initWithFrame:
		CGRectMake(0, -self.tableView.bounds.size.height, self.tableView.bounds.size.width,
		self.tableView.bounds.size.height)];
	[header setStatus:TTTableHeaderDragRefreshPullToReload];
	[self.tableView addSubview:header];

	footer = [[TableFooterDragRefreshView alloc] initWithFrame:
		CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
	[footer setStatus:TTTableFooterDragRefreshPullToLoadMore];	
	[self.tableView addSubview:footer];
}

- (void) dealloc
{
	[header release];
	[footer release];
	[super dealloc];
}

- (void) startUpdate
{
	isLoading = true;

	[header setStatus:TTTableHeaderDragRefreshLoading];

	// Leave header on screen
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationDuration:0.2];
	self.tableView.contentInset = UIEdgeInsetsMake(kHeaderInset, 0, 0, 0);
	[UIView commitAnimations];
}

- (bool) canLoadMore
{
	return true;
}

- (void) animateOnLoadMore
{
	[footer setStatus:TTTableFooterDragRefreshLoading];

	// Leave footer on screen
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationDuration:0.2];
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 
		MAX(self.tableView.height - self.tableView.contentSize.height, 0) + kFooterInset, 0);
	[UIView commitAnimations];
}

- (void) adjustFooterPosition
{
	footer.frame = CGRectMake(0, MAX(self.tableView.height, self.tableView.contentSize.height), 
		footer.width, footer.height);
}

- (void) animateOnFinishLoad
{
	footer.hidden = ![self canLoadMore];

	[header setStatus:TTTableHeaderDragRefreshPullToReload];
	[footer setStatus:TTTableFooterDragRefreshPullToLoadMore];
	[self adjustFooterPosition];

	// Remove header and footer from screen
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
	[UIView commitAnimations];
}

- (void) startLoadMore
{
	isLoading = true;
}

- (void) finishLoad
{
	isLoading = false;

	[self.tableView reloadData];
	[self animateOnFinishLoad];
}	

- (void) setLastUpdate:(NSDate *)date
{
	[header setUpdateDate:date];
}


// UIScrollView

- (void)scrollViewDidScroll:(UIScrollView*)scrollView 
{
  if (scrollView.dragging && !isLoading) 
	{
		if (scrollView.contentOffset.y > kHeaderDeltaY && scrollView.contentOffset.y < 0.0f) 
		{
			[header setStatus:TTTableHeaderDragRefreshPullToReload];
		}
		else if (scrollView.contentOffset.y < kHeaderDeltaY) 
		{
			[header setStatus:TTTableHeaderDragRefreshReleaseToReload];
		}
  }

  if (scrollView.dragging && !isLoading && [self canLoadMore]) 
	{
		float lastScreenTop = MAX(0, scrollView.contentSize.height - scrollView.height);
		if (scrollView.contentOffset.y >= lastScreenTop 
			&& scrollView.contentOffset.y < lastScreenTop + kFooterDeltaY)
		{
			[footer setStatus:TTTableFooterDragRefreshPullToLoadMore];
		}
		else if (scrollView.contentOffset.y >= lastScreenTop + kFooterDeltaY) 
		{
			[footer setStatus:TTTableFooterDragRefreshReleaseToLoadMore];
		}
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate 
{
	if (!isLoading)
	{
		if (scrollView.contentOffset.y <= kHeaderDeltaY) 
		{
			[self startUpdate];
		}
	}

	if (!isLoading && [self canLoadMore])
	{
		float lastScreenTop = MAX(0, scrollView.contentSize.height - scrollView.height);
		if (scrollView.contentOffset.y >= lastScreenTop + kFooterDeltaY) 
		{
			[self animateOnLoadMore];
			[self startLoadMore];
		}
	}
}

@end
