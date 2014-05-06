MNCalendarView
==============

MNCalendarView is a customizable calendar component backed by UICollectionView.

## Basic Usage

```objective-c
MNCalendarView *calendarView = [[MNCalendarView alloc] initWithFrame:self.view.bounds];
calendarView.selectedDate = [NSDate date];
calendarView.delegate = self;
```

## Example

<img src="https://github.com/min/MNCalendarView/raw/master/Documentation/Default@2x.png" alt="Calendar" width="320px"/>



## Usage of GIT branching

Nice example and good reference sheet.

    http://nvie.com/posts/a-successful-git-branching-model/
    

## VC Usage
    See VCMasterViewController.m and VCCalendarView.h

```objective-c
VCCalendarView *cv = [VCCalendarView newCalendarViewDisplayedOver:self forDates:dates];
cv.delegate = self;
```

## Callbacks

### MN Native

    - (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
    - (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date;

### VC Added

    - (void)calendarView:(VCCalendarView *)calendarView selectDates:(NSArray *)dates;
    - (void)calendarView:(VCCalendarView *)calendarView filterOnDates:(NSArray *)dates;




# TO DO

0. [x] Order calendar backward
1. [ ] Display Calendar when table heading is cicked
2. [x] restrict calendar to used dates
3. [x] disable unused dates
4. [ ] provide multi-day/week selection
5. [ ] select properly in example
6. [ ] filter properly in example
7. [ ] present info on what is currently being filtered
8. [ ] provide "clear filter"
9. [x] don't display pad dates from other months
10.[ ] don't display dates after today
