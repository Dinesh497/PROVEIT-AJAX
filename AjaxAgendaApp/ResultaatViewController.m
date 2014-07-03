//
//  ResultaatViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 03-05-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "ResultaatViewController.h"

@interface ResultaatViewController ()

@property (nonatomic) sqlite3 *ajaxtrainingDB;
@property (strong, nonatomic) NSString *dbPath;

@property NSString *datum;
@property NSString *begin_tijd;
@property NSString *eind_tijd;
@property NSString *veld;
@property NSString *soort_training;
@property NSString *subcat_veld;
@property NSString *extra_info;
@property NSString *spelersString;

@end

@implementation ResultaatViewController

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
    
    // Category
    NSString *Category = [defaults objectForKey:@"Category"];
    [_categoryLabel setText:Category];
    
    _soort_training = Category;
    
    // Players
    NSMutableArray *PlayersArray = [defaults objectForKey:@"PlayersArray"];
    NSString *PlayersString = [PlayersArray componentsJoinedByString: @"\n"];
    [_spelers setText:PlayersString];
    
    _spelersString = PlayersString;
    
    
    // Spelers text view
    
    CGRect spelerframe = _spelers.frame;
    spelerframe.size.height = _spelers.contentSize.height;
    _spelers.frame = spelerframe;
    
    CGSize spelersSize = [_spelers sizeThatFits:_spelers.frame.size];
    _spelersHeightConstraint.constant = spelersSize.height;
    
    
    // Oefeningen
    
    UILabel *OefeningenHeader = [[UILabel alloc] init];
    [OefeningenHeader setText:@"Oefeningen:"];
    
    UITextView *OefeningenText = [[UITextView alloc] init];
    [OefeningenText setSelectable:NO];
    [OefeningenText setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    CGSize oefeningenSize;
    
    if ([Category isEqualToString:@"Veld training"]) {
        
        NSMutableArray *OefeningenArray = [defaults objectForKey:@"SelectedOefeningenArray"];
        NSString *OefeningenString = [OefeningenArray componentsJoinedByString: @"\n"];
        [OefeningenText setText:OefeningenString];
        
        _subcat_veld = OefeningenString;
        
        CGRect oefeningenframe = OefeningenText.frame;
        oefeningenframe.size.height = OefeningenText.contentSize.height;
        OefeningenText.frame = spelerframe;
        
        oefeningenSize = [OefeningenText sizeThatFits:OefeningenText.frame.size];
        
        [_Resultaten addSubview:OefeningenHeader];
        [_Resultaten addSubview:OefeningenText];
        
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
    [ExtraInfoText setFont:[UIFont fontWithName:@"System" size:14.0]];
    [ExtraInfoText setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    CGSize ExtraInfoSize;
    
    if ([Category isEqualToString:@"Veld training"]) {
        
        NSString *ExtraInformation = [defaults objectForKey:@"ExtraInfo"];
        [ExtraInfoText setText:ExtraInformation];
        
        _extra_info = ExtraInformation;
        
        ExtraInfoSize = [ExtraInfoText sizeThatFits:ExtraInfoText.frame.size];
        
        [_Resultaten addSubview:ExtraInfoHeader];
        [_Resultaten addSubview:ExtraInfoText];
        
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
        [_Resultaten setFrame:CGRectMake(0, 0, _frame.frame.size.width, 365)];
    } else{
        [_Resultaten setFrame:CGRectMake(0, 0, _frame.frame.size.width, heightResultaten)];
    }
    
    [scroll addSubview:_Resultaten];
    
    
    // Buttons frame
    [_Resultaten2 setFrame:CGRectMake(0, _Resultaten.frame.size.height, _frame.frame.size.width, 40)];
    [scroll addSubview:_Resultaten2];
    
    scroll.contentSize = CGSizeMake(_Resultaten.frame.size.width, _Resultaten.frame.size.height + _Resultaten2.frame.size.height);
    [_frame addSubview:scroll];
    
    
    // Date
    NSDate *theDate     = [defaults objectForKey:@"theDate"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *theDateString = [dateFormatter stringFromDate:theDate];
    [_dateLabel setText:theDateString];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    
    dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
    [dateFormatter2 setLocale:[NSLocale currentLocale]];
    
    _datum = [dateFormatter2 stringFromDate:theDate];
    
    // Time
    NSDate *beginTime   = [defaults objectForKey:@"BeginTime"];
    NSDate *endTime     = [defaults objectForKey:@"EndTime"];
    
    NSDateFormatter *timeFormatter;
    
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    [timeFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *beginTimeString   = [timeFormatter stringFromDate:beginTime];
    NSString *endTimeString     = [timeFormatter stringFromDate:endTime];
    
    [_BeginTime setText:beginTimeString];
    [_endTime setText:endTimeString];
    
    _begin_tijd = beginTimeString;
    _eind_tijd = endTimeString;
    
    // Location
    NSString *Location = [defaults objectForKey:@"Location"];
    [_locationLabel setText:Location];
    
    _veld = Location;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)VoegToeButtonPressed:(id)sender {
    
    int number = [self GetArticlesCount] + 1;
    
    if(sqlite3_open([_dbPath UTF8String], &_ajaxtrainingDB) == SQLITE_OK) {
        static sqlite3_stmt *compiledStatement;
        
        sqlite3_exec(_ajaxtrainingDB, [[NSString stringWithFormat:@"INSERT into trainingen (id, datum, begin_tijd, eind_tijd, veld, soort_training, subcat_veld, extra_info, spelers) values ('%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                                        number, _datum, _begin_tijd, _eind_tijd, _veld, _soort_training, _subcat_veld,
                                        _extra_info, _spelersString] UTF8String], NULL, NULL, NULL);
        
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(_ajaxtrainingDB);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)CancelButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
}

@end
