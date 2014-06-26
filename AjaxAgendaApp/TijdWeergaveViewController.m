//
//  TijdWeergaveViewController.m
//  AjaxAgendaApp
//
//  Created by Dylan Bartels on 26/06/14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "TijdWeergaveViewController.h"

@interface TijdWeergaveViewController ()

@end

@implementation TijdWeergaveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _TijdweergaveTable.layer.cornerRadius = 10;
    _TijdweergaveTable.delegate     = self;
    _TijdweergaveTable.dataSource   = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------------------
// UITableview
//----------------------------------------------------------------------------------------------------------

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *Cell = [_TijdweergaveTable dequeueReusableCellWithIdentifier:@"Team"];
    return Cell;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
