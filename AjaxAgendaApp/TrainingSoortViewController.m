//
//  TrainingSoortViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 12-05-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "TrainingSoortViewController.h"

@interface TrainingSoortViewController ()
@property NSString *SelectedCategory;
@end

@implementation TrainingSoortViewController

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

- (IBAction)movementTraining:(id)sender {
    _SelectedCategory = @"Movement training";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_SelectedCategory forKey:@"Category"];
}

- (IBAction)veldTraining:(id)sender {
    _SelectedCategory = @"Veld training";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_SelectedCategory forKey:@"Category"];
}

- (IBAction)revalidatieTraining:(id)sender {
    _SelectedCategory = @"Revalidatie training";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_SelectedCategory forKey:@"Category"];
}
@end
