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
    
    // test Time
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
    
    // Test players
    NSMutableArray *PlayersArray = [defaults objectForKey:@"PlayersArray"];
    NSString *PlayersString = [PlayersArray componentsJoinedByString: @"\n"];
    
    [_spelers setText:PlayersString];
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
