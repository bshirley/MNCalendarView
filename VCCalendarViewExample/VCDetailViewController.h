//
//  VCDetailViewController.h
//  VCCalendarViewExample
//
//  Created by Bill Shirley on 4/29/14.
//  Copyright (c) 2014 min. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
