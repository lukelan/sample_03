//
//  InfoPlusOfferCell.h
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 12/27/13.
//  Copyright (c) 2013 Trong Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPlusOfferCell : UITableViewCell
{
    __weak id<OpenMapViewDelegate> _delegate;
}
@property (nonatomic, weak) id<OpenMapViewDelegate> delegate;

//@property (strong, nonatomic) IBOutlet UILabel *lbtime;
//@property (strong, nonatomic) IBOutlet UILabel *lblocation;
@property (strong, nonatomic)  SDImageView *imageInfoPlus;
@property (strong, nonatomic)  UIView *containerView;
@property (strong, nonatomic)  UIView *containerViewInfo;
@property (strong, nonatomic)  UILabel *offerNameLbl;
@property (strong, nonatomic)  UILabel *branchNameLbl;
@property (nonatomic, retain) UILabel *deadLine;
@property (nonatomic, retain) UILabel *titleDeadLine;
@property (nonatomic, retain) UILabel *punchLbl;
@property (nonatomic, retain) UILabel *titlePunchLbl;
@property (nonatomic, retain) UILabel *distanceLbl;
@property (nonatomic, retain) UILabel *titleDistanceLbl;
@property (nonatomic, retain) UILabel *processPunch;
@property (nonatomic, retain) UILabel *processPunch1;
@property (nonatomic, retain) SDImageView *processPunchBackGround;
@property (nonatomic, retain) UIButton *btMap;
@property (nonatomic, retain)  CALayer *shadowLayer;
 @property (nonatomic, retain) NSString *title;
//@property (weak, nonatomic) IBOutlet UIButton *btnOpenMap;
//- (IBAction)processOpenMapView:(id)sender;
-(void)setObject:(id)object;

@end
