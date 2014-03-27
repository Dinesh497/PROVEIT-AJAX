//
//  TrainingInfoViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 27-03-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "TrainingInfoViewController.h"

@interface TrainingInfoViewController ()

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
    // Do any additional setup after loading the view.
}

- (IBAction)SelectVeld:(id)sender {
    
    UIView *frame = [[UIView alloc] initWithFrame:CGRectMake(20.0, 20.0, 280.0, 464.0)];
    frame.backgroundColor = [UIColor whiteColor];
    
    
    frame.layer.cornerRadius = 10;
    frame.layer.shadowColor = [[UIColor blackColor] CGColor];
    frame.layer.shadowOpacity = 1;
    frame.layer.shadowRadius = 10;
    frame.layer.shadowOffset = CGSizeMake(0, 0);
    frame.center=  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    [self.view addSubview:frame];
    
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
