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
- (IBAction)Veld11Geselecteerd:(id)sender;
- (IBAction)Veld10Geselecteerd:(id)sender;
- (IBAction)Veld2Geselecteerd:(id)sender;
- (IBAction)Veld9Geselecteerd:(id)sender;
- (IBAction)HoofdVeldGeselecteerd:(id)sender;
- (IBAction)Veld1Geselecteerd:(id)sender;
- (IBAction)Veld7Geselecteerd:(id)sender;
- (IBAction)Veld8Geselecteerd:(id)sender;
- (IBAction)Veld3Geselecteerd:(id)sender;
- (IBAction)Veld4Geselecteerd:(id)sender;
- (IBAction)Veld5Geselecteerd:(id)sender;
- (IBAction)Veld6Geselecteerd:(id)sender;



@end
