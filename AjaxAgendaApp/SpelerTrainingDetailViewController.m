//
//  SpelerTrainingDetailViewController.m
//  AjaxAgendaApp
//
//  Created by Dinesh Bhagwandin on 09-07-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "SpelerTrainingDetailViewController.h"

@interface SpelerTrainingDetailViewController ()

@property (strong, nonatomic) NSString  *dbPath;
@property (strong, nonatomic) NSString  *name;
@property (nonatomic) sqlite3           *ajaxtrainingDB;

@property NSString                      *Player;
@property NSDate                        *BeginDate;
@property NSDate                        *EndDate;

@property NSMutableArray                *Trainingen;
@property NSMutableArray                *CorrectDates;
@property NSMutableArray                *IdCorrectDates;
@property NSMutableArray                *PlayersFromDates;
@property NSMutableArray                *FinalIdDates;

@property NSDateFormatter               *dateFormatter;

@end

@implementation SpelerTrainingDetailViewController

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
    // Do any additional setup after loading the view.
    
    _Frame.layer.cornerRadius = 10;
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
    [_dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _Player     = [defaults objectForKey:@"Playertrainingen"];
    _BeginDate  = [[defaults objectForKey:@"BeginDatePlayer"]   dateByAddingTimeInterval: -60*60*24];
    _EndDate    = [[defaults objectForKey:@"EndDatePlayer"]     dateByAddingTimeInterval:  60*60*24];
    
    _PlayersFromDates =[[NSMutableArray alloc] init];
    _IdCorrectDates =[[NSMutableArray alloc] init];
    _FinalIdDates =[[NSMutableArray alloc] init];
    
    [self dbConnectie];
    [self fillArrays];
    
}




//----------------------------------------------------------------------------------------------------------
// Database
//----------------------------------------------------------------------------------------------------------

- (void) dbConnectie {
    
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
        // NSLog(@"DB is copied.");
        if(error){
            NSLog(@"can't copy db.");
        }
    }
    
}

- (id)init {
    if ((self = [super init])) {
        NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* dbPath = [docPath stringByAppendingPathComponent:@"ajaxtraining.sqlite"];
        
        if (sqlite3_open([dbPath UTF8String], &_ajaxtrainingDB) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void) fillArrays {
    
    const char *dbpath = [_dbPath UTF8String];
    _Trainingen =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            
            NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select datum from trainingen where id = '%d'", index];
            const char *querya1_stmt = [queryplayersa1_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    if (![_Trainingen containsObject:name]) {
                        [_Trainingen addObject:name];
                    }
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    
    [_Trainingen sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    _CorrectDates =[[NSMutableArray alloc] init];
    
    for (int index = 0; index < [_Trainingen count];  index++) {
        
        NSString            *Stringdate      = [_Trainingen objectAtIndex:index];
        NSDate              *Date            = [_dateFormatter dateFromString:Stringdate];
        NSComparisonResult  resultBeginDate  = [_BeginDate compare:Date];
        NSComparisonResult  resultEndDate    = [_EndDate compare:Date];
        
        if ( (resultBeginDate==NSOrderedSame || resultBeginDate==NSOrderedAscending) && (resultEndDate==NSOrderedSame || resultEndDate==NSOrderedDescending)) {
            [_CorrectDates addObject:Stringdate];
        }
        
    }
    
    // NSLog(@"In CorrectDates array zitten: %@",_CorrectDates);
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 0; index < [_CorrectDates count]; index++) {
                for (int index2 = 1; index2 <= rows; index2++) {
                NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select id from trainingen where datum = '%@' and id = '%d'", [_CorrectDates objectAtIndex:index], index2];
                const char *querya1_stmt = [queryplayersa1_sql UTF8String];
                sqlite3_stmt *statement;
            
                if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                    if (sqlite3_step(statement) == SQLITE_ROW){
                        NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                        [_IdCorrectDates addObject:name];
                    }
                    sqlite3_finalize(statement);
                }
            }
            
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    
    NSLog(@"In IdCorrectDates array zitten: %@", _IdCorrectDates);
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 0; index < [_IdCorrectDates count]; index++) {
            
                NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select spelers from trainingen where id = '%@'",[_IdCorrectDates objectAtIndex:index]];
                const char *querya1_stmt = [queryplayersa1_sql UTF8String];
                sqlite3_stmt *statement;
                
                if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                    if (sqlite3_step(statement) == SQLITE_ROW){
                        NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                        [_PlayersFromDates addObject:name];
                    }
                    sqlite3_finalize(statement);
                
            }
            
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    
    NSLog(@"In Players array zitten: %@", _PlayersFromDates);
    
    for (int index = 0; index < [_PlayersFromDates count]; index++) {
        
        if ([[_PlayersFromDates objectAtIndex:index] rangeOfString:_Player].location != NSNotFound ) {
            [_FinalIdDates addObject:[_IdCorrectDates objectAtIndex:index]];
        }
    }
    
    NSLog(@"In TrainingDates array zitten: %@", _FinalIdDates);
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
// Xcode
//----------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
