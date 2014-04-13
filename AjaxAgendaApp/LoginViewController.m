//
//  ViewController.m
//  AjaxAgendaApp
//
//  Created by Dinesh Bhagwandin on 11-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TrainerTextDidExit:(id)sender {
    // Return button on keyboard pressed
    [sender resignFirstResponder];
}

- (IBAction)WachtwoordTextDidExit:(id)sender {
    
    // Return button on keyboard pressed
    [sender resignFirstResponder];
    
    NSString *Trainer = _TrainerTextField.text;
    NSString *ingevoerdeWachtwoord = _WachtwoordTextField.text;
    NSString *correcteWachtwoord = [self PasswordfromDatabase:Trainer];
    
    if ([ingevoerdeWachtwoord isEqualToString:correcteWachtwoord]) {
        // If the password is correct
        [self GotoNavigationView];
    } else {
        // If the password is incorrect
        UIAlertView *wrongPassword = [[UIAlertView alloc] initWithTitle:@"Verkeerd wachtwoord" message:@"Wachtwoord komt niet overeen met trainer" delegate:self cancelButtonTitle:@"Opnieuw" otherButtonTitles:nil];
        [wrongPassword show];
    }
}

- (void)GotoNavigationView{
    // Go to navigation view in storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NavigationView"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (NSString*) PasswordfromDatabase:(NSString*)Trainername{
    // Get password from database from the using Trainer
    NSString *Password = Trainername;
    return Password;
}


@end
