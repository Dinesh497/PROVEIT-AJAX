//
//  SelectSpelersViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 19-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPlayersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *SelectPlayerTable;
@property (weak, nonatomic) IBOutlet UIView *SelectPlayersFrame;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentController;
- (IBAction)SelectedSegmentChanged:(id)sender;

@end
