//
//  TijdWeergaveViewController.m
//  AjaxAgendaApp
//
//  Created by Dylan Bartels on 26/06/14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "TijdWeergaveViewController.h"

@interface TijdWeergaveViewController ()

@property NSMutableArray *HeadersSectionOne;
@property NSMutableArray *HeadersSectionTwo;
@property NSMutableArray *DetailsSectionOne;
@property NSMutableArray *DetailsSectionTwo;

@property NSDate *Date;
@property NSDate *BeginDate;
@property NSDate *EndDate;

@property NSString *SelectedField;

@property NSDateFormatter *timeFormatter;
@property NSDateFormatter *dateFormatter;

@property UIDatePicker *datePicker;
@property BOOL DatePickerActive;

// Geeft aan welke rij in de datepicker aanwezig is, als de waarde 5 is is de datepicker niet aanwezig
@property NSInteger ActiveDatePickerNumber;
@property NSInteger OldActiveDatePickerNumber;

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
    _TijdweergaveTable.delegate = self;
    _TijdweergaveTable.dataSource = self;
    _TijdweergaveTable.layer.cornerRadius = 10;
    
    // Set formats
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setDateFormat:@"HH:mm"];
    [_timeFormatter setLocale:[NSLocale currentLocale]];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MM/dd/YYYY"];
    [_dateFormatter setLocale:[NSLocale currentLocale]];
    
    // Set date
    NSDate *CurrentDate = [NSDate date];
    _Date = CurrentDate;
    
    // Set begindate
    _BeginDate = CurrentDate;
    
    // Set endDate
    _EndDate = [CurrentDate dateByAddingTimeInterval:60*60];
    
    NSString *vandaag = [_dateFormatter stringFromDate:CurrentDate];
    NSString *BeginDatumString = [_timeFormatter stringFromDate:_BeginDate];
    NSString *EindDatumString = [_timeFormatter stringFromDate:_EndDate];
    
    // Maak Titels en start details voor tijd
    _HeadersSectionOne = [[NSMutableArray alloc] initWithObjects:@"Datum",     @"Begin",            @"Eind",            nil];
    _DetailsSectionOne = [[NSMutableArray alloc] initWithObjects:vandaag,      BeginDatumString,     EindDatumString,     nil];
    
    // De Datepicker is nog niet actief
    _ActiveDatePickerNumber = 5;
    _OldActiveDatePickerNumber = _ActiveDatePickerNumber;
    _DatePickerActive = NO;
}

