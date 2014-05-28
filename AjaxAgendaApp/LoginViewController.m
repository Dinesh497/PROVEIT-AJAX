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
    
    _LoginFrame.layer.cornerRadius = 15;
    
    [self dbConnectie];
    [self usernameArray];
    [self passwordArray];
}

//----------------------------------------------------------------------------------------------------------
// Database
//----------------------------------------------------------------------------------------------------------

- (void) dbConnectie {
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    _databasePath = [[NSBundle mainBundle]
                     pathForResource:@"ajaxtraining1" ofType:@"db" ];
}

- (void) usernameArray {
    
    const char *dbpath = [_databasePath UTF8String];
    _Usernames =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            
            NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select username from trainers where id = '%d'", index];
            const char *querya1_stmt = [queryplayersa1_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_Usernames addObject:username];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In username array zitten: %@",_Usernames);
    
}

- (void) passwordArray {
    
    const char *dbpath = [_databasePath UTF8String];
    _passwords =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
            
            NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select password from trainers where id = '%d'", index];
            const char *querya1_stmt = [queryplayersa1_sql UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_passwords addObject:password];
                }
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In password array zitten: %@",_passwords);
}

- (int) GetArticlesCount
{
    int count = 0;
    if (sqlite3_open([_databasePath UTF8String], &_ajaxtrainingDB) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT COUNT(*) FROM players";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(_ajaxtrainingDB, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_ajaxtrainingDB) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(_ajaxtrainingDB);
    }
    
    return count;
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
        UIAlertView *wrongPassword = [[UIAlertView alloc] initWithTitle:@"Verkeerd wachtwoord" message:@"Wachtwoord of trainer is verkeerd ingevuld" delegate:self cancelButtonTitle:@"Opnieuw" otherButtonTitles:nil];
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
    NSString *Password;
    
    const char *dbpath = [_databasePath UTF8String];
    _passwords =[[NSMutableArray alloc] init];
    
    int rows = [self GetArticlesCount];
    
    if (sqlite3_open(dbpath, &_ajaxtrainingDB) == SQLITE_OK)
    {
        for (int index = 1; index <= rows; index++) {
        
            NSString *queryplayersa1_sql = [NSString stringWithFormat:@"Select password from trainers where id = '%d' and username = '%@'", index, Trainername];
            const char *querya1_stmt = [queryplayersa1_sql UTF8String];
            sqlite3_stmt *statement;
        
            if (sqlite3_prepare_v2(_ajaxtrainingDB, querya1_stmt, -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    Password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    [_passwords addObject:Password];
                }
            sqlite3_finalize(statement);
            }
        }
        sqlite3_close(_ajaxtrainingDB);
    }
    NSLog(@"In password array zitten: %@",_passwords);

    return Password;
}


@end
