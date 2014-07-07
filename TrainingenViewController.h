//
//  TrainingenViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 04-07-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingenViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *Frame;
@property (weak, nonatomic) IBOutlet UILabel *PlayerLabel;

@property (weak, nonatomic) IBOutlet UITableView *TrainingTableView;
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
- (IBAction)GereedButtonPressed:(id)sender;

@end
