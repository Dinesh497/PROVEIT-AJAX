//
//  AgendaViewController.h
//  AjaxAgendaApp
//
//  Created by Dylan Bartels on 13/05/14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AgendaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *ajaxtrainingDB;
@property (weak, nonatomic) IBOutlet UITableView *TrainingenTableView;

@end
