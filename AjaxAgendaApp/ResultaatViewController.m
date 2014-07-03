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
    NSInteger HeaderHeightSize = 29;
    
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
    
    UILabel *OefeningenHeader = [[UILabel alloc] init];
    [OefeningenHeader setText:@"Oefeningen:"];
    
    UITextView *OefeningenText = [[UITextView alloc] init];
    [OefeningenText setSelectable:NO];
    [OefeningenText setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    CGSize oefeningenSize;
    
    if ([Category isEqualToString:@"Veld training"]) {
        
        NSMutableArray *OefeningenArray = [defaults objectForKey:@"SelectedOefeningenArray"];
        NSString *OefeningenString = [OefeningenArray componentsJoinedByString: @"\n"];
        [OefeningenText setText:OefeningenString];
        
        CGRect oefeningenframe = OefeningenText.frame;
        oefeningenframe.size.height = OefeningenText.contentSize.height;
        OefeningenText.frame = spelerframe;
        
        oefeningenSize = [OefeningenText sizeThatFits:OefeningenText.frame.size];
        
        [_Resultaten addSubview:OefeningenHeader];
        [_Resultaten addSubview:OefeningenText];
        
        [OefeningenHeader setFrame:CGRectMake(20, 194 + spelersSize.height + 4, 220, 21)];
        [OefeningenText setFrame:CGRectMake(20, 194 + spelersSize.height + HeaderHeightSize, 220, oefeningenSize.height)];
        
    } else{
        [OefeningenHeader  removeFromSuperview];
        [OefeningenText    removeFromSuperview];
    }
    
    
    
    // Extra info oefeningen
    
    UILabel *ExtraInfoHeader = [[UILabel alloc] init];
    [ExtraInfoHeader setText:@"Extra informatie:"];
    
    UITextView *ExtraInfoText = [[UITextView alloc] init];
    [ExtraInfoText setSelectable:NO];
    [ExtraInfoText setFont:[UIFont fontWithName:@"System" size:14.0]];
    [ExtraInfoText setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    CGSize ExtraInfoSize;
    
    if ([Category isEqualToString:@"Veld training"]) {
        
        NSString *ExtraInformation = [defaults objectForKey:@"ExtraInfo"];
        [ExtraInfoText setText:ExtraInformation];
        
        ExtraInfoSize = [ExtraInfoText sizeThatFits:ExtraInfoText.frame.size];
        
        [_Resultaten addSubview:ExtraInfoHeader];
        [_Resultaten addSubview:ExtraInfoText];
        
        [ExtraInfoHeader setFrame:CGRectMake(20, 194 + spelersSize.height + oefeningenSize.height + HeaderHeightSize + 4, 220, 36)];
        [ExtraInfoText setFrame:CGRectMake(20, 194 + spelersSize.height + oefeningenSize.height + HeaderHeightSize + HeaderHeightSize, 220, ExtraInfoSize.height)];
        
    } else{
        [ExtraInfoHeader    removeFromSuperview];
        [ExtraInfoText      removeFromSuperview];
    }
    
    // Frame
    _frame.layer.cornerRadius = 10;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _frame.frame.size.width, _frame.frame.size.height)];
    
    scroll.scrollEnabled = YES;
    scroll.layer.cornerRadius = 10;
    scroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    int heightResultaten;
    
    
    // Details frame
    if ([Category isEqualToString:@"Veld training"]) {
        heightResultaten = 194 + spelersSize.height + oefeningenSize.height + ExtraInfoSize.height + HeaderHeightSize + HeaderHeightSize;
    } else{
        heightResultaten = 200 + spelersSize.height;
    }
    
    if (heightResultaten < 365) {
        [_Resultaten setFrame:CGRectMake(0, 0, _frame.frame.size.width, 365)];
    } else{
        [_Resultaten setFrame:CGRectMake(0, 0, _frame.frame.size.width, heightResultaten)];
    }
    
    [scroll addSubview:_Resultaten];
    
    
    // Buttons frame
    [_Resultaten2 setFrame:CGRectMake(0, _Resultaten.frame.size.height, _frame.frame.size.width, 40)];
    [scroll addSubview:_Resultaten2];
    
    scroll.contentSize = CGSizeMake(_Resultaten.frame.size.width, _Resultaten.frame.size.height + _Resultaten2.frame.size.height);
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

- (IBAction)VoegToeButtonPressed:(id)sender {
    
}

- (IBAction)CancelButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
