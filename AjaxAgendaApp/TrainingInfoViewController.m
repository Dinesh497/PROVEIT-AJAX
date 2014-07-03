//
//  TrainingInfoViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 13-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "TrainingInfoViewController.h"

@interface TrainingInfoViewController ()

@property NSMutableArray *HeadersSectionOne;
@property NSMutableArray *HeadersSectionTwo;
@property NSMutableArray *DetailsSectionOne;
@property NSMutableArray *DetailsSectionTwo;

@property NSDate *Date;
@property NSDate *BeginTime;
@property NSDate *EndTime;

@property NSString *SelectedField;

@property NSDateFormatter *timeFormatter;
@property NSDateFormatter *dateFormatter;

@property UIDatePicker *datePicker;
@property BOOL DatePickerActive;

// Geeft aan welke rij in de datepicker aanwezig is, als de waarde 5 is is de datepicker niet aanwezig
@property NSInteger ActiveDatePickerNumber;
@property NSInteger OldActiveDatePickerNumber;

@end

@implementation TrainingInfoViewController

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
    
    // Set tableview
    _TrainingTableView.delegate =            self;
    _TrainingTableView.dataSource =          self;
    _TrainingTableView.layer.cornerRadius =    10;
    
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
    _BeginTime = CurrentDate;
    
    // Set endDate
    _EndTime = [CurrentDate dateByAddingTimeInterval:60*60];
    
    NSString *vandaag = [_dateFormatter stringFromDate:CurrentDate];
    NSString *BeginTijdString = [_timeFormatter stringFromDate:_BeginTime];
    NSString *EindTijdString = [_timeFormatter stringFromDate:_EndTime];
    
    // Maak Titels en start details voor tijd
    _HeadersSectionOne = [[NSMutableArray alloc] initWithObjects:@"Datum",     @"Begin",            @"Eind",            nil];
    _DetailsSectionOne = [[NSMutableArray alloc] initWithObjects:vandaag,      BeginTijdString,     EindTijdString,     nil];
    
    // Maak Titels en start details voor locatie
    _HeadersSectionTwo = [[NSMutableArray alloc] initWithObjects:@"Veld",  nil];
    _DetailsSectionTwo = [[NSMutableArray alloc] initWithObjects:@"1",     nil];
    _SelectedField =@"Veld 1";
    
    // De Datepicker is nog niet actief
    _ActiveDatePickerNumber = 5;
    _OldActiveDatePickerNumber = _ActiveDatePickerNumber;
    _DatePickerActive = NO;
    
    
    // Do any additional setup after loading the view.
    
    
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
                cell = [_TrainingTableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
                
                _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-30, -30, 200, 162)];
                _datePicker.datePickerMode = UIDatePickerModeDate;
                // [_datePicker setLocale:[NSLocale currentLocale]];
                
                // Geef datePicker de juiste waarde
                NSIndexPath *indexPathDetailCell = [NSIndexPath indexPathForRow:0 inSection:0];
                UITableViewCell *cellDetail = [_TrainingTableView cellForRowAtIndexPath:indexPathDetailCell];
                NSString *TimeString = cellDetail.detailTextLabel.text;
                NSDate *datePickerTime = [_dateFormatter dateFromString:TimeString];
                [_datePicker setDate:_Date animated:NO];
                
                [_datePicker addTarget:self action:@selector(datePicker1ValueChanged) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:_datePicker];
            }
            if (_ActiveDatePickerNumber == 2) {
                // De datepicker heeft positie 2
                cell = [_TrainingTableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
                
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
                
                UITableViewCell *cellDetail = [_TrainingTableView cellForRowAtIndexPath:indexPathDetailCell];
                NSString *TimeString = cellDetail.detailTextLabel.text;
                NSDate *datePickerTime = [_timeFormatter dateFromString:TimeString];
                [_datePicker setDate:datePickerTime animated:NO];
                
                [_datePicker addTarget:self action:@selector(datePicker2ValueChanged) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:_datePicker];
            }
            if (_ActiveDatePickerNumber == 3) {
                // De datepicker heeft positie 3
                cell = [_TrainingTableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
                
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
                
                UITableViewCell *cellDetail = [_TrainingTableView cellForRowAtIndexPath:indexPathDetailCell];
                NSString *TimeString = cellDetail.detailTextLabel.text;
                NSDate *datePickerTime = [_timeFormatter dateFromString:TimeString];
                [_datePicker setDate:datePickerTime animated:NO];
                
                [_datePicker addTarget:self action:@selector(datePicker3ValueChanged) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:_datePicker];
            }
        } else{
            // Anders is het een Menu cell met een header en detail
            cell = [_TrainingTableView dequeueReusableCellWithIdentifier:@"NormalCell"];
            cell.textLabel.text = [_HeadersSectionOne objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [_DetailsSectionOne objectAtIndex:indexPath.row];
        }
    } else{
        // Sectie 2: Locatie
        cell = [_TrainingTableView dequeueReusableCellWithIdentifier:@"FieldDetailCell"];
        cell.textLabel.text = [_HeadersSectionTwo objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_DetailsSectionTwo objectAtIndex:indexPath.row];
    }
    
    _OldActiveDatePickerNumber = _ActiveDatePickerNumber;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Als er een rij wordt geselecteerd
    [_TrainingTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_TrainingTableView beginUpdates];
    
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
                [_TrainingTableView deleteRowsAtIndexPaths:indexPaths
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
                
                [_TrainingTableView deleteRowsAtIndexPaths:deleteIndexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
                [_TrainingTableView insertRowsAtIndexPaths:indexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
            }
        } else{
            // Voeg de picker cell toe aan de tableview
            indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
            
            _DatePickerActive = YES;
            _ActiveDatePickerNumber = indexPath.row + 1;
            [_TrainingTableView insertRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        // Ga naar het veld selecteer menu
        _SelectFieldFrame.layer.cornerRadius = 10;
        [_SelectFieldFrame setFrame:CGRectMake(30, 79, 260, 405)];
        [self.view addSubview:_SelectFieldFrame];
    }
    
    [_TrainingTableView endUpdates];
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
    [_TrainingTableView beginUpdates];
    
    NSDate *date = _datePicker.date;
    _Date = date;
    NSString *dateString = [_dateFormatter stringFromDate:date];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    
    
    [_TrainingTableView endUpdates];
}

-(void)datePicker2ValueChanged{
    [_TrainingTableView beginUpdates];
    
    NSDate *date = _datePicker.date;
    
    _BeginTime = date;
    NSString *dateString = [_timeFormatter stringFromDate:date];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    
    /*
    if(date < _EndTime){
        _EndTime = date;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    }
    */
     
    [_TrainingTableView endUpdates];
}

-(void)datePicker3ValueChanged{
    [_TrainingTableView beginUpdates];
    
    NSDate *date = _datePicker.date;
    _EndTime = date;
    NSString *dateString = [_timeFormatter stringFromDate:date];
 
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = dateString;
    
    [_TrainingTableView endUpdates];
}

//----------------------------------------------------------------------------------------------------------
// Veld Selecteren
//----------------------------------------------------------------------------------------------------------

- (IBAction)BackButtonPressedVeld:(id)sender {
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld11Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    // Zet Veld 11 in UITableview cell en in de array
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"11";
    
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"11"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 11";
}

- (IBAction)Veld10Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    // Zet Veld 10 in UITableview cell en in de array
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"10";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"10"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 10";
}

- (IBAction)Veld2Geselecteerd:(id)sender {
    // Zet Veld 2 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"2";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"2"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 2";
}

- (IBAction)Veld9Geselecteerd:(id)sender {
    // Zet Veld 9 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"9";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"9"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 9";
}

- (IBAction)HoofdVeldGeselecteerd:(id)sender {
    // Zet Veld Hoofd in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"Hoofd";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"Hoofd"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Hoofd veld";
}

- (IBAction)Veld1Geselecteerd:(id)sender {
    // Zet Veld 1 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"1";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"1"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 1";
}

- (IBAction)Veld7Geselecteerd:(id)sender {
    // Zet Veld 7 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"7";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"7"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 7";
}

- (IBAction)Veld8Geselecteerd:(id)sender {
    // Zet Veld 8 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"8";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"8"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 8";
}

- (IBAction)Veld3Geselecteerd:(id)sender {
    // Zet Veld 3 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"3";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"3"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 3";
}

- (IBAction)Veld4Geselecteerd:(id)sender {
    // Zet Veld 4 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"4";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"4"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 4";
}

- (IBAction)Veld5Geselecteerd:(id)sender {
    // Zet Veld 5 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"5";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"5"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 5";
}

- (IBAction)Veld6Geselecteerd:(id)sender {
    // Zet Veld 6 in UITableview cell en in de array
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"6";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"6"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
    
    _SelectedField =@"Veld 6";
}

//----------------------------------------------------------------------------------------------------------
// Save Data
//----------------------------------------------------------------------------------------------------------

- (IBAction)GereedButtonPressed:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_BeginTime      forKey:@"BeginTime"];
    [userDefaults setObject:_EndTime        forKey:@"EndTime"];
    [userDefaults setObject:_Date           forKey:@"theDate"];
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
