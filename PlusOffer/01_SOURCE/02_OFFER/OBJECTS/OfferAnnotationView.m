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

#define OfferAnnotationViewNormal_Width 27.0f
#define OfferAnnotationViewNormal_Height 39.0f
#define OfferAnnotationViewExpanded_Width 142.0f
#define OfferAnnotationViewExpanded_Height 87.0f
#define OfferAnnotationViewImageHeight 59.0f

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
        self.frame = CGRectMake(0, 0, OfferAnnotationViewNormal_Width, OfferAnnotationViewNormal_Height);
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        
        // normal view
        _normalView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, OfferAnnotationViewNormal_Width, OfferAnnotationViewNormal_Height)];
        [self addSubview:_normalView];
        
        // expanded view
        _expandedView = [[UIView alloc] initWithFrame:CGRectMake((OfferAnnotationViewNormal_Width - OfferAnnotationViewExpanded_Width)/2.0f, OfferAnnotationViewNormal_Height - OfferAnnotationViewExpanded_Height - 14, OfferAnnotationViewExpanded_Width, OfferAnnotationViewExpanded_Height)];
        _expandedView.backgroundColor = [UIColor clearColor];
        
        // Image View
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0.5, OfferAnnotationViewExpanded_Width - 1, OfferAnnotationViewExpanded_Height - 1)];
        [self setMaskTo:_imageView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
        [_expandedView addSubview:_imageView];
        
        // Name Label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, OfferAnnotationViewExpanded_Width, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        _titleLabel.shadowOffset = CGSizeMake(0, -1);
        _titleLabel.font = [UIFont boldSystemFontOfSize:8.5f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_expandedView addSubview:_titleLabel];
        
        // address Label
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, OfferAnnotationViewExpanded_Width, 20)];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:7.5f];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [_expandedView addSubview:_subtitleLabel];
        
        // shape layer
        _strokeAndShadowLayer = [CAShapeLayer layer];
        CGPathRef _strokeAndShadowLayerPath = [self newBubbleWithRect:_expandedView.bounds];
        _strokeAndShadowLayer.path = _strokeAndShadowLayerPath;
        CGPathRelease(_strokeAndShadowLayerPath);
        _strokeAndShadowLayer.fillColor = [UIColor colorWithRed:158.0f/255.0f green:11.0f/255.0f blue:15.0f/255.0f alpha:1.0f].CGColor;
        _strokeAndShadowLayer.shadowColor = [UIColor whiteColor].CGColor;
        _strokeAndShadowLayer.shadowOffset = CGSizeMake (0, [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2 ? 1.0f : -3);
        _strokeAndShadowLayer.shadowRadius = 5.0;
        _strokeAndShadowLayer.shadowOpacity = .7;
        _strokeAndShadowLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
        _strokeAndShadowLayer.lineWidth = 1.0;
        _strokeAndShadowLayer.masksToBounds = NO;
        [_expandedView.layer insertSublayer:_strokeAndShadowLayer atIndex:0];
        
        // default state
        _state = OfferAnnotationViewState_Normal;
        
    }
    return self;
}

-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    CGRect rect = view.bounds;
    rect.size.height = OfferAnnotationViewImageHeight;
    CGFloat radius = 7.0;
    
    CGMutablePathRef path = CGPathCreateMutable();
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1);

	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1);
	CGPathCloseSubpath(path);
    
//    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:path];
    
    view.layer.mask = shape;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    OfferTableItem *item = annotation;
    self.coordinate = item.location;
    
    // normal view
    NSString *imageName = [item.category_id integerValue] != 1 ? @"map-icon-pin-entertainment.png" : @"map-icon-pin-food-beverage.png";
    [self.normalView setImage:[UIImage imageNamed:imageName]];
    
    // expanded view
    self.titleLabel.text = item.title;
    self.subtitleLabel.text = item.subtitle;
    [self.imageView setImage:[UIImage imageNamed:@"img-loc-mcdonalds.jpg"]];
}

#pragma mark - OfferAnnotationViewProtocol
- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView {
    // Center map at annotation point
    [mapView setCenterCoordinate:_coordinate animated:YES];
    
    if (_state != OfferAnnotationViewState_Normal) return;
    _state = OfferAnnotationViewState_Animating;
    
    [UIView animateWithDuration:1.0f animations:^{
        [self.normalView removeFromSuperview];
        [self addSubview:self.expandedView];
    } completion:^(BOOL finished) {
        _state = OfferAnnotationViewState_Expanded;
    }];
}

- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView {
    if (_state != OfferAnnotationViewState_Expanded) return;
    _state = OfferAnnotationViewState_Animating;
    
    [UIView animateWithDuration:1.0f animations:^{
        [self.expandedView removeFromSuperview];
        [self addSubview:self.normalView];
    } completion:^(BOOL finished) {
        _state = OfferAnnotationViewState_Normal;
    }];
}

#pragma mark - Utilities
- (CGPathRef)newBubbleWithRect:(CGRect)rect {
//    CGFloat stroke = 1.0;
	CGFloat radius = 7.0;
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat parentX = rect.origin.x + rect.size.width/2;
	
	//Determine Size
//	rect.size.width -= stroke + 14;
//	rect.size.height -= stroke + 29;
//	rect.origin.x += stroke / 2.0 + 7;
//	rect.origin.y += stroke / 2.0 + 7;
    
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 10, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 14);
	CGPathAddLineToPoint(path, NULL, parentX + 10, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1);
	CGPathCloseSubpath(path);
    return path;
}

@end