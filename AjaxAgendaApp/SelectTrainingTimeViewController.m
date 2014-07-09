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
@property UIDatePicker      *datePicker;

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
    
    _datePicker =                   [[UIDatePicker alloc] initWithFrame:CGRectMake(-30, -30, 200, 162)];
    _datePicker.datePickerMode =    UIDatePickerModeDate;
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
        cell.textLabel.text         = @"Vanaf";
        cell.detailTextLabel.text   = [_dateFormatter stringFromDate:_BeginDate];
    }
    
    if (indexPath.row == 1) {
        if (_DatepickerLocation == 1) {
            // Datepicker bij begin datum
            cell = [_TimeTableview dequeueReusableCellWithIdentifier:@"DatepickerCell"];
            
            [_datePicker setDate:_BeginDate animated:YES];
            [_datePicker addTarget:self action:@selector(BeginValueChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_datePicker];
            
        } else{
            // Geen Datepicker bij begin datum
            cell = [_TimeTableview dequeueReusableCellWithIdentifier:@"TimeCell"];
            cell.textLabel.text         = @"Einde";
            cell.detailTextLabel.text = [_dateFormatter stringFromDate:_EndDate];
        }
    }
    
    if (indexPath.row == 2) {
        
        if (_DatepickerLocation == 1) {
            // Datepicker bij begin datum
            cell = [_TimeTableview dequeueReusableCellWithIdentifier:@"TimeCell"];
            cell.textLabel.text         = @"Einde";
            cell.detailTextLabel.text = [_dateFormatter stringFromDate:_EndDate];
            
        } else{
            // Datepicker bij eind datum
            cell = [_TimeTableview dequeueReusableCellWithIdentifier:@"DatepickerCell"];
            
            [_datePicker setDate:_EndDate animated:YES];
            [_datePicker addTarget:self action:@selector(EindValueChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_datePicker];
        }
    }
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [_TimeTableview cellForRowAtIndexPath:indexPath];
    
    [_TimeTableview deselectRowAtIndexPath:indexPath animated:YES];
    
    if (cell.tag == 1) {
        // Time cell
        
        [_TimeTableview beginUpdates];
        
        NSArray *indexPaths;
        NSArray *deleteIndexPaths =@[[NSIndexPath indexPathForRow:_DatepickerLocation inSection:0]];
        
        if (indexPath.row == 0) {
            // Begin datum geselecteerd
            
            if (_DatepickerLocation == 1) {
                // Verwijder datepicker
                indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                [_TimeTableview deleteRowsAtIndexPaths:indexPaths
                                      withRowAnimation:UITableViewRowAnimationFade];
                _DatepickerLocation = 0;
                
            } else{
                if (_DatepickerLocation == 2) {
                    // Verplaats de datepicker
                    
                    if(indexPath.row > _DatepickerLocation){
                        indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                        _DatepickerLocation = indexPath.row;
                    } else{
                        indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                        _DatepickerLocation = indexPath.row + 1;
                    }
                    
                    [_TimeTableview deleteRowsAtIndexPaths:deleteIndexPaths
                                              withRowAnimation:UITableViewRowAnimationFade];
                    [_TimeTableview insertRowsAtIndexPaths:indexPaths
                                              withRowAnimation:UITableViewRowAnimationFade];
                    _DatepickerLocation = 1;
                } else{
                    // Voeg datepicker toe
                    indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                    [_TimeTableview insertRowsAtIndexPaths:indexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
                    _DatepickerLocation = 1;
                }
            }
        } else{
            // Eind datum geselecteerd
            
            if (_DatepickerLocation == 2) {
                // Verwijder datepicker
                indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                [_TimeTableview deleteRowsAtIndexPaths:indexPaths
                                      withRowAnimation:UITableViewRowAnimationFade];
                _DatepickerLocation = 0;
            } else{
                if (_DatepickerLocation == 1) {
                    // Verplaats de datepicker
                    
                    if(indexPath.row > _DatepickerLocation){
                        indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                        _DatepickerLocation = indexPath.row;
                    } else{
                        indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                        _DatepickerLocation = indexPath.row + 1;
                    }
            
                    [_TimeTableview deleteRowsAtIndexPaths:deleteIndexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
                    [_TimeTableview insertRowsAtIndexPaths:indexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
                    _DatepickerLocation = 2;
                } else{
                    // Voeg datepicker toe
                    indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                    [_TimeTableview insertRowsAtIndexPaths:indexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
                    _DatepickerLocation = 2;
                }
            }
        }
        
        [_TimeTableview endUpdates];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_DatepickerLocation == 0){
        return 44;
    } else {
        if (_DatepickerLocation == indexPath.row) {
            return 162;
        } else{
            return 44;
        }
    }
}

//----------------------------------------------------------------------------------------------------------
// Date picker
//----------------------------------------------------------------------------------------------------------

-(void) BeginValueChanged{
    [_TimeTableview beginUpdates];
    
    _BeginDate = _datePicker.date;
    NSString *dateString = [_dateFormatter stringFromDate:_datePicker.date];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_TimeTableview cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    
    if( [_BeginDate timeIntervalSinceDate:_EndDate] > 0 ) {
        _EndDate                = [_BeginDate dateByAddingTimeInterval:60*60*24];
        NSString *dateString2 = [_dateFormatter stringFromDate:_EndDate];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
        [_TimeTableview cellForRowAtIndexPath:indexPath2].detailTextLabel.text = dateString2;
    }
    
    [_TimeTableview endUpdates];
}

-(void) EindValueChanged{
    [_TimeTableview beginUpdates];
    
    _EndDate = _datePicker.date;
    NSString *dateString = [_dateFormatter stringFromDate:_datePicker.date];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_TimeTableview cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    
    if( [_EndDate timeIntervalSinceDate:_BeginDate] < 0 ) {
        _BeginDate                = [_EndDate dateByAddingTimeInterval:-60*60*24];
        NSString *dateString2 = [_dateFormatter stringFromDate:_BeginDate];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
        [_TimeTableview cellForRowAtIndexPath:indexPath2].detailTextLabel.text = dateString2;
    }
    
    [_TimeTableview endUpdates];
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
