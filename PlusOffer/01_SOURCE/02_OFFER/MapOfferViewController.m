//
//  MapOfferViewController.m
//  PlusOffer
//
//  Created by Trong Vu on 12/26/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "MapOfferViewController.h"
#import "JPSThumbnailAnnotation.h"
#import "DefineConstant.h"

#define GM_TAG        1002

@interface MapOfferViewController ()

@end

@implementation MapOfferViewController {
    float _radiusMeters;
    CLLocationCoordinate2D _centralPoint;
}

@synthesize gmDemo = _gmDemo;
- (id)init
{
    return [super init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [self initMenu];
    [self open];
    
    // Annotations
    
    self.mapOfferView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mapOfferView.delegate = self;
    [self.mapOfferView addAnnotations:[self generateAnnotations]];
    self.mapOfferView.showsUserLocation = YES;
    
    // calculate central point of kards
    MKCoordinateRegion region = [self createZoomRegionFromCentralPointAndRadius :self.mapOfferView.annotations];
    region = [self.mapOfferView regionThatFits:region];
    
    // Zoom and scale to central point
    [self.mapOfferView setRegion:region animated:TRUE];
    [self.mapOfferView regionThatFits:region];
    [self.mapOfferView reloadInputViews];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    PINGREMARKETING
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;

}

- (NSArray *)generateAnnotations {
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Empire State Building
    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
    empire.image = [UIImage imageNamed:@"map_offer.png"];
    empire.title = @"McDonald's";
    empire.subtitle = @"McDonald's Q.7";
    empire.coordinate = CLLocationCoordinate2DMake(10.729608, 106.721385);
    empire.disclosureBlock = ^{ NSLog(@"selected McDonald's Q.7"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire]];
    
    // Apple HQ
    JPSThumbnail *apple = [[JPSThumbnail alloc] init];
    apple.image = [UIImage imageNamed:@"map_offer.png"];
    apple.title = @"Urban Station - CMT8";
    apple.subtitle = @"Urban Station - CMT8";
    apple.coordinate = CLLocationCoordinate2DMake(10.791523, 106.655974);
    apple.disclosureBlock = ^{ NSLog(@"selected Urban Station - CMT8"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:apple]];
    
    // Parliament of Canada
    JPSThumbnail *ottawa = [[JPSThumbnail alloc] init];
    ottawa.image = [UIImage imageNamed:@"map_offer.png"];
    ottawa.title = @"Urban Station - Gò Vấp";
    ottawa.subtitle = @"Urban Station - Gò Vấp";
    ottawa.coordinate = CLLocationCoordinate2DMake(10.836309,  106.675519);
    ottawa.disclosureBlock = ^{ NSLog(@"selected Urban Station - Gò Vấp"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:ottawa]];
    
    return annotations;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}


#pragma mark - Initialise

- (void)initMenu
{
    if (self) {
        NSLog(@"init demo2");
        // Search
        
        JCGridMenuColumn *searchInput = [[JCGridMenuColumn alloc]
                                         initWithView:CGRectMake(0, 0, 264, 44)];
        [searchInput.view setBackgroundColor:[UIColor whiteColor]];
        
        JCGridMenuColumn *searchClose = [[JCGridMenuColumn alloc]
                                         initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
                                         normal:@"Close"
                                         selected:@"CloseSelected"
                                         highlighted:@"CloseSelected"
                                         disabled:@"Close"];
        
//        JCGridMenuRow *search = [[JCGridMenuRow alloc]
//                                 initWithImages:@"Search"
//                                 selected:@"CloseSelected"
//                                 highlighted:@"SearchSelected"
//                                 disabled:@"Search"];
        
        JCGridMenuRow *search = [[JCGridMenuRow alloc]
                                 initWithImages:@"Close"
                                 selected:@"CloseSelected"
                                 highlighted:@"CloseSelected"
                                 disabled:@"Close"];
        [search.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        [search setHideOnExpand:YES];
        [search setIsExpanded:YES];
        [search setIsModal:YES];
        [search setHideAlpha:0.0f];
        [search setIsSeperated:NO];
        [search setColumns:[[NSMutableArray alloc] initWithObjects:searchInput, searchClose, nil]];
        
        
        // Favourites
        
        JCGridMenuColumn *favouriteView = [[JCGridMenuColumn alloc]
                                           initWithButtonImageTextLeft:CGRectMake(0, 0, 88, 44)
                                           image:@"Favourite"
                                           selected:@"FavouriteSelected"
                                           text:@"Gần đây"];
        [favouriteView.button setBackgroundColor:[UIColor blackColor]];
        [favouriteView.button setSelected:YES];
        [favouriteView setCloseOnSelect:YES];
        
        JCGridMenuColumn *favouriteObject = [[JCGridMenuColumn alloc]
                                             initWithButtonImageTextLeft:CGRectMake(0, 0, 88, 44)
                                             image:@"Pocket"
                                             selected:@"PocketSelected"
                                             text:@"Ẩm thực"];
        [favouriteObject.button setBackgroundColor:[UIColor blackColor]];
        [favouriteObject setCloseOnSelect:YES];
        
        JCGridMenuColumn *favouriteMethod = [[JCGridMenuColumn alloc]
                                             initWithButtonImageTextLeft:CGRectMake(0, 0, 88, 44)
                                             image:@"Facebook"
                                             selected:@"FacebookSelected"
                                             text:@"Giải trí"];
        [favouriteMethod.button setBackgroundColor:[UIColor blackColor]];
        [favouriteMethod setCloseOnSelect:YES];
        
        
        JCGridMenuRow *favourites = [[JCGridMenuRow alloc]
                                     initWithImages:@"Favourite"
                                     selected:@"FavouriteSelected"
                                     highlighted:@"FavouriteSelected"
                                     disabled:@"Favourite"];
        [favourites setColumns:[[NSMutableArray alloc] initWithObjects:favouriteView, favouriteObject, favouriteMethod, nil]];
        [favourites setIsExpanded:YES];
        [favourites setIsModal:YES];
        [favourites setHideAlpha:0.0f];
        [favourites setHideOnExpand:YES];
        [favourites.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        [favourites.button setSelected:YES];
        [favourites setIsSelected:YES];
        
//        // Share
//        
//        JCGridMenuColumn *twitter = [[JCGridMenuColumn alloc]
//                                     initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
//                                     normal:@"Twitter"
//                                     selected:@"TwitterSelected"
//                                     highlighted:@"TwitterSelected"
//                                     disabled:@"Twiiter"];
//        [twitter.button setBackgroundColor:[UIColor blackColor]];
//        
//        JCGridMenuColumn *email = [[JCGridMenuColumn alloc]
//                                   initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
//                                   normal:@"Email"
//                                   selected:@"EmailSelected"
//                                   highlighted:@"EmailSelected"
//                                   disabled:@"Email"];
//        email.button.titleLabel.text = @"Gần đây";
//        [email.button setBackgroundColor:[UIColor blackColor]];
//        
//        JCGridMenuColumn *pocket = [[JCGridMenuColumn alloc]
//                                    initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
//                                    normal:@"Pocket"
//                                    selected:@"PocketSelected"
//                                    highlighted:@"PocketSelected"
//                                    disabled:@"Pocket"];
//        [pocket.button setBackgroundColor:[UIColor blackColor]];
//        
//        JCGridMenuColumn *facebook = [[JCGridMenuColumn alloc]
//                                      initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
//                                      normal:@"Facebook"
//                                      selected:@"FacebookSelected"
//                                      highlighted:@"FacebookSelected"
//                                      disabled:@"Facebook"];
//        [facebook.button setBackgroundColor:[UIColor blackColor]];
//        
//        JCGridMenuRow *share = [[JCGridMenuRow alloc] initWithImages:@"Share" selected:@"Close" highlighted:@"ShareSelected" disabled:@"Share"];
//        [share setColumns:[[NSMutableArray alloc] initWithObjects:pocket, twitter, facebook, email, nil]];
//        [share setIsExpanded:YES];
//        [share setIsModal:YES];
//        [share setHideAlpha:0.0f];
//        [share.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
//        
        
        // Rows...
        
//        NSArray *rows = [[NSArray alloc] initWithObjects:search, favourites, share, nil];
        NSArray *rows = [[NSArray alloc] initWithObjects:search, favourites, nil];
        _gmDemo = [[JCGridMenuController alloc] initWithFrame:CGRectMake(0,20,320,(44*[rows count])+[rows count]) rows:rows tag:GM_TAG];
        [_gmDemo setDelegate:self];
        [self.view addSubview:_gmDemo.view];
    }
}


#pragma mark - Open and Close

- (void)open
{
    [_gmDemo open];
}

- (void)close
{
    [self searchInput:NO];
    [_gmDemo close];
}



#pragma mark - JCGridMenuController Delegate

- (void)jcGridMenuRowSelected:(NSInteger)indexTag indexRow:(NSInteger)indexRow isExpand:(BOOL)isExpand
{
    if (isExpand) {
        NSLog(@"jcGridMenuRowSelected %i %i isExpand", indexTag, indexRow);
    } else {
        NSLog(@"jcGridMenuRowSelected %i %i !isExpand", indexTag, indexRow);
    }
    
    if (indexTag==GM_TAG) {
        JCGridMenuRow *rowSelected = (JCGridMenuRow *)[_gmDemo.rows objectAtIndex:indexRow];
        
        if ([rowSelected.columns count]==0) {
            // If there are no more columns, we can use this button as an on/off switch
            [[rowSelected button] setSelected:![rowSelected button].selected];
        } else {
            
            if (isExpand) {
                
                switch (indexRow) {
                    case 0: // Search
                        [[rowSelected button] setSelected:YES];
                        [self backVC];
//                        [self searchInput:YES];
                        break;
                    case 2: // Share
                        [[rowSelected button] setSelected:YES];
                        break;
                }
                
            } else {
                
                switch (indexRow) {
                    case 0: // Search
                        [[rowSelected button] setSelected:NO];
                        break;
                    case 2: // Share
                        [[rowSelected button] setSelected:NO];
                        break;
                }
                
            }
            
        }
    }
    
}

- (void)jcGridMenuColumnSelected:(NSInteger)indexTag indexRow:(NSInteger)indexRow indexColumn:(NSInteger)indexColumn
{
    NSLog(@"jcGridMenuColumnSelected %i %i %i", indexTag, indexRow, indexColumn);
    
    if (indexTag==GM_TAG) {
        
        if (indexRow==0) {
            // Search
            [self searchInput:NO];
            [[[_gmDemo.gridCells objectAtIndex:indexRow] button] setSelected:NO];
            [_gmDemo setIsRowModal:NO];
        } else if (indexRow==1) {
            // Favourites
            UIButton *selected = (UIButton *)[[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] objectAtIndex:indexColumn];
            [selected setSelected:![selected isSelected]];
            
            for (int i=0; i<[[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] count]; i++) {
                
                UIButton *selectChildButton = [[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] objectAtIndex:i];
                if (i != indexColumn) {
                    [selectChildButton setSelected:NO];
                } else {
                    [selectChildButton setSelected:YES];
                }
                
            }
            
            UIImage *selectedImage = [[[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] objectAtIndex:indexColumn] imageForState:UIControlStateSelected];
            
            [[[_gmDemo.gridCells objectAtIndex:indexRow] button] setImage:selectedImage forState:UIControlStateSelected];
     
            [[[_gmDemo.gridCells objectAtIndex:indexRow] button] setSelected:YES];
            
            [_gmDemo setIsRowModal:NO];
        } else if (indexRow==2) {
            [[[_gmDemo.gridCells objectAtIndex:indexRow] button] setSelected:NO];
            [_gmDemo setIsRowModal:NO];
        }
        
    }
    
}


#pragma mark - Demo specific controls

- (void)searchInput:(BOOL)isDisplay
{
    UITextView *text;
    
    if (isDisplay) {
        text = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 100, 20)];
        [text setBackgroundColor:[UIColor clearColor]];
        [text setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [text setTag:12345];
        [self.view addSubview:text];
        [text performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
    } else {
        text = (UITextView *)[self.view viewWithTag:12345];
        [text resignFirstResponder];
        [text removeFromSuperview];
    }
    
}


- (MKCoordinateRegion)createZoomRegionFromCentralPointAndRadius:(NSArray*) categoryArray {
    
    [self calculateCentralPointAndRadiusFromLocationKardsNew:categoryArray withCurrenLocation:YES];
    
    // have no deal zoom minimum scale to current location
    if ([categoryArray count] == 0) {
        _radiusMeters = MAXIMUM_SCALEABLE_RADIUS_METERS/2;
        _centralPoint = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D;
    }
    
    if (_radiusMeters > MAXIMUM_SCALEABLE_RADIUS_METERS) {
        _radiusMeters = 1000;
        _centralPoint.latitude = ((JPSThumbnail *)categoryArray[0]).coordinate.latitude;
        _centralPoint.longitude = ((JPSThumbnail *)categoryArray[0]).coordinate.longitude;
    }
    return MKCoordinateRegionMakeWithDistance(_centralPoint, _radiusMeters*2, _radiusMeters*3);
}

#pragma mark - Map procedures

- (void)calculateCentralPointAndRadiusFromLocationKardsNew:(NSArray*) categoryArray withCurrenLocation:(BOOL)bCurrentLocation {
    
    // If current location not found -> return the radius default 1km.
    if (CLLocationCoordinate2DIsValid(((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D)) {
        _centralPoint.latitude = ((JPSThumbnail*)categoryArray[0]).coordinate.latitude;
        _centralPoint.longitude = ((JPSThumbnail*)categoryArray[0]).coordinate.longitude;
        _radiusMeters = 1000;
        return;
    }
    
    // Find the nearest location
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D.latitude longitude:((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D.longitude];
    _centralPoint = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D;
    
    _radiusMeters = MAXIMUM_SCALEABLE_RADIUS_METERS;
    for (JPSThumbnail *venue in categoryArray) {
        
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:venue.coordinate.latitude longitude:venue.coordinate.longitude];
        
        CLLocationDistance distance = [locA distanceFromLocation:locB];
        
        if (distance < _radiusMeters) {
            _radiusMeters = distance;
        }
    }
}

- (void)calculateCentralPointAndRadiusFromLocationKards:(NSArray*) categoryArray withCurrenLocation:(BOOL)bCurrentLocation {
    
    // Find latitude and longtitude smallest and biggest
    float smallLongtitute   = 0;
    float smallLattitute    = 0;
    float bigLongtitute     = 0;
    float bigLattitute      = 0;
    
    // include current location in calculate
    if (bCurrentLocation) {
        smallLongtitute   = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D.longitude;
        smallLattitute    = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D.latitude;
        bigLongtitute     = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D.longitude;
        bigLattitute      = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userPosition.positionCoodinate2D.latitude;
    }
    
    for (JPSThumbnail *venue in categoryArray) {
        
        float lat = venue.coordinate.latitude;
        float lng = venue.coordinate.longitude;
        if (lat < smallLattitute || smallLattitute == 0) {
            smallLattitute = lat;
        }
        if (lat> bigLattitute || bigLattitute == 0) {
            bigLattitute = lat;
        }
        if (lng < smallLongtitute || smallLongtitute == 0) {
            smallLongtitute = lng;
        }
        if (lng> bigLongtitute || bigLongtitute == 0) {
            bigLongtitute = lng;
        }
    }
    
    // Update central point
    _centralPoint.latitude    = (bigLattitute + smallLattitute)/2;
    _centralPoint.longitude   = (bigLongtitute + smallLongtitute)/2;
    
    NSLog(@"-caluclateCentralPointWithLocationKards-central point - latitude=%f---longtitude=%f",_centralPoint.latitude, _centralPoint.longitude);
    
    // Calculate radius
    CLLocation *marklocation = [[CLLocation alloc] initWithLatitude:smallLattitute longitude:smallLongtitute];
    CLLocation *centralLocation = [[CLLocation alloc] initWithLatitude:_centralPoint.latitude longitude:_centralPoint.longitude];
    
    _radiusMeters = ([marklocation distanceFromLocation:centralLocation]);
    
    if (_radiusMeters == 0) {
        // Default for radius is 1km
        //Too far is when you show the entire USA.  Too close is when you show only a 300 ft/100m radius.
        //I think we can settle on something in the middle.  How about something like a 1Km radius
        _radiusMeters = 1000;
    }
    
    NSLog(@"Distance in meters: %f", _radiusMeters);
    
}

@end