//----------------------------------------------------------------------------------------------------------
// Tableview
//----------------------------------------------------------------------------------------------------------

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        // De eerste sectie is van de tijden
        return @"Tijd";
    } else{
        // De tweede sectie is van de locatie
        return @"Locatie";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Twee secties in de tableview
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        if (!_DatePickerActive) {
            // De eerste sectie heeft drie rijen nodig voor begin tijd, eind tijd en datum
            return [_HeadersSectionOne count];
        } else{
            // Er komt een extra cell bij
            return 4;
        }
    } else{
        // De tweede sectie heeft een rij nodig voor het veld
        return [_HeadersSectionTwo count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        // Sectie 1: Tijd
        if (_DatePickerActive){
            if (_ActiveDatePickerNumber == 1) {
                // De datepicker heeft positie 1
                cell = [_TijdweergaveTable dequeueReusableCellWithIdentifier:@"DatePickerCell"];
                
                _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-30, -30, 200, 162)];
                _datePicker.datePickerMode = UIDatePickerModeDate;
                // [_datePicker setLocale:[NSLocale currentLocale]];
                
                // Geef datePicker de juiste waarde
                NSIndexPath *indexPathDetailCell = [NSIndexPath indexPathForRow:0 inSection:0];
                UITableViewCell *cellDetail = [_TijdweergaveTable cellForRowAtIndexPath:indexPathDetailCell];
                NSString *TimeString = cellDetail.detailTextLabel.text;
                NSDate *datePickerTime = [_dateFormatter dateFromString:TimeString];
                [_datePicker setDate:datePickerTime animated:NO];
                
                [_datePicker addTarget:self action:@selector(datePicker1ValueChanged) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:_datePicker];
            }
            if (_ActiveDatePickerNumber == 2) {
                // De datepicker heeft positie 2
                cell = [_TijdweergaveTable dequeueReusableCellWithIdentifier:@"TimePickerCell"];
                
                _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-30, -30, 200, 162)];
                _datePicker.datePickerMode = UIDatePickerModeTime;
                [_datePicker setLocale:[NSLocale currentLocale]];
                
                // Geef datePicker de juiste waarde
                NSIndexPath *indexPathDetailCell;
                
                if(indexPath.row > _OldActiveDatePickerNumber ){
                    indexPathDetailCell = [NSIndexPath indexPathForRow:2 inSection:0];
                } else{
                    indexPathDetailCell = [NSIndexPath indexPathForRow:1 inSection:0];
                }
                
                UITableViewCell *cellDetail = [_TijdweergaveTable cellForRowAtIndexPath:indexPathDetailCell];
                NSString *TimeString = cellDetail.detailTextLabel.text;
                NSDate *datePickerTime = [_timeFormatter dateFromString:TimeString];
                [_datePicker setDate:datePickerTime animated:NO];
                
                [_datePicker addTarget:self action:@selector(datePicker2ValueChanged) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:_datePicker];
            }
            if (_ActiveDatePickerNumber == 3) {
                // De datepicker heeft positie 3
                cell = [_TijdweergaveTable dequeueReusableCellWithIdentifier:@"TimePickerCell"];
                
                _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-30, -30, 200, 162)];
                _datePicker.datePickerMode = UIDatePickerModeTime;
                [_datePicker setLocale:[NSLocale currentLocale]];
                
                // Geef datePicker de juiste waarde
                NSIndexPath *indexPathDetailCell;
                
                if(indexPath.row > _OldActiveDatePickerNumber){
                    indexPathDetailCell = [NSIndexPath indexPathForRow:3 inSection:0];
                } else{
                    indexPathDetailCell = [NSIndexPath indexPathForRow:2 inSection:0];
                }
                
                UITableViewCell *cellDetail = [_TijdweergaveTable cellForRowAtIndexPath:indexPathDetailCell];
                NSString *TimeString = cellDetail.detailTextLabel.text;
                NSDate *datePickerTime = [_timeFormatter dateFromString:TimeString];
                [_datePicker setDate:datePickerTime animated:NO];
                
                [_datePicker addTarget:self action:@selector(datePicker3ValueChanged) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:_datePicker];
            }
        } else{
            // Anders is het een Menu cell met een header en detail
            cell = [_TijdweergaveTable dequeueReusableCellWithIdentifier:@"NormalCell"];
            cell.textLabel.text = [_HeadersSectionOne objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [_DetailsSectionOne objectAtIndex:indexPath.row];
        }
    } else{
        // Sectie 2: Locatie
        cell = [_TijdweergaveTable dequeueReusableCellWithIdentifier:@"FieldDetailCell"];
        cell.textLabel.text = [_HeadersSectionTwo objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_DetailsSectionTwo objectAtIndex:indexPath.row];
    }
    
    _OldActiveDatePickerNumber = _ActiveDatePickerNumber;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Als er een rij wordt geselecteerd
    [_TijdweergaveTable deselectRowAtIndexPath:indexPath animated:YES];
    
    [_TijdweergaveTable beginUpdates];
    
    NSArray *indexPaths;
    NSArray *deleteIndexPaths = @[[NSIndexPath indexPathForRow:_ActiveDatePickerNumber inSection:0]];
    
    if (indexPath.section == 0) {
        if (_DatePickerActive) {
            if(_ActiveDatePickerNumber == indexPath.row + 1){
                
                // Verwijder de picker cell van de tableview
                indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                
                _DatePickerActive = NO;
                _ActiveDatePickerNumber = 5;
                _OldActiveDatePickerNumber = _ActiveDatePickerNumber;
                [_TijdweergaveTable deleteRowsAtIndexPaths:indexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
                [_datePicker removeFromSuperview];
                
            } else{
                
                [_datePicker removeFromSuperview];
                
                // Verplaats de picker cell naar de nieuwe geselecteerde positie
                if(indexPath.row > _ActiveDatePickerNumber){
                    indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                    _ActiveDatePickerNumber = indexPath.row;
                } else{
                    indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                    _ActiveDatePickerNumber = indexPath.row + 1;
                }
                
                [_TijdweergaveTable deleteRowsAtIndexPaths:deleteIndexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
                [_TijdweergaveTable insertRowsAtIndexPaths:indexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
            }
        } else{
            // Voeg de picker cell toe aan de tableview
            indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
            
            _DatePickerActive = YES;
            _ActiveDatePickerNumber = indexPath.row + 1;
            [_TijdweergaveTable insertRowsAtIndexPaths:indexPaths
                                      withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [_TijdweergaveTable endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_DatePickerActive){
        if (_ActiveDatePickerNumber == indexPath.row) {
            return 162;
        } else{
            return 44;
        }
    } else {
        return 44;
    }
}

//----------------------------------------------------------------------------------------------------------
// Tijd en datum selecteren
//----------------------------------------------------------------------------------------------------------

-(void)datePicker1ValueChanged{
    [_TijdweergaveTable beginUpdates];
    
    NSDate *date = _datePicker.date;
    _Date = date;
    NSString *dateString = [_dateFormatter stringFromDate:date];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_TijdweergaveTable cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    
    
    [_TijdweergaveTable endUpdates];
}

-(void)datePicker2ValueChanged{
    [_TijdweergaveTable beginUpdates];
    
    NSDate *date = _datePicker.date;
    
    _BeginDate = date;
    NSString *dateString = [_timeFormatter stringFromDate:date];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_TijdweergaveTable cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    
    /*
     if(date < _EndTime){
     _EndTime = date;
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
     [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
     }
     */
    
    [_TijdweergaveTable endUpdates];
}

-(void)datePicker3ValueChanged{
    [_TijdweergaveTable beginUpdates];
    
    NSDate *date = _datePicker.date;
    _EndDate = date;
    NSString *dateString = [_timeFormatter stringFromDate:date];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [_TijdweergaveTable cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    
    [_TijdweergaveTable endUpdates];
}

//----------------------------------------------------------------------------------------------------------
// Save Data
//----------------------------------------------------------------------------------------------------------

- (IBAction)GereedButtonPressed:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_BeginDate      forKey:@"BeginDatumWeergave"];
    [userDefaults setObject:_EndDate        forKey:@"EindDatumWeergave"];
    [userDefaults setObject:_Date           forKey:@"theDateWeergave"];
    [userDefaults setObject:_SelectedField  forKey:@"Location"];
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
