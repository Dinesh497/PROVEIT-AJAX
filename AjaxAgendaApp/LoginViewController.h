//
//  ViewController.h
//  AjaxAgendaApp
//
//  Created by Dinesh Bhagwandin on 11-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface LoginViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *LoginFrame;
@property (weak, nonatomic) IBOutlet UITextField *TrainerTextField;
@property (weak, nonatomic) IBOutlet UITextField *WachtwoordTextField;
- (IBAction)TrainerTextDidExit:(id)sender;
- (IBAction)WachtwoordTextDidExit:(id)sender;


@property (readwrite, nonatomic) NSMutableArray *Usernames;
@property (readwrite, nonatomic) NSMutableArray *passwords;


@end
