//
//  SelectSpelersViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 19-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "SelectPlayersViewController.h"

@interface SelectPlayersViewController ()
@property (readwrite, nonatomic) NSMutableArray *Players;
@property (readwrite, nonatomic) NSMutableArray *Teams;

// Search results from search bar
@property NSMutableArray *SearchResultPlayers;
@property NSMutableArray *SearchResultTeams;

// contains the selected players
@property NSMutableArray *SelectedPlayers;

// contains the team that is selected
@property NSMutableArray *SelectedTeam;
@property BOOL selectedATeam;

// Shows when the searchbar is being used
@property BOOL isSearching;

@end

@implementation SelectPlayersViewController

//@synthesize name;

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
    
    _isSearching = NO;
    
    _SelectPlayerTable.delegate = self;
    _SelectPlayerTable.dataSource = self;
    _SelectPlayerTable.layer.cornerRadius = 10;
    
    _SelectPlayersFrame.layer.cornerRadius = 10;
    
    [_SegmentController setSelectedSegmentIndex:1];
    
    [self dbConnectie];
    [self fillArrays];
    [self fillTeamArrays];
    
    _SelectedPlayers = [[NSMutableArray alloc] init];
    
    // Set the searchbar invisible at start
    [_SelectPlayerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
                    _status.text = @"Failed to create table";
                }
                    sqlite3_close(_ajaxtrainingDB);
        }
        else
            {
            _status.text = @"Failed to open/create database";
            }
    }
}

// Fill the arrays

- (void) fillArrays {

    const char *dbpath = [_databasePath UTF8String];
    _Players =[[NSMutableArray alloc] init];

    int rows = [self GetArticlesCount];

    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
        
            NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select name from players where id = '%d'", index];
            const char *querya1_stmt = [queryplayersa1_sql UTF8String];
            sqlite3_stmt *statement;
        
            if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_Players addObject:name];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In players array zitten: %@",_Players);
    
    
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
    _SelectedTeam =[[NSMutableArray alloc] init];
    
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
                    [_SelectedTeam addObject:player];
                    
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In selectingTeam array zitten: %@",_SelectedTeam);
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
// Tableview
//----------------------------------------------------------------------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isSearching){
        if (_SegmentController.selectedSegmentIndex == 0) {
            return [_SearchResultPlayers count];
        } else{
            return [_SearchResultTeams count];
        }
    } else{
        if (_SegmentController.selectedSegmentIndex == 0) {
            return [_Players count];
        } else{
            if (_selectedATeam) {
                return ([_SelectedTeam count] + 1);
            }else{
                return [_Teams count];
            }
        }
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (_isSearching) {
        if (_SegmentController.selectedSegmentIndex == 0) {
            // Searching for a player
            cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"PlayerCell"];
            cell.textLabel.text = [_SearchResultPlayers objectAtIndex:indexPath.row];
        } else{
            // Searching for a team
            cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"TeamCell"];
            cell.textLabel.text = [_SearchResultTeams objectAtIndex:indexPath.row];
        }
        
    } else{
        if (_SegmentController.selectedSegmentIndex == 0) {
            // Looking at players list
            cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"PlayerCell"];
            cell.textLabel.text = [_Players objectAtIndex:indexPath.row];
        } else{
            
            if(_selectedATeam){
                // Looking at players in team list
                if (indexPath.row == 0) {
                    cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"AllReturnCell"];
                }else{
                    cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"PlayerCell"];
                    cell.textLabel.text = [_SelectedTeam objectAtIndex:indexPath.row - 1];
                }
            }else{
                // Looking at teams list
                cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"TeamCell"];
                cell.textLabel.text = [_Teams objectAtIndex:indexPath.row];
            }
        }
    }
    
    // Show if player is already selected or not
    if([_SelectedPlayers containsObject:cell.textLabel.text]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [_SelectPlayerTable cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 0) {
        // Speler cell selected
        
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
            
            // The player is already selected
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSString *selectingPlayer = cell.textLabel.text;
            NSInteger indexOfPlayer = [_SelectedPlayers indexOfObject:selectingPlayer];
            [_SelectedPlayers removeObjectAtIndex:indexOfPlayer];
        }else{
            
            // The player is not selected
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            NSString *selectingPlayer = [_SelectPlayerTable cellForRowAtIndexPath:indexPath].textLabel.text;
            [_SelectedPlayers addObject:selectingPlayer];
        }
        
        NSLog(@"%@", _SelectedPlayers);
    }
    
    if (cell.tag == 1) {
        // Team cell selected
        
        NSString *selectingTeam = cell.textLabel.text;
        [self fillSelectedTeamArraywithTeamName:selectingTeam];
        _selectedATeam = YES;
        [_SelectPlayerTable reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)SelectAllInTeam:(id)sender {
    
    for(int index = 0; index < [_SelectedTeam count]; index++){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(index + 1) inSection:0];
        UITableViewCell *cell = [_SelectPlayerTable cellForRowAtIndexPath:indexPath];
        
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        
            // The player is already selected
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSString *selectingPlayer = cell.textLabel.text;
            NSInteger indexOfPlayer = [_SelectedPlayers indexOfObject:selectingPlayer];
            [_SelectedPlayers removeObjectAtIndex:indexOfPlayer];
        }else{
        
            // The player is not selected
            [_SelectPlayerTable cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            NSString *selectingPlayer = [_SelectPlayerTable cellForRowAtIndexPath:indexPath].textLabel.text;
            [_SelectedPlayers addObject:selectingPlayer];
        }
    }
    
}

- (IBAction)ReturnFromTeam:(id)sender {
    _selectedATeam = NO;
    [_SelectPlayerTable reloadData];
}

//----------------------------------------------------------------------------------------------------------
// SearchBar Controller
//----------------------------------------------------------------------------------------------------------

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // SearchBar selected
    searchBar.showsCancelButton = YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    // Stop searching
    _isSearching = NO;
    [_SelectPlayerTable reloadData];
    _SearchBar.showsCancelButton = NO;
    [_SearchBar setText:@""];
    [_SearchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_SearchBar resignFirstResponder];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText  isEqual: @""]){
        // Nothing typed yet
        _isSearching = NO;
        [_SelectPlayerTable reloadData];
        
    } else{
        
        if (_SegmentController.selectedSegmentIndex == 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
            _SearchResultPlayers = [NSMutableArray arrayWithArray:[_Players filteredArrayUsingPredicate:predicate]];
        } else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
            _SearchResultTeams = [NSMutableArray arrayWithArray:[_Teams filteredArrayUsingPredicate:predicate]];
        }
        
        _isSearching = YES;
        [_SelectPlayerTable reloadData];
    }
}

//----------------------------------------------------------------------------------------------------------
// Segment Controller
//----------------------------------------------------------------------------------------------------------

- (IBAction)SelectedSegmentChanged:(id)sender {
    
    // Als er een keuze in team of speler wordt gemaakt
    
    if (_SegmentController.selectedSegmentIndex == 0) {
        self.navigationItem.title = @"Speler";
        _SearchBar.placeholder = @"Zoek speler";
    } else{
        self.navigationItem.title = @"Teams";
        _SearchBar.placeholder = @"Zoek team";
    }
    
    [_SelectPlayerTable reloadData];
}

//----------------------------------------------------------------------------------------------------------
// Save Data
//----------------------------------------------------------------------------------------------------------

- (IBAction)GereedButtonPressed:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_SelectedPlayers forKey:@"PlayersArray"];
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
