//
//  LoginViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 24-03-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *TrainerTextField;
@property (weak, nonatomic) IBOutlet UITextField *WachtwoordTextField;
- (IBAction)TrainerTextDidExit:(id)sender;
- (IBAction)WachtwoordTextDidExit:(id)sender;

@end
