//
//  TrainingInfoViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 27-03-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "TrainingInfoViewController.h"

@interface TrainingInfoViewController (){
    UIView *VeldView;
}

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
    // Select the field position for the training
    
    // Create view to select field
    VeldView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 20.0, 280.0, 464.0)];
    VeldView.backgroundColor = [UIColor whiteColor];
    VeldView.layer.cornerRadius = 10;
    VeldView.layer.shadowColor = [[UIColor blackColor] CGColor];
    VeldView.layer.shadowOpacity = 1;
    VeldView.layer.shadowRadius = 10;
    VeldView.layer.shadowOffset = CGSizeMake(0, 0);
    VeldView.center=  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    // Add Veld 1 button to subview
    UIButton *Veld1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Veld1.frame = CGRectMake(80, 100, 120, 40);
    [Veld1 setTitle:@"Veld 1" forState:UIControlStateNormal];
    [Veld1 addTarget:self action:@selector(getVeld) forControlEvents:UIControlEventTouchUpInside];
    [VeldView addSubview:Veld1];
    
    // Add selecteer button to subView
    UIButton *Selecteer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Selecteer.frame = CGRectMake(80, 400, 120, 40);
    [Selecteer setTitle:@"Terug" forState:UIControlStateNormal];
    [Selecteer addTarget:self action:@selector(getVeld) forControlEvents:UIControlEventTouchUpInside];
    [VeldView addSubview:Selecteer];
    
    // Add the subView to the viewController
    [self.view addSubview:VeldView];
}

- (void) getVeld{
    // When Selecteer button is pressed in the SelectVeld subview
    [VeldView removeFromSuperview];
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
