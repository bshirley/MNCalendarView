//
//  VCAppDelegate.h
//  VCCalendarViewExample
//
//  Created by Bill Shirley on 4/29/14.
//  Copyright (c) 2014 min. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (VCAppDelegate *)appDelegate;

/**
 * item keys: (fake email entries)
 *  date: NSDate value
 *  from: a string used to find an image for the "person"
 *  subject: subject of a simulated message
 *  content: random text for message
 */
@property (strong, nonatomic) NSMutableArray *items;

- (NSArray *)addRandomData;

/// derivative data:
@property (readonly, nonatomic) NSInteger numberOfDays; // different days in items
@property (readonly, nonatomic) NSArray *listOfDays;

- (NSInteger)numberOfItemsInDay:(NSDate *)day;
- (NSArray *)itemsInDay:(NSDate *)day;

- (void)deleteItem:(NSDictionary *)item;

@end
