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
    
    _Players = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    _Teams = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
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
        cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"PlayerCell"];
    } else{
        cell = [_SelectPlayerTable dequeueReusableCellWithIdentifier:@"TeamCell"];
    }
    
    return cell;
}

//----------------------------------------------------------------------------------------------------------
// Segment Controller
//----------------------------------------------------------------------------------------------------------

- (IBAction)SelectedSegmentChanged:(id)sender {
    
    if (_SegmentController.selectedSegmentIndex == 0) {
        self.navigationController.title = @"Speler";
    } else{
        self.navigationController.title = @"Teams";
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
