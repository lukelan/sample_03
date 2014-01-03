//
//  OfferAnnotationView.m
//  PlusOffer
//
//  Created by Tai Truong on 1/2/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "OfferAnnotationView.h"
#import "JPSThumbnailAnnotationView.h"
#import "OfferTableItem.h"

#define OfferAnnotationView_Width 145.0f
#define OfferAnnotationView_Height 100.0f


@implementation OfferAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, OfferAnnotationView_Width, OfferAnnotationView_Height);
        self.backgroundColor = [UIColor clearColor];
        
        // Image View
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, OfferAnnotationView_Width - 10, OfferAnnotationView_Height - 10)];
        _imageView.layer.cornerRadius = 4.0;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
        
        // Name Label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, OfferAnnotationView_Width - 10, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        _titleLabel.shadowOffset = CGSizeMake(0, -1);
        _titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.minimumScaleFactor = .8f;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        // Distance Label
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 75, OfferAnnotationView_Width - 10, 20)];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        _subtitleLabel.shadowOffset = CGSizeMake(0, -1);
        _subtitleLabel.font = [UIFont systemFontOfSize:9.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subtitleLabel];
    }
    return self;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    OfferTableItem *item = annotation;
    self.titleLabel.text = item.title;
    self.subtitleLabel.text = item.subtitle;
    [self.imageView setImage:[UIImage imageNamed:@"img-loc-mcdonalds.jpg"]];
}

- (void)setLayerProperties {
    _shapeLayer = [ShadowShapeLayer layer];
    CGPathRef shapeLayerPath = [self newBubbleWithRect:self.bounds andOffset:CGSizeMake(200.0f/2, 0)];
    _shapeLayer.path = shapeLayerPath;
    CGPathRelease(shapeLayerPath);
    
    // Fill Callout Bubble & Add Shadow
    _shapeLayer.fillColor = [[UIColor blackColor] CGColor];
    
    _strokeAndShadowLayer = [CAShapeLayer layer];
    
    CGPathRef _strokeAndShadowLayerPath = [self newBubbleWithRect:self.bounds];
    _strokeAndShadowLayer.path = _strokeAndShadowLayerPath;
    CGPathRelease(_strokeAndShadowLayerPath);
    
    _strokeAndShadowLayer.fillColor = [UIColor clearColor].CGColor;
    
    if (0) {
        _strokeAndShadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _strokeAndShadowLayer.shadowOffset = CGSizeMake (0, [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2 ? 3 : -3);
        _strokeAndShadowLayer.shadowRadius = 5.0;
        _strokeAndShadowLayer.shadowOpacity = 1.0;
    }
    
    _strokeAndShadowLayer.strokeColor = [UIColor colorWithWhite:0.22 alpha:1.0].CGColor;
    _strokeAndShadowLayer.lineWidth = 1.0;
    
    CAGradientLayer *bubbleGradient = [CAGradientLayer layer];
    bubbleGradient.frame = CGRectMake(self.bounds.origin.x-100, self.bounds.origin.y, 200+self.bounds.size.width, self.bounds.size.height-7);
    bubbleGradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:.75].CGColor, (id)[UIColor colorWithWhite:0 alpha:.75].CGColor,(id)[UIColor colorWithWhite:0.13 alpha:.75].CGColor,(id)[UIColor colorWithWhite:0.33 alpha:.75].CGColor, nil];
    bubbleGradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.53],[NSNumber numberWithFloat:.54],[NSNumber numberWithFloat:1], nil];
    bubbleGradient.startPoint = CGPointMake(0.0f, 1.0f);
    bubbleGradient.endPoint = CGPointMake(0.0f, 0.0f);
    bubbleGradient.mask = _shapeLayer;
    
    _shapeLayer.masksToBounds = NO;
    bubbleGradient.masksToBounds = NO;
    _strokeAndShadowLayer.masksToBounds = NO;
    
    [_strokeAndShadowLayer addSublayer:bubbleGradient];
    [self.layer insertSublayer:_strokeAndShadowLayer atIndex:0];
}

- (CGPathRef)newBubbleWithRect:(CGRect)rect {
    CGFloat stroke = 1.0;
	CGFloat radius = 7.0;
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat parentX = rect.origin.x + rect.size.width/2;
	
	//Determine Size
	rect.size.width -= stroke + 14;
	rect.size.height -= stroke + 29;
	rect.origin.x += stroke / 2.0 + 7;
	rect.origin.y += stroke / 2.0 + 7;
    
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 14, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 14);
	CGPathAddLineToPoint(path, NULL, parentX + 14, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1);
	CGPathCloseSubpath(path);
    return path;
}

- (CGPathRef)newBubbleWithRect:(CGRect)rect andOffset:(CGSize)offset {
    CGRect offsetRect = CGRectMake(rect.origin.x+offset.width, rect.origin.y+offset.height, rect.size.width, rect.size.height);
    return [self newBubbleWithRect:offsetRect];
}

@end
