//
//  PunchCell.h
//  PlusOffer
//
//  Created by Le Ngoc Duy on 12/31/13.
//  Copyright (c) 2013 Trongvm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PunchCell : UITableViewCell
{
    __weak id<OpenBarcodeScannerDelegate> _delegate;
}
@property (nonatomic, weak) id<OpenBarcodeScannerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
-(void)setObject:(id)object;
@end
