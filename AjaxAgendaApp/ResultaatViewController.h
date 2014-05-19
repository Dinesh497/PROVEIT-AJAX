//
//  ResultaatViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 03-05-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultaatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *BeginTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIView *frame;
@property (weak, nonatomic) IBOutlet UITextView *spelers;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollFrame;
@property (weak, nonatomic) IBOutlet UITextView *OefeningenText;
@property (weak, nonatomic) IBOutlet UILabel *OefeningenHeader;
@property (weak, nonatomic) IBOutlet UISwitch *addLocal;

@end
