//
//  SelectSpelersViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 19-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "SelectPlayersViewController.h"

@interface SelectPlayersViewController ()
@property NSMutableArray *Players;
@property NSMutableArray *Teams;

// Search results from search bar
@property NSMutableArray *SearchResultPlayers;
@property NSMutableArray *SearchResultTeams;

// Shows when the searchbar is being used
@property BOOL isSearching;

@end

@implementation SelectPlayersViewController

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
    
    // Fill the arrays
    _Players = [[NSMutableArray alloc] initWithObjects:@"Jan", @"Dirk", @"Henk", @"Klaas", @"Joop", @"Hein", @"Dinesh", @"Johan", @"Anass", nil];
    _Teams = [[NSMutableArray alloc] initWithObjects:@"Jongens A1", @"Jongens A2", @"Jongens B1", @"Jongens C1", @"Jongens C2", nil];
    
    // Set the searchbar invisible at start
    [_SelectPlayerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_SegmentController.selectedSegmentIndex == 0){
        // Selecting a player
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        }else{
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
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
    searchBar.showsCancelButton = YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
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
