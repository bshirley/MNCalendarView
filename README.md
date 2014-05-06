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


## Callbacks

### MN Native

    - (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
    - (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date;

### VC Added

    - (void)calendarView:(VCCalendarView *)calendarView selectDates:(NSArray *)dates;
    - (void)calendarView:(VCCalendarView *)calendarView filterOnDates:(NSArray *)dates;




# TO DO

0. Order now backward
1. Display Calendar when table heading is cicked
2. restrict calendar to used dates
3. disable/cross through unused dates
4. provide multi-day/week selection