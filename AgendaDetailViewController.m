//
//  AgendaDetailViewController.m
//  AjaxAgendaApp
//
//  Created by Dylan Bartels on 28/05/14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "AgendaDetailViewController.h"

@interface AgendaDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *DatumLabel;

@property (readwrite, nonatomic) NSMutableArray *BeginTijd;
@property (weak, nonatomic) IBOutlet UILabel *BeginTijdLabel;

@property (readwrite, nonatomic) NSMutableArray *EindTijd;
@property (weak, nonatomic) IBOutlet UILabel *EindTijdLabel;

@property (readwrite, nonatomic) NSMutableArray *Veld;
@property (weak, nonatomic) IBOutlet UILabel *VeldLabel;

@property (readwrite, nonatomic) NSMutableArray *Spelers;
@property (weak, nonatomic) IBOutlet UITextView *SpelersLabel;

@property (readwrite, nonatomic) NSMutableArray *Oefeningen;
@property (weak, nonatomic) IBOutlet UITextView *OefeningenLabel;

@property (readwrite, nonatomic) NSMutableArray *ExtraInfo;
@property (weak, nonatomic) IBOutlet UITextView *ExtraInfoLabel;

@end

@implementation AgendaDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self currentDate];
    [self dbConnectie];
    [self fillArrayEindTijd];
    [self fillArrayBeginTijd];
    [self fillArrayVeld];
    [self fillArraySpelers];
    [self fillArrayOefeningen];
    [self fillArrayExtraInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------------------
// Database
//----------------------------------------------------------------------------------------------------------


- (void) dbConnectie {
    
    NSString *docsDir;
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
}

//----------------------------------------------------------------------------------------------------------
// Get current Date
//----------------------------------------------------------------------------------------------------------


-(void) currentDate {
    NSString *Datum = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDate"];
    _DatumLabel.text = Datum;
}

//----------------------------------------------------------------------------------------------------------
// Vult array begintijd
//----------------------------------------------------------------------------------------------------------

- (void) fillArrayBeginTijd{
    
    const char *dbpath = [_databasePath UTF8String];
    _BeginTijd =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            NSString *Datum = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDate"];
            
            NSString *querytrainingen_sql = [NSString stringWithFormat:@"Select begin_tijd from trainingen where id = '%d' and datum = '%@'", index, Datum];
            const char *queryBeginDate_stmt = [querytrainingen_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, queryBeginDate_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *beginDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_BeginTijd addObject:beginDate];
                    _BeginTijdLabel.text =[_BeginTijd componentsJoinedByString:@", "];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In begintijd array zitten: %@",_BeginTijd);
}

//----------------------------------------------------------------------------------------------------------
// Vult array eindtijd
//----------------------------------------------------------------------------------------------------------

- (void) fillArrayEindTijd{
    
    const char *dbpath = [_databasePath UTF8String];
    _EindTijd =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            NSString *Datum = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDate"];
            
            NSString *querytrainingen_sql = [NSString stringWithFormat:@"Select eind_tijd from trainingen where id = '%d' and datum = '%@'", index, Datum];
            const char *queryBeginDate_stmt = [querytrainingen_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, queryBeginDate_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *eindDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_EindTijd addObject:eindDate];
                    _EindTijdLabel.text = [_EindTijd componentsJoinedByString:@", "];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In eindtijd array zitten: %@",_EindTijd);
}

//----------------------------------------------------------------------------------------------------------
// Vult array veld
//----------------------------------------------------------------------------------------------------------

- (void) fillArrayVeld{
    
    const char *dbpath = [_databasePath UTF8String];
    _Veld =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            NSString *Datum = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDate"];
            
            NSString *querytrainingen_sql = [NSString stringWithFormat:@"Select veld from trainingen where id = '%d' and datum = '%@'", index, Datum];
            const char *queryBeginDate_stmt = [querytrainingen_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, queryBeginDate_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *veld = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_Veld addObject:veld];
                    _VeldLabel.text =[_Veld componentsJoinedByString:@", "];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In veld array zitten: %@",_Veld);
}

//----------------------------------------------------------------------------------------------------------
// Vult array spelers
//----------------------------------------------------------------------------------------------------------

- (void) fillArraySpelers{
    
    const char *dbpath = [_databasePath UTF8String];
    _Spelers =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            NSString *Datum = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDate"];
            
            NSString *querytrainingen_sql = [NSString stringWithFormat:@"Select spelers from trainingen where id = '%d' and datum = '%@'", index, Datum];
            const char *queryBeginDate_stmt = [querytrainingen_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, queryBeginDate_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *spelers = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_Spelers addObject:spelers];
                    _SpelersLabel.text =[_Spelers componentsJoinedByString:@", "];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In spelers array zitten: %@",_Spelers);
}

//----------------------------------------------------------------------------------------------------------
// Vult array oefeningen
//----------------------------------------------------------------------------------------------------------

- (void) fillArrayOefeningen{
    
    const char *dbpath = [_databasePath UTF8String];
    _Oefeningen =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            NSString *Datum = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDate"];
            
            NSString *querytrainingen_sql = [NSString stringWithFormat:@"Select soort_training from trainingen where id = '%d' and datum = '%@'", index, Datum];
            const char *queryBeginDate_stmt = [querytrainingen_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, queryBeginDate_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *oefeningen = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_Oefeningen addObject:oefeningen];
                    _OefeningenLabel.text =[_Oefeningen componentsJoinedByString:@", "];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In oefeningen array zitten: %@",_Oefeningen);
}

//----------------------------------------------------------------------------------------------------------
// Vult array oefeningen
//----------------------------------------------------------------------------------------------------------

- (void) fillArrayExtraInfo{
    
    const char *dbpath = [_databasePath UTF8String];
    _ExtraInfo =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            NSString *Datum = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDate"];
            
            NSString *querytrainingen_sql = [NSString stringWithFormat:@"Select extra_info from trainingen where id = '%d' and datum = '%@'", index, Datum];
            const char *queryBeginDate_stmt = [querytrainingen_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, queryBeginDate_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *extra_info = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_ExtraInfo addObject:extra_info];
                    _ExtraInfoLabel.text =[_ExtraInfo componentsJoinedByString:@", "];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In extra info array zitten: %@",_ExtraInfo);
}

//----------------------------------------------------------------------------------------------------------
// Article count
//----------------------------------------------------------------------------------------------------------

- (int) GetArticlesCount

{
    int count = 0;
    if (sqlite3_open([_databasePath UTF8String], &_ajaxtrainingDB) == SQLITE_OK)
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
              
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
