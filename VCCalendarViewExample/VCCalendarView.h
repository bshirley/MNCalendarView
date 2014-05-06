//
//  VCCalendarView.h
//  MNCalendarView
//
//  Created by Bill Shirley on 5/5/14.
//  Copyright (c) 2014 min. All rights reserved.
//

#import "MNCalendarView.h"

@interface VCCalendarView : MNCalendarView

+ (instancetype)newCalendarViewDisplayedOver:(UIViewController *)parentViewController forDates:(NSArray *)dates;

@end



@protocol VCCalendarViewDelegate <MNCalendarViewDelegate>

@optional

- (void)calendarView:(VCCalendarView *)calendarView selectDates:(NSArray *)dates;
- (void)calendarView:(VCCalendarView *)calendarView filterOnDates:(NSArray *)dates;

@end