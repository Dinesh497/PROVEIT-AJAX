//
//  OefeningenViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 17-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "OefeningenViewController.h"

@interface OefeningenViewController ()

@property NSMutableArray *SelectedOefeningen;

@end

@implementation OefeningenViewController

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
    
    _Form.layer.cornerRadius = 10;
    
    [_scrollForm setScrollEnabled:YES];
    [_scrollForm setDirectionalLockEnabled:YES];
    [_scrollForm showsVerticalScrollIndicator];
    
    _SelectedOefeningen = [[NSMutableArray alloc] init];
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

- (IBAction)saveData:(id)sender {
    // Gereed button pressed
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_SelectedOefeningen forKey:@"SelectedOefeningenArray"];
}

- (IBAction)ReturnButtonExtraInfoPressed:(id)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)pressedAfwerken:(id)sender {
    if (_buttonAfwerken.selected) {
        [_buttonAfwerken setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Afwerken"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonAfwerken setSelected:YES];
        [_SelectedOefeningen addObject:@"Afwerken"];
    }
}

- (IBAction)pressedAnders:(id)sender {
    if (_buttonAnders.selected) {
        [_buttonAnders setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Anders"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonAnders setSelected:YES];
        [_SelectedOefeningen addObject:@"Anders"];
    }
}

- (IBAction)pressedCornerTrap:(id)sender {
    if (_buttonCornerTrap.selected) {
        [_buttonCornerTrap setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Corner"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonCornerTrap setSelected:YES];
        [_SelectedOefeningen addObject:@"Corner"];
    }
}

- (IBAction)pressedIngooien:(id)sender {
    if (_buttonIngooien.selected) {
        [_buttonIngooien setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Ingooien"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonIngooien setSelected:YES];
        [_SelectedOefeningen addObject:@"Ingooien"];
    }
}

- (IBAction)pressedKaatsen:(id)sender {
    if (_buttonKaatsen.selected) {
        [_buttonKaatsen setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Kaatsen"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonKaatsen setSelected:YES];
        [_SelectedOefeningen addObject:@"Kaatsen"];
    }
}

- (IBAction)pressedKoppen:(id)sender {
    if (_buttonKoppen.selected) {
        [_buttonKoppen setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Koppen"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonKoppen setSelected:YES];
        [_SelectedOefeningen addObject:@"Koppen"];
    }
}

- (IBAction)pressedPartijspel:(id)sender {
    if (_buttonPartijspel.selected) {
        [_buttonPartijspel setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Partijspel"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonPartijspel setSelected:YES];
        [_SelectedOefeningen addObject:@"Partijspel"];
    }
}

- (IBAction)pressedPositiespel:(id)sender {
    if (_buttonPositiespel.selected) {
        [_buttonPositiespel setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Positiespel"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonPositiespel setSelected:YES];
        [_SelectedOefeningen addObject:@"Positiespel"];
    }
}

- (IBAction)pressedRondo:(id)sender {
    if (_buttonRondo.selected) {
        [_buttonRondo setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Rondo"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonRondo setSelected:YES];
        [_SelectedOefeningen addObject:@"Rondo"];
    }
}

- (IBAction)pressedUitloop:(id)sender {
    if (_buttonUitloop.selected) {
        [_buttonUitloop setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Uitloop"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonUitloop setSelected:YES];
        [_SelectedOefeningen addObject:@"Uitloop"];
    }
}

- (IBAction)pressedVS:(id)sender {
    if (_buttonVS.selected) {
        [_buttonVS setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"VS"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonVS setSelected:YES];
        [_SelectedOefeningen addObject:@"VS"];
    }
}

- (IBAction)pressedWarmingUp:(id)sender {
    if (_buttonWarmingUp.selected) {
        [_buttonWarmingUp setSelected:NO];
        NSInteger indexOfPlayer = [_SelectedOefeningen indexOfObject:@"Warmingup"];
        [_SelectedOefeningen removeObjectAtIndex:indexOfPlayer];
    } else{
        [_buttonWarmingUp setSelected:YES];
        [_SelectedOefeningen addObject:@"Warmingup"];
    }
}

@end
