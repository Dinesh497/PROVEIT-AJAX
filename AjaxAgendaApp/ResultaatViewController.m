//
//  ResultaatViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 03-05-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "ResultaatViewController.h"

@interface ResultaatViewController ()

@end

@implementation ResultaatViewController

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Frame
    _frame.layer.cornerRadius       = 10;
    _scrollFrame.layer.cornerRadius = 10;
    
    // Category
    NSString *Category = [defaults objectForKey:@"Category"];
    [_categoryLabel setText:Category];
    
    // Date
    NSDate *theDate     = [defaults objectForKey:@"theDate"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *theDateString = [dateFormatter stringFromDate:theDate];
    
    [_dateLabel setText:theDateString];
    
    // Time
    NSDate *beginTime   = [defaults objectForKey:@"BeginTime"];
    NSDate *endTime     = [defaults objectForKey:@"EndTime"];
    
    NSDateFormatter *timeFormatter;
    
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    [timeFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *beginTimeString   = [timeFormatter stringFromDate:beginTime];
    NSString *endTimeString     = [timeFormatter stringFromDate:endTime];
    
    [_BeginTime setText:beginTimeString];
    [_endTime setText:endTimeString];
    
    // Location
    NSString *Location = [defaults objectForKey:@"Location"];
    [_locationLabel setText:Location];
    
    // Players
    NSMutableArray *PlayersArray = [defaults objectForKey:@"PlayersArray"];
    NSString *PlayersString = [PlayersArray componentsJoinedByString: @"\n"];
    
    [_spelers setText:PlayersString];
    
    // Oefeningen
    
    if ([Category isEqualToString:@"Veld training"]) {
        NSMutableArray *OefeningenArray = [defaults objectForKey:@"SelectedOefeningenArray"];
        NSString *OefeningenString = [OefeningenArray componentsJoinedByString: @"\n"];
        [_OefeningenText setText:OefeningenString];
    } else{
        [_OefeningenHeader  removeFromSuperview];
        [_OefeningenText    removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addLocal:(id)sender
{
        
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
