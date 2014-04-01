#import "CheckboxCell.h"
#import "UIViewSizeShortcuts.h"

@implementation CheckboxCell

@synthesize checkbox;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	
		self.textLabel.font = [UIFont systemFontOfSize:17.0];
	
		checkbox = [[UISwitch alloc] init];
		[self.contentView addSubview:checkbox];
		
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
			action:@selector(tapGesture_Activated)];
		[self addGestureRecognizer:tapGesture];
	
	}
	return self;
}

- (void) dealloc
{
	[checkbox release];
	[super dealloc];
}

- (void)layoutSubviews 
{
	[super layoutSubviews];
	CGRect rect = self.contentView.frame;

	self.checkbox.left = rect.size.width - self.checkbox.width - 10;
	self.checkbox.top = (rect.size.height - self.checkbox.height) / 2;
	
	[self.textLabel setFrame:CGRectMake(10, 0, rect.size.width - self.checkbox.width - 20,
		rect.size.height)];
}

- (void) tapGesture_Activated
{
	[self.checkbox setOn:!self.checkbox.on animated:true];
}

@end
