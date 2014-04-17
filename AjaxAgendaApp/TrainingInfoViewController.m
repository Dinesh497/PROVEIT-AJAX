//
//  TrainingInfoViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 13-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "TrainingInfoViewController.h"

#define TagDateDatePicker           21
#define TagTimeDatePicker           22

@interface TrainingInfoViewController ()

@property NSMutableArray *HeadersSectionOne;
@property NSMutableArray *HeadersSectionTwo;
@property NSMutableArray *DetailsSectionOne;
@property NSMutableArray *DetailsSectionTwo;

@property NSDate *Date;
@property NSDate *BeginTime;
@property NSDate *EndTime;

@property (nonatomic, strong) IBOutlet UIDatePicker *DatePicker;


@property NSDateFormatter *timeFormatter;
@property NSDateFormatter *dateFormatter;

@property BOOL DatePickerActive;

// Geeft aan welke rij in de datepicker aanwezig is, als de waarde 5 is is de datepicker niet aanwezig
@property NSInteger ActiveDatePickerNumber;

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
    
    // De tableview installeren
    _TrainingTableView.delegate =            self;
    _TrainingTableView.dataSource =          self;
    _TrainingTableView.layer.cornerRadius =    10;
    
    // Zet de formatten
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setDateStyle:NSDateFormatterShortStyle];
    [_timeFormatter setDateFormat:@"HH:mm"];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MM/dd/YYYY"];
    
    // Zet de datum van vandaag
    NSDate *DatumVandaag = [NSDate date];
    NSString *vandaag = [_dateFormatter stringFromDate:DatumVandaag];
    
    // Maak Titels en start details voor tijd
    _HeadersSectionOne = [[NSMutableArray alloc] initWithObjects:@"Datum",     @"Begin",   @"Eind",    nil];
    _DetailsSectionOne = [[NSMutableArray alloc] initWithObjects:vandaag,      @"Geen",    @"Geen",    nil];
    
    // Maak Titels en start details voor locatie
    _HeadersSectionTwo = [[NSMutableArray alloc] initWithObjects:@"Veld",  nil];
    _DetailsSectionTwo = [[NSMutableArray alloc] initWithObjects:@"1",     nil];
    
    // De Datepicker is nog niet actief
    _ActiveDatePickerNumber = 5;
    _DatePickerActive = NO;
    
    // Do any additional setup after loading the view.
}

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
                _DatePicker = (UIDatePicker *)[cell viewWithTag:TagDateDatePicker];
            }
            if (_ActiveDatePickerNumber == 2) {
                // De datepicker heeft positie 2
                cell = [_TrainingTableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
            }
            if (_ActiveDatePickerNumber == 3) {
                // De datepicker heeft positie 3
                cell = [_TrainingTableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
            }
        } else{
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
                [_TrainingTableView deleteRowsAtIndexPaths:indexPaths
                                          withRowAnimation:UITableViewRowAnimationFade];
            } else{
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

- (IBAction)DatePickerValueChanged:(id)sender {
    
    [_TrainingTableView beginUpdates];
    
    if (_ActiveDatePickerNumber == 1) {
        
    }
    if (_ActiveDatePickerNumber == 2) {
        UITableViewCell *timeCell = [_TrainingTableView dequeueReusableHeaderFooterViewWithIdentifier:@"TimePickerCell"];
        UIDatePicker *targetedDatepicker = (UIDatePicker *)[timeCell viewWithTag:TagTimeDatePicker];
        NSDate *selectedTime = [targetedDatepicker date];
        NSString *selectedTimeString = [_timeFormatter stringFromDate:selectedTime];
        [_DetailsSectionOne replaceObjectAtIndex:1 withObject:selectedTimeString];
    
    }
    if (_ActiveDatePickerNumber == 3) {
        // NSDate *selectedTime = [_DatePicker date];
        NSString *selectedTimeString = @"13:00"; // [_timeFormatter stringFromDate:selectedTime];
        [_DetailsSectionOne replaceObjectAtIndex:2 withObject:selectedTimeString];
    }
    
    [_TrainingTableView endUpdates];
}

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

- (IBAction)BackButtonPressedVeld:(id)sender {
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld11Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"11";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"11"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld10Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"10";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"10"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld2Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"2";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"2"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld9Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"9";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"9"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)HoofdVeldGeselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"Hoofd";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"hoofd"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld1Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"1";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"1"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld7Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"7";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"7"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld8Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"8";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"8"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld3Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"3";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"3"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld4Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"4";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"4"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld5Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"5";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"5"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

- (IBAction)Veld6Geselecteerd:(id)sender {
    [_TrainingTableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_TrainingTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"6";
    [_DetailsSectionTwo replaceObjectAtIndex:0 withObject:@"6"];
    
    [_TrainingTableView endUpdates];
    [_SelectFieldFrame removeFromSuperview];
}

    @end
