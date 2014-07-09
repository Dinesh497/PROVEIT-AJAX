//
//  SelectTrainingTimeViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 09-07-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "SelectTrainingTimeViewController.h"

@interface SelectTrainingTimeViewController ()

@property NSDateFormatter   *dateFormatter;
@property NSDate            *currentDate;
@property NSDate            *BeginDate;
@property NSDate            *EndDate;

@property NSInteger         DatepickerLocation;

@end

@implementation SelectTrainingTimeViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_TimeTableview setDelegate:    self];
    [_TimeTableview setDataSource:  self];
    _TimeTableview.layer.cornerRadius = 10;
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    
    [_dateFormatter setDateFormat:  @"MM-dd-YYYY"];
    [_dateFormatter setLocale:      [NSLocale currentLocale]];
    
    _currentDate            = [NSDate date];
    _BeginDate              = _currentDate;
    _EndDate                = [_currentDate dateByAddingTimeInterval:60*60*24];
    _DatepickerLocation     = 0;
    
}

//----------------------------------------------------------------------------------------------------------
// Tableview
//----------------------------------------------------------------------------------------------------------

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Playertrainingen"];
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_DatepickerLocation == 0) {
        return 2;
    } else {
        return 3;
    }
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [_TimeTableview dequeueReusableCellWithIdentifier:@"TimeCell"];
        cell.textLabel.text         = @"Begin datum";
        cell.detailTextLabel.text   = [_dateFormatter stringFromDate:_BeginDate];
    }
    
    if (indexPath.row == 1) {
        if (_DatepickerLocation == 1) {
            // Datepicker bij begin datum
            cell = [_TimeTableview dequeueReusableCellWithIdentifier:@"DatepickerCell"];
            
        } else{
            // Geen Datepicker bij begin datum
            cell = [_TimeTableview dequeueReusableCellWithIdentifier:@"TimeCell"];
            cell.textLabel.text         = @"Eind datum";
            cell.detailTextLabel.text = [_dateFormatter stringFromDate:_EndDate];
        }
    }
    
    if (indexPath.row == 2) {
        // Datepicker bij eind datum
        cell = [_TimeTableview dequeueReusableCellWithIdentifier:@"DatepickerCell"];
    }
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        // Begin datum geselecteerd
        
    }
    
    if (indexPath.row == 1) {
        // Eind datum geselecteerd
        
    }
    
    [_TimeTableview deselectRowAtIndexPath:indexPath animated:YES];
}

//----------------------------------------------------------------------------------------------------------
// Xcode
//----------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
