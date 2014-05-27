//
//  SwitchAndAddPlayersViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 26-05-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SwitchAndAddPlayersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *Frame;
@property (weak, nonatomic) IBOutlet UITableView *PlayersTableView;
- (IBAction)BackButtonPressed:(id)sender;
- (IBAction)AddPlayer:(id)sender;
- (IBAction)PlayerAdded:(id)sender;
- (IBAction)StopAddPlayer:(id)sender;
- (IBAction)ReturnButtonName:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddPlayerButton;

@end
