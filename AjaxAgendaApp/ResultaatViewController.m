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
    
    // Category
    NSString *Category = [defaults objectForKey:@"Category"];
    [_categoryLabel setText:Category];
    
    // Players
    NSMutableArray *PlayersArray = [defaults objectForKey:@"PlayersArray"];
    NSString *PlayersString = [PlayersArray componentsJoinedByString: @"\n"];
    [_spelers setText:PlayersString];
    
    
    // Spelers text view
    
    CGRect spelerframe = _spelers.frame;
    spelerframe.size.height = _spelers.contentSize.height;
    _spelers.frame = spelerframe;
    
    CGSize spelersSize = [_spelers sizeThatFits:_spelers.frame.size];
    _spelersHeightConstraint.constant = spelersSize.height;
    
    
    // Oefeningen
    
    if ([Category isEqualToString:@"Veld training"]) {
        NSMutableArray *OefeningenArray = [defaults objectForKey:@"SelectedOefeningenArray"];
        NSString *OefeningenString = [OefeningenArray componentsJoinedByString: @"\n"];
        [_OefeningenText setText:OefeningenString];
        [_OefeningenText setFrame:CGRectMake(20, 317 + spelersSize.height, 220, 36)];
        
    } else{
        [_OefeningenHeader  removeFromSuperview];
        [_OefeningenText    removeFromSuperview];
    }
    
    CGSize oefeningenSize = [_OefeningenText sizeThatFits:_OefeningenText.frame.size];
    _oefeningenHeightConstraint.constant = oefeningenSize.height;
    
    
    // Extra info oefeningen
    
    if ([Category isEqualToString:@"Veld training"]) {
        NSMutableArray *OefeningenArray = [defaults objectForKey:@"SelectedOefeningenArray"];
        NSString *OefeningenString = [OefeningenArray componentsJoinedByString: @""];
        [_ExtraInfoTextView setText:OefeningenString];
        [_ExtraInfoTextView setFrame:CGRectMake(20, 390 + spelersSize.height + oefeningenSize.height, 220, 36)];
    } else{
        [_ExtraInfoLabel    removeFromSuperview];
        [_ExtraInfoTextView removeFromSuperview];
    }
    
    CGSize ExtraInfoSize = [_ExtraInfoTextView sizeThatFits:_ExtraInfoTextView.frame.size];
    _extraInfoHeightConstraint.constant = ExtraInfoSize.height;
    
    
    // Frame
    _frame.layer.cornerRadius = 10;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _frame.frame.size.width, _frame.frame.size.height)];
    
    scroll.scrollEnabled = YES;
    scroll.layer.cornerRadius = 10;
    
    int heightResultaten;
    
    // Details frame
    if ([Category isEqualToString:@"Veld training"]) {
        heightResultaten = 230 + spelersSize.height + oefeningenSize.height + ExtraInfoSize.height;
        [_Resultaten setFrame:CGRectMake(0, 0, _frame.frame.size.width, _frame.frame.size.height)];
    } else{
        heightResultaten = 200 + spelersSize.height;
        
        [_Resultaten setFrame:CGRectMake(0, 0, _frame.frame.size.width, heightResultaten)];
    }
    [scroll addSubview:_Resultaten];
    
    // Buttons frame
    [_Resultaten2 setFrame:CGRectMake(0, heightResultaten, _frame.frame.size.width, 40)];
    [scroll addSubview:_Resultaten2];
    
    scroll.contentSize = CGSizeMake(_Resultaten.frame.size.width, _Resultaten.frame.size.height + _Resultaten2.frame.size.height + 50);
    [_frame addSubview:scroll];
    
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
