//
//  VCCalendarView.m
//  MNCalendarView
//
//  Created by Bill Shirley on 5/5/14.
//  Copyright (c) 2014 min. All rights reserved.
//

#import "VCCalendarView.h"
#import "MNCalendarViewDayCell.h"

@interface VCCalendarView ()
@property (strong, nonatomic) NSArray *dates;
@property (weak, nonatomic) UIViewController *controller;
@end

@implementation VCCalendarView

- (void)restrictToDates:(NSArray *)dates {
  __block NSDate *newestDate = [NSDate distantPast];
  __block NSDate *oldestDate = [NSDate distantFuture];
  
  [dates enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL *stop) {
    if ([obj compare:newestDate] == NSOrderedDescending) {
      newestDate = obj;
    }
    if ([obj compare:oldestDate] == NSOrderedAscending) {
      oldestDate = obj;
    }
  }];
  
  self.fromDate = oldestDate;
  self.toDate = newestDate;
  self.dates = dates;
  [self reloadData];
}

+ (instancetype)newCalendarViewDisplayedOver:(UIViewController *)parentViewController forDates:(NSArray *)dates {
  CGRect frame = parentViewController.view.frame;
  VCCalendarView *instance = [[self alloc] initWithFrame:frame];
  [instance restrictToDates:dates];

  UIViewController *vc = [[UIViewController alloc] init];
  vc.view = instance;
  vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:instance
                                                                         action:@selector(dismissCalendar:)];
  vc.navigationItem.rightBarButtonItems =  @[
                                             [[UIBarButtonItem alloc] initWithTitle:@"select"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:instance
                                                                             action:@selector(selectDates:)],
                                             ];
  
  UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
  nvc.navigationBar.translucent = YES;
  
  [parentViewController presentViewController:nvc
                                     animated:YES
                                   completion:^{
                                     // calendar now in view
                                     ;
                                   }];
  instance.controller = nvc;
  return instance;
}

#pragma mark - superclass overrides

- (void)commonInit {
  [super commonInit];
}

- (void)reloadData {
  [super reloadData];

  NSEnumerator *e = self.monthDates.reverseObjectEnumerator;
  self.monthDates = [e allObjects];
  
  [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MNCalendarViewDayCell *cell = (MNCalendarViewDayCell *)[super collectionView:collectionView
                                                        cellForItemAtIndexPath:indexPath];
  
  if ([cell isKindOfClass:[MNCalendarViewDayCell class]]) {
    
    NSDateComponents *components =
    [self.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:cell.date];
    
    NSDateComponents *monthComponents =
    [self.calendar components:NSMonthCalendarUnit
                     fromDate:cell.month];

    if (monthComponents.month != components.month) {
      // pad dates from other months are not labeled
      cell.titleLabel.text = @"";
    }
    
    if ([self.dates containsObject:cell.date] == NO) {
      // disable unused dates
      cell.enabled = NO;
    }
  }
  
  return cell;
}

#pragma mark - targets from nav bar

- (void)dismissCalendar:(id)sender {
  [self.controller dismissViewControllerAnimated:YES completion:^{
    ;
  }];
}

- (void)selectDates:(id)sender {
  [self.controller dismissViewControllerAnimated:YES completion:^{
    if ([self.delegate respondsToSelector:@selector(calendarView:selectDates:)]) {
      NSArray *dates = @[self.selectedDate];
      [(id<VCCalendarViewDelegate>)self.delegate calendarView:self selectDates:dates];
    }
  }];
}


@end
