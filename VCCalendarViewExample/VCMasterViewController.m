//
//  VCMasterViewController.m
//  VCCalendarViewExample
//
//  Created by Bill Shirley on 4/29/14.
//  Copyright (c) 2014 min. All rights reserved.
//

#import "VCMasterViewController.h"
#import "VCDetailViewController.h"
#import "VCAppDelegate.h"
#import "NSDate+MNAdditions.h"
#import "VCCalendarView.h"

@interface VCMasterViewController () <VCCalendarViewDelegate>
@end

@implementation VCMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    UIBarButtonItem *calButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Calendar_Icon"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(toggleCalendar:)];
    
    self.navigationItem.rightBarButtonItems = @[addButton, calButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
    [appDelegate addRandomData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)toggleCalendar:(id)sender {
    // show calendar
    VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
    NSMutableArray *dates = [NSMutableArray array];
    [appDelegate.items enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        NSDate *dateForItem = item[@"date"];
        NSDate *normalizedDate = [dateForItem mn_beginningOfDay:[NSCalendar currentCalendar]];
        if ([dates indexOfObject:normalizedDate] == NSNotFound) {
            [dates addObject:normalizedDate];
        }
    }];
    
    VCCalendarView *cv = [VCCalendarView newCalendarViewDisplayedOver:self forDates:dates];
    cv.delegate = self;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSDictionary *)itemAtIndexPath:(NSIndexPath *)indexPath {
    VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
    NSArray *dates = appDelegate.listOfDays;
    NSDate *date = dates[indexPath.section];
    NSArray *items = [appDelegate itemsInDay:date];
    NSDictionary *item = items[indexPath.row];
    return item;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
    return appDelegate.numberOfDays;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
    NSArray *dates = appDelegate.listOfDays;
    NSDate *date = dates[section];
    return [appDelegate numberOfItemsInDay:date];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
    NSArray *dates = appDelegate.listOfDays;
    NSDate *date = dates[section];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    return dateString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSArray *dates = appDelegate.listOfDays;
    NSDate *date = dates[indexPath.section];
    NSArray *items = [appDelegate itemsInDay:date];
    NSDictionary *item = items[indexPath.row];
    
    NSString *timeString = [NSDateFormatter localizedStringFromDate:item[@"date"]
                                                          dateStyle:NSDateFormatterNoStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    cell.imageView.image = nil;
    cell.textLabel.text = item[@"subject"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", timeString, item[@"content"]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
        NSDictionary *item = [self itemAtIndexPath:indexPath];
        [appDelegate deleteItem:item];
// TBD: test for deletion of single item in section
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        VCAppDelegate *appDelegate = [VCAppDelegate appDelegate];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *days = appDelegate.listOfDays;
        NSDate *day = days[indexPath.section];
        NSArray *items = [appDelegate itemsInDay:day];
        NSDate *object = items[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
