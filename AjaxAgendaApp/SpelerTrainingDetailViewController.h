//
//  SpelerTrainingDetailViewController.h
//  AjaxAgendaApp
//
//  Created by Dinesh Bhagwandin on 09-07-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SpelerTrainingDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *Frame;

@property (weak, nonatomic) IBOutlet UIView *ScrollFrame;

@property (weak, nonatomic) IBOutlet UILabel *PlayerLabel;
@property (weak, nonatomic) IBOutlet UILabel *TotalLabel;

@end
