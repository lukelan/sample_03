//
//  MapOfferViewController.m
//  PlusOffer
//
//  Created by Trong Vu on 12/26/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import "MapOfferViewController.h"
#import "JPSThumbnailAnnotation.h"

#define GM_TAG        1002

@interface MapOfferViewController ()

@end

@implementation MapOfferViewController

@synthesize gmDemo = _gmDemo;

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
    empire.title = @"Empire State Building";
    empire.subtitle = @"NYC Landmark";
    empire.coordinate = CLLocationCoordinate2DMake(40.75, -73.99);
    empire.disclosureBlock = ^{ NSLog(@"selected Empire"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire]];
    
    // Apple HQ
    JPSThumbnail *apple = [[JPSThumbnail alloc] init];
    apple.image = [UIImage imageNamed:@"map_offer.png"];
    apple.title = @"Apple HQ";
    apple.subtitle = @"Apple Headquarters";
    apple.coordinate = CLLocationCoordinate2DMake(37.33, -122.03);
    apple.disclosureBlock = ^{ NSLog(@"selected Appple"); };
    
    [annotations addObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:apple]];
    
    // Parliament of Canada
    JPSThumbnail *ottawa = [[JPSThumbnail alloc] init];
    ottawa.image = [UIImage imageNamed:@"map_offer.png"];
    ottawa.title = @"Parliament of Canada";
    ottawa.subtitle = @"Oh Canada!";
    ottawa.coordinate = CLLocationCoordinate2DMake(45.43, -75.70);
    ottawa.disclosureBlock = ^{ NSLog(@"selected Ottawa"); };
    
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
        
        JCGridMenuRow *search = [[JCGridMenuRow alloc]
                                 initWithImages:@"Search"
                                 selected:@"CloseSelected"
                                 highlighted:@"SearchSelected"
                                 disabled:@"Search"];
        [search.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        [search setHideOnExpand:YES];
        [search setIsExpanded:YES];
        [search setIsModal:YES];
        [search setHideAlpha:0.0f];
        [search setIsSeperated:NO];
        [search setColumns:[[NSMutableArray alloc] initWithObjects:searchInput, searchClose, nil]];
        
        
        // Favourites
        
        JCGridMenuColumn *favouriteView = [[JCGridMenuColumn alloc]
                                           initWithButtonImageTextLeft:CGRectMake(0, 0, 76, 44)
                                           image:@"FavouriteSmall"
                                           selected:@"FavouriteSmallSelected"
                                           text:@"Event"];
        [favouriteView.button setBackgroundColor:[UIColor blackColor]];
        [favouriteView setCloseOnSelect:NO];
        
        JCGridMenuColumn *favouriteObject = [[JCGridMenuColumn alloc]
                                             initWithButtonImageTextLeft:CGRectMake(0, 0, 80, 44)
                                             image:@"FavouriteSmall"
                                             selected:@"FavouriteSmallSelected"
                                             text:@"Object"];
        [favouriteObject.button setBackgroundColor:[UIColor blackColor]];
        [favouriteObject setCloseOnSelect:NO];
        
        JCGridMenuColumn *favouriteMethod = [[JCGridMenuColumn alloc]
                                             initWithButtonImageTextLeft:CGRectMake(0, 0, 88, 44)
                                             image:@"FavouriteSmall"
                                             selected:@"FavouriteSmallSelected"
                                             text:@"Method"];
        [favouriteMethod.button setBackgroundColor:[UIColor blackColor]];
        [favouriteMethod setCloseOnSelect:NO];
        
        
        JCGridMenuRow *favourites = [[JCGridMenuRow alloc]
                                     initWithImages:@"Favourite"
                                     selected:@"FavouriteSelected"
                                     highlighted:@"FavouriteSelected"
                                     disabled:@"Favourite"];
        [favourites setColumns:[[NSMutableArray alloc] initWithObjects:favouriteView, favouriteObject, favouriteMethod, nil]];
        [favourites setIsExpanded:YES];
        [favourites setIsModal:YES];
        [favourites setHideAlpha:0.0f];
        [favourites.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        
        
        // Share
        
        JCGridMenuColumn *twitter = [[JCGridMenuColumn alloc]
                                     initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
                                     normal:@"Twitter"
                                     selected:@"TwitterSelected"
                                     highlighted:@"TwitterSelected"
                                     disabled:@"Twiiter"];
        [twitter.button setBackgroundColor:[UIColor blackColor]];
        
        JCGridMenuColumn *email = [[JCGridMenuColumn alloc]
                                   initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
                                   normal:@"Email"
                                   selected:@"EmailSelected"
                                   highlighted:@"EmailSelected"
                                   disabled:@"Email"];
        [email.button setBackgroundColor:[UIColor blackColor]];
        
        JCGridMenuColumn *pocket = [[JCGridMenuColumn alloc]
                                    initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
                                    normal:@"Pocket"
                                    selected:@"PocketSelected"
                                    highlighted:@"PocketSelected"
                                    disabled:@"Pocket"];
        [pocket.button setBackgroundColor:[UIColor blackColor]];
        
        JCGridMenuColumn *facebook = [[JCGridMenuColumn alloc]
                                      initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
                                      normal:@"Facebook"
                                      selected:@"FacebookSelected"
                                      highlighted:@"FacebookSelected"
                                      disabled:@"Facebook"];
        [facebook.button setBackgroundColor:[UIColor blackColor]];
        
        JCGridMenuRow *share = [[JCGridMenuRow alloc] initWithImages:@"Share" selected:@"Close" highlighted:@"ShareSelected" disabled:@"Share"];
        [share setColumns:[[NSMutableArray alloc] initWithObjects:pocket, twitter, facebook, email, nil]];
        [share setIsExpanded:YES];
        [share setIsModal:YES];
        [share setHideAlpha:0.0f];
        [share.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        
        
        // Rows...
        
        NSArray *rows = [[NSArray alloc] initWithObjects:search, favourites, share, nil];
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
            BOOL hasSelected = NO;
            
            for (int i=0; i<[[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] count]; i++) {
                
                if ([[[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] objectAtIndex:i] isSelected]) {
                    hasSelected = YES;
                    break;
                }
                
            }
            
            [[[_gmDemo.gridCells objectAtIndex:indexRow] button] setSelected:hasSelected];
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

@end
