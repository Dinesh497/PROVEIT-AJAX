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

@property NSArray *HeadersSectionOne;
@property NSArray *HeadersSectionTwo;
@property NSArray *DetailsSectionOne;
@property NSArray *DetailsSectionTwo;

@property NSDate *Date;
@property NSDate *BeginTime;
@property NSDate *EndTime;

@property BOOL *DatePickerActive;
@property int ActiveDatePickerNumber;

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
    
    // Maak Titels en start details voor tijd
    _HeadersSectionOne = [[NSArray alloc] initWithObjects:@"Datum",     @"Begin",   @"Eind",    nil];
    _DetailsSectionOne = [[NSArray alloc] initWithObjects:@"Vandaag",   @"12:00",   @"13:00",   nil];
    
    // Maak Titels en start details voor locatie
    _HeadersSectionTwo = [[NSArray alloc] initWithObjects:@"Veld",  nil];
    _DetailsSectionTwo = [[NSArray alloc] initWithObjects:@"1",     nil];
    
    // De Datepicker is nog niet actief
    _ActiveLocation = 0;
    
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
        // De eerste sectie heeft drie rijen nodig voor begin tijd, eind tijd en datum
        return [_HeadersSectionOne count];
    } else{
        // De tweede sectie heeft een rij nodig voor het veld
        return [_HeadersSectionTwo count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_TrainingTableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    
    if (indexPath.section == 0) {
        // Sectie 1: Tijd
        cell.textLabel.text = [_HeadersSectionOne objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_DetailsSectionOne objectAtIndex:indexPath.row];
    } else{
        // Sectie 2: Locatie
        cell.textLabel.text = [_HeadersSectionTwo objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_DetailsSectionTwo objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Als er een rij wordt geselecteerd
    [_TrainingTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (_DatePickerActive) {
            if(_ActiveDatePickerNumber == indexPath.row){
                // Verwijder de picker cell van de tableview
            } else{
                // Verplaats de picker cell naar de nieuwe geselecteerde positie
            }
        } else{
            // Voeg de picker cell toe aan de tableview
        }
    } else {
        // Ga naar het veld selecteer menu
    }
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

@end
