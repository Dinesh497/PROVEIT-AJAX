//
//  SelectSpelersViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 19-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SelectPlayersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *SelectPlayerTable;
@property (weak, nonatomic) IBOutlet UIView *SelectPlayersFrame;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentController;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic) IBOutlet UILabel *status;

- (IBAction)SelectedSegmentChanged:(id)sender;
- (IBAction)GereedButtonPressed:(id)sender;

- (IBAction)SelectAllInTeam:(id)sender;
- (IBAction)ReturnFromTeam:(id)sender;

@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) sqlite3 *ajaxtrainingDB;
@end
