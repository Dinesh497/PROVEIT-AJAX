//
//  OefeningenViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 17-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OefeningenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollForm;
@property (weak, nonatomic) IBOutlet UIView *Form;


- (IBAction)pressedAfwerken:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonAfwerken;



@end
