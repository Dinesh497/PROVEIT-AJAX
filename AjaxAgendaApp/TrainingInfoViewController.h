//
//  TrainingInfoViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 13-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TrainingTableView;
- (IBAction)DatePickerValueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *SelectFieldFrame;
- (IBAction)BackButtonPressedVeld:(id)sender;
- (IBAction)SelectVeld:(id)sender;



@end
