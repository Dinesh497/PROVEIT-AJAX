//
//  SelectSpelersViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 19-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface SelectPlayersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *SelectPlayerTable;
@property (weak, nonatomic) IBOutlet UIView *SelectPlayersFrame;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentController;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
- (IBAction)SelectedSegmentChanged:(id)sender;


@end
