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
    
    _SelectPlayerTable.delegate = self;
    _SelectPlayerTable.dataSource = self;
    _SelectPlayerTable.layer.cornerRadius = 10;
    
    _SelectPlayersFrame.layer.cornerRadius = 10;
    
    _Players = [[NSMutableArray alloc] initWithObjects:@"Jan", @"Dirk", @"Henk", @"Klaas", @"Joop", @"Hein", @"Dinesh", @"Johan", @"Anass", nil];
    _Teams = [[NSMutableArray alloc] initWithObjects:@"Jongens A1", @"Jongens A2", @"Jongens B1", @"Jongens C1", @"Jongens C2", nil];
}

//----------------------------------------------------------------------------------------------------------
// Tableview
//----------------------------------------------------------------------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_SegmentController.selectedSegmentIndex == 0) {
        return [_Players count];
    } else{
        return [_Teams count];
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (_SegmentController.selectedSegmentIndex == 0) {
        // Als er naar Spelers wordt gezocht
        cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"PlayerCell"];
        cell.textLabel.text = [_Players objectAtIndex:indexPath.row];
    } else{
        // Als er naar Teams wordt gezocht
        cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"TeamCell"];
        cell.textLabel.text = [_Teams objectAtIndex:indexPath.row];
    }
    
    return cell;
}

//----------------------------------------------------------------------------------------------------------
// SearchBar Controller
//----------------------------------------------------------------------------------------------------------

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _SearchBar.showsCancelButton = NO;
    [_SearchBar resignFirstResponder];
}

- (void) searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
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
