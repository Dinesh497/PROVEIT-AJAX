//
//  TijdWeergaveViewController.h
//  AjaxAgendaApp
//
//  Created by Dylan Bartels on 26/06/14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TijdWeergaveViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TijdweergaveTable;

@end
