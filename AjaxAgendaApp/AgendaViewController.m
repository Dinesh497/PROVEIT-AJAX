//
//  AgendaViewController.m
//  AjaxAgendaApp
//
//  Created by Dylan Bartels on 13/05/14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "AgendaViewController.h"
#import "DSLCalendarView.h"


@interface AgendaViewController () <DSLCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet DSLCalendarView *calendarView;
@property (readwrite, nonatomic) NSMutableArray *Trainingen;
@property NSMutableArray *selectedAppointment;
@property NSDateFormatter *dateFormatter;

@end

@implementation AgendaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
    [_dateFormatter setLocale:[NSLocale currentLocale]];
    
    _TrainingenTableView.dataSource = self;
    _TrainingenTableView.delegate =  self;
    
    [self dbConnectie];
    self.calendarView.delegate = self;
}

//----------------------------------------------------------------------------------------------------------
// Database
//----------------------------------------------------------------------------------------------------------


- (void) dbConnectie {
    
   /* NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    _databasePath = [[NSBundle mainBundle]
                     pathForResource:@"ajaxtraining" ofType:@"sqlite" ];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:_databasePath] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            " CREATE TABLE IF NOT EXISTS PLAYERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TEAM TEXT, NAME TEXT, TEXT1 TEXT, TEXT2 TEXT, TEXT3 TEXT, TEXT4 TEXT)";
            
            if (sqlite3_exec(_ajaxtrainingDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            sqlite3_close(_ajaxtrainingDB);
        }
        else
        {
            NSLog(@"Failed to open/create database");
        }
    }
    */
    
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _dbPath = [docPath stringByAppendingPathComponent:@"ajaxtraining.sqlite"];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Check if the database is existed.
    if(![fm fileExistsAtPath:_dbPath])
    {
        // If database is not existed, copy from the database template in the bundle
        NSString* dbTemplatePath = [[NSBundle mainBundle] pathForResource:@"ajaxtraining" ofType:@"sqlite"];
        NSError* error = nil;
        [fm copyItemAtPath:dbTemplatePath toPath:_dbPath error:&error];
        NSLog(@"DB is copied.");
        if(error){
            NSLog(@"can't copy db.");
        }
    }

}

//----------------------------------------------------------------------------------------------------------
// Get Trainingen array
//----------------------------------------------------------------------------------------------------------

- (void) fillArrays:(NSString *)selectedDate {
    
    const char *dbpath = [_dbPath UTF8String];
    _Trainingen =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            
            NSString *querytrainingen_sql = [NSString stringWithFormat:@"Select begin_tijd from trainingen where id = '%d' and datum = '%@'", index, selectedDate];
            const char *queryBeginDate_stmt = [querytrainingen_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, queryBeginDate_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *beginDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_Trainingen addObject:beginDate];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In trainingen array zitten: %@",_Trainingen);
    [_TrainingenTableView reloadData];
}

- (int) GetArticlesCount

{
    int count = 0;
    if (sqlite3_open([_dbPath UTF8String], &_ajaxtrainingDB) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT COUNT(*) FROM trainingen";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(_ajaxtrainingDB, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_ajaxtrainingDB) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(_ajaxtrainingDB);
    }
    
    return count;
}

//----------------------------------------------------------------------------------------------------------
// UITableview methodes
//----------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_Trainingen count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_TrainingenTableView dequeueReusableCellWithIdentifier:@"TrainingCell"];
    cell.textLabel.text = [_Trainingen objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_TrainingenTableView cellForRowAtIndexPath:indexPath];
    NSString *selectedDate = cell.textLabel.text;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:selectedDate forKey:@"StringSelectedDate"];
}

//----------------------------------------------------------------------------------------------------------
// DSLCalendarViewDelegate methods
//----------------------------------------------------------------------------------------------------------

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSString *selectedDate = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)range.startDay.year, (long)range.startDay.month, (long)range.startDay.day];
        
        NSDate *convertDate = [_dateFormatter dateFromString:selectedDate];
        selectedDate = [_dateFormatter stringFromDate:convertDate];
        
        NSLog(@"%@",selectedDate);
        
        //Maakt een userDefault voor de selectedDate
        [[NSUserDefaults standardUserDefaults] setObject:selectedDate forKey:@"selectedDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Vul array elke keer met de geselecteerde datum
        [self fillArrays:(selectedDate)];
    }
    else {
        NSLog(@"No selection");
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (YES) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

