#import "SettingsCell.h"


@implementation SettingsCell

@synthesize textField;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	
		self.textLabel.font = [UIFont systemFontOfSize:17.0];
	
		textField = [[UITextField alloc] init];
		textField.textColor = [UIColor colorWithRed:25.0/255.0 green:50.0/255.0 blue:114/255.0 alpha:1.0];
		[self.contentView addSubview:textField];
		
		self.textWidth = 120;
		
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
			action:@selector(tapGesture_Activated)];
		[self addGestureRecognizer:tapGesture];
	}
	return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	CGRect rect = self.contentView.frame;
	
	self.textLabel.frame = CGRectMake(10, 0, self.textWidth, rect.size.height);
	self.textField.frame = CGRectMake(self.textWidth+10, 11, rect.size.width-self.textWidth-20,	20);
}

- (void) tapGesture_Activated
{
	[self.textField becomeFirstResponder];
}

@end
