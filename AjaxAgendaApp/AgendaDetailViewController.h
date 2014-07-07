//
//  AgendaDetailViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 07-07-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AgendaDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *frame;

@property (strong, nonatomic) IBOutlet UIView *TrainingInfo;
@property (weak, nonatomic) IBOutlet UILabel *CatergorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *DatumHeadLabel;
@property (weak, nonatomic) IBOutlet UILabel *DatumLabel;
@property (weak, nonatomic) IBOutlet UILabel *BeginHeadLabel;
@property (weak, nonatomic) IBOutlet UILabel *BeginTijdLabel;
@property (weak, nonatomic) IBOutlet UILabel *EindHeadLabel;
@property (weak, nonatomic) IBOutlet UILabel *EindTijdLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocatieHeadLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocatieVeldLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpelersHeadLabel;

@end
