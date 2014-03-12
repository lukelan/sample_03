//
//  MainViewController.m
//  PlusOffer
//
//  Created by Trong Vu on 3/12/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "MainViewController.h"
#import "FlipBoardNavigationController.h"
#import "PBExampleViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachment;

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CALayer *layer = self.view.layer;
    layer.cornerRadius = 5.0f;
    
    // Pan for a dismissal using UIKit Dynamics
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:panGesture];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.superview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushFlipBoard:(UIButton *)sender {
    UIViewController * page = [self.storyboard instantiateViewControllerWithIdentifier:@"flipboard_vc"];
    [self.flipboardNavigationController pushViewController:page];
}
- (IBAction)pushPinterest:(UIButton *)sender {
    UIViewController * page = [self.storyboard instantiateViewControllerWithIdentifier:@"pinterest_vc"];
    [self.flipboardNavigationController pushViewController:page];
}
- (IBAction)pushFeedly:(UIButton *)sender {
    UIViewController * page =[[PBExampleViewController alloc] init];
    [self.flipboardNavigationController pushViewController:page];
}

- (void)didPan:(UIPanGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.view.superview];
    
//    NSLog(@"==%f--==%f",location.x,location.y);
    
    CGPoint velocity = [gesture velocityInView:self.view];
    
//    NSLog(@"--------aaaa---=%fxxx=%f",velocity.x,velocity.y);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            // Cleanup existing behaviors like the "snap" behavior when, after a pan starts, this view
            // gets snapped back into place
            [self.animator removeAllBehaviors];
            
            // Give the view some rotation
            UIDynamicItemBehavior *rotationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
            rotationBehavior.allowsRotation = YES;
            rotationBehavior.angularResistance = 10.0f;
            
            [self.animator addBehavior:rotationBehavior];
            
            // Calculate the offset from the center of the view to use in the attachment behavior
            CGPoint viewCenter = self.view.center;
            UIOffset centerOffset = UIOffsetMake(location.x - viewCenter.x, location.y - viewCenter.y);
            
            // Attach to the location of the pan in the container view.
            self.panAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.view
                                                           offsetFromCenter:centerOffset
                                                           attachedToAnchor:location];
            self.panAttachment.damping = 0.7f;
            self.panAttachment.length = 0;
            [self.animator addBehavior:self.panAttachment];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // Now when the finger moves around we just update the anchor point,
            // which will move the view around
            self.panAttachment.anchorPoint = location;
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            // Not enough velocity to exit the modal, so snap it back into the center of the screen
            [self.animator removeAllBehaviors];
            
            UISnapBehavior *snapIt ;
            if (location.y >= self.view.center.y/2 && velocity.y > 0) {
                snapIt = [[UISnapBehavior alloc] initWithItem:self.view snapToPoint:CGPointMake(160, [UIScreen mainScreen].bounds.size.height)];
            } else {
                snapIt = [[UISnapBehavior alloc] initWithItem:self.view snapToPoint:CGPointMake(160, [UIScreen mainScreen].bounds.size.height/2)];
            }
            
            snapIt.damping = 0.7;
            
            [self.animator addBehavior:snapIt];
            
            
            break;
        }
        default:
            break;
    }
}

@end

