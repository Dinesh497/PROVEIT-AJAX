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

    //dylan 
    //Database
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    _databasePath = [[NSBundle mainBundle]
                     pathForResource:@"ajaxtraining1" ofType:@"db" ];
    NSLog(@" pak ik wel de juiste DB %@", _databasePath);
    
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
        } else {
         _status.text = @"Failed to open/create database";
        }
    }
    
    // Fill the arrays


   //_Players = [[NSMutableArray alloc] initWithObjects:@"Jan Groen", @"Jan Blauw", @"Dirk", @"Henk", @"Klaas", @"Joop", @"Hein", @"Dinesh", @"Johan", @"Anass", nil];
    
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    NSString *queryplayersa1_sql = [NSString stringWithFormat:
                                    @"Select name from players where id = '1'"];
    _Players =[[NSMutableArray alloc] init];

    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        const char *querya1_stmt = [queryplayersa1_sql UTF8String];
        
         sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            /*for (int index = 0; sqlite3_step(statement) == SQLITE_ROW ; index++) {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [_Players addObject:name];
            }*/
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSLog(@"PLayer op id 1 in DB %@", name);
                [_Players addObject:name];
                
            }else{
                NSLog(@"niet gelukt");
            }
            
            }
        sqlite3_finalize(statement);
        }
    sqlite3_close(_ajaxtrainingDB);
    
   // _Players = [[NSMutableArray alloc] initWithContentsOfFile:Playersa1];
    

    // _Players = [[NSMutableArray alloc] initWithObjects:@"Jan Groen", @"Jan Blauw", @"Dirk", @"Henk", @"Klaas", @"Joop", @"Hein", @"Dinesh", @"Johan", @"Anass", nil];
    
    //_Players = [[NSMutableArray alloc] initWithContentsOfFile:selectplayers_sql];

    _Teams = [[NSMutableArray alloc] initWithObjects:@"Jongens A1", @"Jongens A2", @"Jongens B1", @"Jongens C1", @"Jongens C2", nil];
    
    // make arrays alphabetic
    
    
    // define selectedplayers array
   // _SelectedPlayers = [[NSMutableArray alloc] init];
    
    // Set the searchbar invisible at start
    //[_SelectPlayerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    // test
    NSLog(@"In players array zitten: %@",_Players);
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
            return [_Teams count];
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
            // Looking at teams list
            cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"TeamCell"];
            cell.textLabel.text = [_Teams objectAtIndex:indexPath.row];
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
    if(_SegmentController.selectedSegmentIndex == 0){
        
        // Selecting a player
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            // The player is already selected
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            
            NSString *selectingPlayer = [_SelectPlayerTable cellForRowAtIndexPath:indexPath].textLabel.text;
            
            NSInteger indexOfPlayer = [_SelectedPlayers indexOfObject:selectingPlayer];
            [_SelectedPlayers removeObjectAtIndex:indexOfPlayer];
            
            // test: NSLog(@"SelectedPlayers bevat: %@", _SelectedPlayers);
            
        }else{
            // The player is not selected
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            
            NSString *selectingPlayer = [_SelectPlayerTable cellForRowAtIndexPath:indexPath].textLabel.text;
            [_SelectedPlayers addObject:selectingPlayer];
            
        }
        } else{
            // Selecting a team
        }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
