//
//  VCAppDelegate.m
//  VCCalendarViewExample
//
//  Created by Bill Shirley on 4/29/14.
//  Copyright (c) 2014 min. All rights reserved.
//

#import "VCAppDelegate.h"

@implementation VCAppDelegate

+ (VCAppDelegate *)appDelegate {
    return (VCAppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark - Data Source Maintenance

- (void)persistList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.items forKey:@"SampleData"];
    [defaults synchronize];
}

- (void)deleteItem:(NSDictionary *)item {
    [self.items removeObject:item];
    [self persistList];
}

- (void)sortItems {
  [self.items sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
      NSDate *date1 = obj1[@"date"];
      NSDate *date2 = obj2[@"date"];
      return [date2 compare:date1]; // sort from current/future to past
  }];
}

- (NSDictionary *)randomItemWithinDays:(NSInteger)numberOfDays {
    NSArray *from = @[@"Bob", @"Fred", @"Joe", @"Jane", @"Mary", @"Chase", @"McDonalds"];
    int randomNumber = arc4random() % 1000;
    CGFloat secondsAgo = arc4random() % (60 * 60 * 24 * numberOfDays);
    NSDictionary *item = @{@"date": [NSDate dateWithTimeIntervalSinceNow: -secondsAgo],
                           @"from": from[arc4random() % from.count],
                           @"subject": [NSString stringWithFormat:@"Subject #%00d", randomNumber],
                           @"content": [NSString stringWithFormat:@"Message number %d. This content is for message number %d; the number is not necessarily unique.", randomNumber, randomNumber]};
    return item;
}

- (NSMutableArray *)initialData {
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [values addObject:[self randomItemWithinDays:30]];
    }
    
    return values;
}

- (void)addRandomData {
    for (int i = 0; i < 1; i++) {
        [self.items addObject:[self randomItemWithinDays:3]];
    }

    [self sortItems];
    [self persistList];
}

- (void)loadItems {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *data = [defaults valueForKey:@"SampleData"];

    if (data == nil) {
        data = [self initialData];
        self.items = data;
        [self sortItems];
        [self persistList];
    } else {
        self.items = data;
        [self addRandomData];
    }
}

#pragma mark -

- (NSDateComponents *)componentsOfDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
           fromDate:date];
    return components;
}

- (NSInteger)numberOfDays {
    // no assumption of sort order
    NSMutableArray *components = [NSMutableArray arrayWithCapacity:self.items.count];
    
    for (NSDictionary *item in self.items) {
        NSDateComponents *dc = [self componentsOfDate:item[@"date"]];
        __block BOOL isInList = NO;
        [components enumerateObjectsUsingBlock:^(NSDateComponents *comp, NSUInteger idx, BOOL *stop) {
            if (comp.day == dc.day && comp.month == dc.month && comp.year == dc.year) {
                isInList = YES;
                *stop = YES;
            }
        }];
        if (isInList == NO) {
            [components addObject:dc];
        }
    }
    
    return components.count;
}

- (NSArray *)listOfDays {
    // no assumption of sort order
    NSMutableArray *components = [NSMutableArray arrayWithCapacity:self.items.count];
    
    for (NSDictionary *item in self.items) {
        NSDateComponents *dc = [self componentsOfDate:item[@"date"]];
        __block BOOL isInList = NO;
        [components enumerateObjectsUsingBlock:^(NSDateComponents *comp, NSUInteger idx, BOOL *stop) {
            if (comp.day == dc.day && comp.month == dc.month && comp.year == dc.year) {
                isInList = YES;
                *stop = YES;
            }
        }];
        if (isInList == NO) {
            [components addObject:dc];
        }
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    __block NSMutableArray *dates = [NSMutableArray arrayWithCapacity:components.count];
    [components enumerateObjectsUsingBlock:^(NSDateComponents *dc, NSUInteger idx, BOOL *stop) {
        NSDate *date = [cal dateFromComponents:dc];
        [dates addObject:date];
    }];
    
    return dates;
}

- (NSInteger)numberOfItemsInDay:(NSDate *)day {
    // no assumption of sort order
    __block NSInteger count = 0;
    NSDateComponents *dc = [self componentsOfDate:day];
    
    [self.items enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        NSDateComponents *comp = [self componentsOfDate:item[@"date"]];
        if (comp.day == dc.day && comp.month == dc.month && comp.year == dc.year) {
            count++;
        }
    }];
    
    return count;
}

- (NSArray *)itemsInDay:(NSDate *)day {
    // no assumption of sort order
    NSDateComponents *dc = [self componentsOfDate:day];
    __block NSMutableArray *dailyItems = [NSMutableArray array];
    
    [self.items enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        NSDateComponents *comp = [self componentsOfDate:item[@"date"]];
        if (comp.day == dc.day && comp.month == dc.month && comp.year == dc.year) {
            [dailyItems addObject:item];
        }
    }];
    
    return dailyItems;
}


#pragma mark - Application Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self loadItems];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
