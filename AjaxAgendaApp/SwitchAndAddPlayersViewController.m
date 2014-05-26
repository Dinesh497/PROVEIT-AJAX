//
//  SwitchAndAddPlayersViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 26-05-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "SwitchAndAddPlayersViewController.h"

@interface SwitchAndAddPlayersViewController ()

@property NSMutableArray *Teams;
@property NSMutableArray *PlayersSelectedTeam;

@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) sqlite3 *ajaxtrainingDB;

@property BOOL selectedATeam;

@end

@implementation SwitchAndAddPlayersViewController

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
    _PlayersTableView.layer.cornerRadius = 10;
    
    [self dbConnectie];
    [self fillTeamArrays];
    
    _PlayersTableView.delegate   = self;
    _PlayersTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------------------
// UITableview
//----------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedATeam) {
        return [_PlayersSelectedTeam count];
    } else{
        return [_Teams count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (_PlayersSelectedTeam) {
        cell = [_PlayersTableView dequeueReusableCellWithIdentifier:@"PlayersCell"];
        cell.textLabel.text = [_Teams objectAtIndex:indexPath.row];
    } else{
        cell = [_PlayersTableView dequeueReusableCellWithIdentifier:@"ChooseTeamCell"];
        cell.textLabel.text = [_Teams objectAtIndex:indexPath.row];
    }
    
    return cell;
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
                     pathForResource:@"ajaxtraining1" ofType:@"db" ];
    
    // NSLog(@" pak ik wel de juiste DB %@", _databasePath);
    
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

- (void) fillTeamArrays {
    
    const char *dbpath = [_databasePath UTF8String];
    _Teams =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            
            NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select team from players where id = '%d'", index];
            const char *querya1_stmt = [queryplayersa1_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *team = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    if ( [_Teams containsObject: team] ) {
                        // do found
                        // Nothing to do here
                    } else {
                        // do not found
                        [_Teams addObject:team];
                    }
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In Teams array zitten: %@",_Teams);
}

- (void) fillSelectedTeamArraywithTeamName:(NSString*)TeamName {
    
    const char *dbpath = [_databasePath UTF8String];
    _PlayersSelectedTeam =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            
            NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select name from players where team = '%@' and id = '%d'", TeamName, index];
            const char *querya1_stmt = [queryplayersa1_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *player = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_PlayersSelectedTeam addObject:player];
                    
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In selectingTeam array zitten: %@",_PlayersSelectedTeam);
}

- (int) GetArticlesCount
{
    int count = 0;
    if (sqlite3_open([_databasePath UTF8String], &_ajaxtrainingDB) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT COUNT(*) FROM players";
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
