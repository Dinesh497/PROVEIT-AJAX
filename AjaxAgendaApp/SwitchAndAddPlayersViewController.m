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

@property (strong, nonatomic) NSString *dbPath;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) sqlite3 *ajaxtrainingDB;

@property BOOL selectedATeam;
@property NSString *selectedTeam;

@property BOOL choosingTeam;
@property NSString *editingPlayer;

@property BOOL AddingPlayer;
@property UITextField *NameNewPlayerTextfield;

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
<<<<<<< HEAD
=======

>>>>>>> FETCH_HEAD
    
    _PlayersTableView.delegate   = self;
    _PlayersTableView.dataSource = self;
    
    [_AddPlayerButton setEnabled:NO];
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
    if (_choosingTeam) {
        return [_Teams count];
    } else{
        if (_selectedATeam) {
            if (_AddingPlayer) {
                return ([_PlayersSelectedTeam count] + 2);
            }else{
                return ([_PlayersSelectedTeam count] + 1);
            }
        } else{
            return [_Teams count];
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (_choosingTeam) {
        cell = [_PlayersTableView dequeueReusableCellWithIdentifier:@"selectTeamCell"];
        cell.textLabel.text = [_Teams objectAtIndex:indexPath.row];
    } else{
        if (_selectedATeam) {
            // Team geselecteerd
            if (indexPath.row == 0) {
                cell = [_PlayersTableView dequeueReusableCellWithIdentifier:@"BackCell"];
                NSString *team = [NSString stringWithFormat:@"Jongens %@", _selectedTeam];
                cell.textLabel.text = team;
                cell.textLabel.textColor = [UIColor lightGrayColor];
            
            } else {
                if (_AddingPlayer) {
                    if (indexPath.row == 1) {
                        cell = [_PlayersTableView dequeueReusableCellWithIdentifier:@"AddPlayerCell"];
                        _NameNewPlayerTextfield = (UITextField*)[cell viewWithTag:9];
                    } else{
                        cell = [_PlayersTableView dequeueReusableCellWithIdentifier:@"PlayersCell"];
                        cell.textLabel.text = [_PlayersSelectedTeam objectAtIndex:(indexPath.row - 2)];
                    }
                } else{
                    cell = [_PlayersTableView dequeueReusableCellWithIdentifier:@"PlayersCell"];
                    cell.textLabel.text = [_PlayersSelectedTeam objectAtIndex:(indexPath.row - 1)];
                }
            }
        } else{
            cell = [_PlayersTableView dequeueReusableCellWithIdentifier:@"ChooseTeamCell"];
            cell.textLabel.text = [_Teams objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_PlayersTableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 0) {
        // Team cell selected
        
        NSString *selectingTeam = cell.textLabel.text;
        _selectedTeam = selectingTeam;
        [self fillSelectedTeamArraywithTeamName:selectingTeam];
        _selectedATeam = YES;
        [_AddPlayerButton setEnabled:YES];
        [_PlayersTableView reloadData];
        
    }
    if (cell.tag == 1) {
        // Player cell selected
        
    }
    if (cell.tag == 2) {
        // choose team cell selected
        NSString *teamName = cell.textLabel.text;
        [self wijzigTeam:teamName];
    }
    
    [_PlayersTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_AddingPlayer) {
        if (indexPath.row == 1) {
            return 88;
        }else{
            return 44;
        }
    } else{
        return 44;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [_PlayersTableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 1) {
        return UITableViewCellEditingStyleDelete;
    } else{
        return UITableViewCellEditingStyleDelete;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [_PlayersTableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 1) {
        return YES;
    } else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [_PlayersTableView cellForRowAtIndexPath:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete button pressed
        _editingPlayer = cell.textLabel.text;
        // NSLog(@"Wijzig: %@", _editingPlayer);
        [self showWijzigMenu];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Wijzig";
}

- (IBAction)BackButtonPressed:(id)sender {
    [_AddPlayerButton setEnabled:NO];
    _selectedATeam = NO;
    [_PlayersTableView reloadData];
}

- (IBAction)AddPlayer:(id)sender {
    _AddingPlayer = YES;
    [_PlayersTableView reloadData];
}

- (IBAction)PlayerAdded:(id)sender {
    
    NSString *NameNewPlayer = _NameNewPlayerTextfield.text;
    _NameNewPlayerTextfield.text = @"";
    
    if(sqlite3_open([_dbPath UTF8String], &_ajaxtrainingDB) == SQLITE_OK) {
        static sqlite3_stmt *compiledStatement;
        char* errmsg;
        int number = [self GetArticlesCount] + 1;
        NSLog(@"%@ wordt toegevoegd op positie %d", NameNewPlayer, number);
        
        sqlite3_exec(_ajaxtrainingDB, [[NSString stringWithFormat:@"INSERT INTO players (name, team) values ('%@', '%@')", NameNewPlayer, _selectedTeam] UTF8String], NULL, NULL, &errmsg);
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(_ajaxtrainingDB);
    
    [self fillSelectedTeamArraywithTeamName:_selectedTeam];
    _AddingPlayer = NO;
    [_PlayersTableView reloadData];
}

- (IBAction)StopAddPlayer:(id)sender {
    _AddingPlayer = NO;
    [_PlayersTableView reloadData];
}

- (IBAction)ReturnButtonName:(id)sender {
    [sender resignFirstResponder];
}

- (void)showWijzigMenu{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Annuleer" destructiveButtonTitle:nil otherButtonTitles:@"Wijzig team", @"Verwijder speler", nil];
    
    [actionSheet showInView:self.view];
}

//----------------------------------------------------------------------------------------------------------
// Actionsheet
//----------------------------------------------------------------------------------------------------------

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // Wijzig team
        _choosingTeam = YES;
        [_PlayersTableView reloadData];
    }
    if (buttonIndex == 1) {
        // Verwijder speler
        
        if(sqlite3_open([_dbPath UTF8String], &_ajaxtrainingDB) == SQLITE_OK) {
            static sqlite3_stmt *compiledStatement;
            sqlite3_exec(_ajaxtrainingDB, [[NSString stringWithFormat:@"delete from players where name = '%@'", _editingPlayer] UTF8String], NULL, NULL, NULL);
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    [self fillSelectedTeamArraywithTeamName:_selectedTeam];
    [_PlayersTableView reloadData];
}

- (void) wijzigTeam:(NSString*) team{
    
    const char *dbpath = [_dbPath UTF8String];
    sqlite3_stmt *updateStmt;
    if(sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
    NSString *queryplayersa1_sql = [NSString stringWithFormat:@"UPDATE players SET team = '%@' WHERE name ='%@'", team, _editingPlayer];
        const char *querya1_stmt = [queryplayersa1_sql UTF8String];
        if(sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &updateStmt, NULL) == SQLITE_OK)
            NSLog(@"Error while creating update statement. %s", sqlite3_errmsg(_ajaxtrainingDB));
            NSLog(@"wat doe ik nou eigenlijk %@", team);
    }
    
    char* errmsg;
    sqlite3_exec(_ajaxtrainingDB, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSLog(@"Error while updating. %s", sqlite3_errmsg(_ajaxtrainingDB));
    sqlite3_finalize(updateStmt);
    sqlite3_close(_ajaxtrainingDB);
    
    _choosingTeam = NO;
    [self fillSelectedTeamArraywithTeamName:_selectedTeam];
    [_PlayersTableView reloadData];
}

//----------------------------------------------------------------------------------------------------------
// Database
//----------------------------------------------------------------------------------------------------------

- (void) dbConnectie {
    
   // NSString *docsDir;
   // NSArray *dirPaths;
    
  //  dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
  //  docsDir = dirPaths[0];
    
   // _databasePath = [[NSBundle mainBundle]
     //                pathForResource:@"ajaxtraining1" ofType:@"db" ];
    
    // NSLog(@" pak ik wel de juiste DB %@", _databasePath);
    
   // NSFileManager *filemgr = [NSFileManager defaultManager];
    
    /*if ([filemgr fileExistsAtPath:_databasePath] == NO)
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
    }*/
    
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

- (void) fillTeamArrays {
    
    const char *dbpath = [_dbPath UTF8String];
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
    
    const char *dbpath = [_dbPath UTF8String];
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
    if (sqlite3_open([_dbPath UTF8String], &_ajaxtrainingDB) == SQLITE_OK)
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
