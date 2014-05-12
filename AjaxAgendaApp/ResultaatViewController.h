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
@property (weak, nonatomic) IBOutlet UITextView *spelers;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
