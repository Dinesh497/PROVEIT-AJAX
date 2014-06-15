//
//  AgendaDetailViewController.h
//  AjaxAgendaApp
//
//  Created by Dylan Bartels on 28/05/14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AgendaDetailViewController : UIViewController

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *ajaxtrainingDB;

@end
