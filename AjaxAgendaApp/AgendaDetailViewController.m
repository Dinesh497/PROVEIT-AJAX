//
//  AgendaDetailViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 07-07-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "AgendaDetailViewController.h"

@interface AgendaDetailViewController ()

@property (nonatomic) sqlite3 *ajaxtrainingDB;
@property (strong, nonatomic) NSString *dbPath;

@property NSString  *selectedDate;
@property NSString  *selectedBeginTime;
@property int       *selectedDateID;

@property NSString *datum;
@property NSString *begin_tijd;
@property NSString *eind_tijd;
@property NSString *veld;
@property NSString *soort_training;
@property NSString *subcat_veld;
@property NSString *extra_info;
@property NSString *spelersString;

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
    // Do any additional setup after loading the view.
    
    [self dbConnectie];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger HeaderHeightSize = 29;
    
    // Haal data op
    _selectedDate = [defaults objectForKey:@"selectedDate"];
    NSLog(@"Datum:      %@", _selectedDate);
    _selectedBeginTime = [defaults objectForKey:@"StringSelectedDate"];
    NSLog(@"Begin tijd: %@", _selectedBeginTime);
    [self getDataFromDatabase];
    
    // Category
    [_CatergorieLabel setText:_soort_training];
    NSString *Category =_soort_training;
    
    // Spelers text view
    
    UITextView *SpelersText = [[UITextView alloc] init];
    [SpelersText setSelectable:NO];
    [SpelersText setScrollEnabled:NO];
    [SpelersText setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    CGSize spelersSize;
    
    NSString *PlayersString = _spelersString;
    [SpelersText setText:PlayersString];
    
    CGRect spelersframe = SpelersText.frame;
    spelersframe.size.height = SpelersText.contentSize.height;
    SpelersText.frame = spelersframe;
    
    spelersSize = [SpelersText sizeThatFits:SpelersText.frame.size];
    
    [_TrainingInfo addSubview:SpelersText];
    
    [SpelersText setFrame:CGRectMake(20, 194, 220, spelersSize.height)];
    
    
    // Oefeningen
    
    UILabel *OefeningenHeader = [[UILabel alloc] init];
    [OefeningenHeader setText:@"Oefeningen:"];
    
    UITextView *OefeningenText = [[UITextView alloc] init];
    [OefeningenText setSelectable:NO];
    [OefeningenText setScrollEnabled:NO];
    [OefeningenText setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    CGSize oefeningenSize;
    
    if ([Category isEqualToString:@"Veld training"]) {
        
        NSString *OefeningenString = _subcat_veld;
        [OefeningenText setText:OefeningenString];
        
        CGRect oefeningenframe = OefeningenText.frame;
        oefeningenframe.size.height = OefeningenText.contentSize.height;
        OefeningenText.frame = oefeningenframe;
        
        oefeningenSize = [OefeningenText sizeThatFits:OefeningenText.frame.size];
        
        [_TrainingInfo addSubview:OefeningenHeader];
        [_TrainingInfo addSubview:OefeningenText];
        
        [OefeningenHeader setFrame:CGRectMake(20, 194 + spelersSize.height + 4, 220, 21)];
        [OefeningenText setFrame:CGRectMake(20, 194 + spelersSize.height + HeaderHeightSize, 220, oefeningenSize.height)];
        
    } else{
        [OefeningenHeader  removeFromSuperview];
        [OefeningenText    removeFromSuperview];
    }
    
    
    // Extra info oefeningen
    
    UILabel *ExtraInfoHeader = [[UILabel alloc] init];
    [ExtraInfoHeader setText:@"Extra informatie:"];
    
    UITextView *ExtraInfoText = [[UITextView alloc] init];
    [ExtraInfoText setSelectable:NO];
    [ExtraInfoText setScrollEnabled:NO];
    [ExtraInfoText setFont:[UIFont fontWithName:@"System" size:14.0]];
    [ExtraInfoText setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    CGSize ExtraInfoSize;
    
    if ([Category isEqualToString:@"Veld training"]) {
        
        NSString *ExtraInformation = _extra_info;
        [ExtraInfoText setText:ExtraInformation];
        
        ExtraInfoSize = [ExtraInfoText sizeThatFits:ExtraInfoText.frame.size];
        
        [_TrainingInfo addSubview:ExtraInfoHeader];
        [_TrainingInfo addSubview:ExtraInfoText];
        
        [ExtraInfoHeader setFrame:CGRectMake(20, 194 + spelersSize.height + oefeningenSize.height + HeaderHeightSize + 4, 220, 36)];
        [ExtraInfoText setFrame:CGRectMake(20, 194 + spelersSize.height + oefeningenSize.height + HeaderHeightSize + HeaderHeightSize, 220, ExtraInfoSize.height)];
        
    } else{
        [ExtraInfoHeader    removeFromSuperview];
        [ExtraInfoText      removeFromSuperview];
    }
    
    // Frame
    _frame.layer.cornerRadius = 10;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _frame.frame.size.width, _frame.frame.size.height)];
    
    scroll.scrollEnabled = YES;
    scroll.layer.cornerRadius = 10;
    scroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    int heightResultaten;
    
    
    // Details frame
    if ([Category isEqualToString:@"Veld training"]) {
        heightResultaten = 194 + spelersSize.height + oefeningenSize.height + ExtraInfoSize.height + HeaderHeightSize + HeaderHeightSize;
    } else{
        heightResultaten = 200 + spelersSize.height;
    }
    
    if (heightResultaten < 365) {
        [_TrainingInfo setFrame:CGRectMake(0, 0, _frame.frame.size.width, 365)];
    } else{
        [_TrainingInfo setFrame:CGRectMake(0, 0, _frame.frame.size.width, heightResultaten)];
    }
    
    [scroll addSubview:_TrainingInfo];
    
    
    // Extra frame
    UIView *ExtraView = [[UIView alloc] init];
    [ExtraView setFrame:CGRectMake(0, _TrainingInfo.frame.size.height, _frame.frame.size.width, 10)];
    [scroll addSubview:ExtraView];
    
    scroll.contentSize = CGSizeMake(_TrainingInfo.frame.size.width, _TrainingInfo.frame.size.height + ExtraView.frame.size.height);
    [_frame addSubview:scroll];
    
    
    // Date
    NSString *theDateString = _selectedDate;
    [_DatumLabel setText:theDateString];
    
    NSString *beginTimeString   = _selectedBeginTime;
    NSString *endTimeString     = _eind_tijd;
    
    [_BeginTijdLabel setText:beginTimeString];
    [_EindTijdLabel setText:endTimeString];
    
    // Location
    NSString *Location = _veld;
    [_LocatieVeldLabel setText:Location];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getDataFromDatabase {
    
    NSString *ID;
    const char *dbpath = [_dbPath UTF8String];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        
        NSString *queryplayersa1_sql;
        sqlite3_stmt *statement;
        const char *querya1_stmt;
        
        // ID
        queryplayersa1_sql = [NSString stringWithFormat:@"SELECT id from trainingen where begin_tijd = '%@' and datum = '%@'", _selectedBeginTime, _selectedDate];
        querya1_stmt = [queryplayersa1_sql UTF8String];
            
        if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
            
        // Eind tijd
        queryplayersa1_sql = [NSString stringWithFormat:@"SELECT eind_tijd from trainingen where id = '%@'", ID];
        querya1_stmt = [queryplayersa1_sql UTF8String];
        
        if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                _eind_tijd = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        
        // Veld
        queryplayersa1_sql = [NSString stringWithFormat:@"SELECT veld from trainingen where id = '%@'", ID];
        querya1_stmt = [queryplayersa1_sql UTF8String];
        
        if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                _veld = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
            
        // Soort training
        queryplayersa1_sql = [NSString stringWithFormat:@"SELECT soort_training from trainingen where id = '%@'", ID];
        querya1_stmt = [queryplayersa1_sql UTF8String];
        
        if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                _soort_training = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
            
        // Subcategorie
        queryplayersa1_sql = [NSString stringWithFormat:@"SELECT subcat_veld from trainingen where id = '%@'", ID];
        querya1_stmt = [queryplayersa1_sql UTF8String];
        
        if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                _subcat_veld = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
            
        // Extra info
        queryplayersa1_sql = [NSString stringWithFormat:@"SELECT extra_info from trainingen where id = '%@'", ID];
        querya1_stmt = [queryplayersa1_sql UTF8String];
        
        if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                _extra_info = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
            
        // Spelers
        queryplayersa1_sql = [NSString stringWithFormat:@"SELECT spelers from trainingen where id = '%@'", ID];
        querya1_stmt = [queryplayersa1_sql UTF8String];
        
        if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                _spelersString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
            
        
        sqlite3_close(_ajaxtrainingDB);
    }
    
    NSLog(@"het ID is: %@", ID);
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
        NSLog(@"DB is copied.");
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
    NSLog(@"het aantal is: ");
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
