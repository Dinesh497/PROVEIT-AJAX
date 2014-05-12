//
//  OefeningenViewController.m
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 17-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import "OefeningenViewController.h"

@interface OefeningenViewController ()

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

- (IBAction)pressedAfwerken:(id)sender {
    if (_buttonAfwerken.selected) {
        [_buttonAfwerken setSelected:NO];
    } else{
        [_buttonAfwerken setSelected:YES];
    }
}
- (IBAction)pressedAnders:(id)sender {
    if (_buttonAnders.selected) {
        [_buttonAnders setSelected:NO];
    } else{
        [_buttonAnders setSelected:YES];
    }
}
- (IBAction)pressedCornerTrap:(id)sender {
    if (_buttonCornerTrap.selected) {
        [_buttonCornerTrap setSelected:NO];
    } else{
        [_buttonCornerTrap setSelected:YES];
    }
}
- (IBAction)pressedIngooien:(id)sender {
    if (_buttonIngooien.selected) {
        [_buttonIngooien setSelected:NO];
    } else{
        [_buttonIngooien setSelected:YES];
    }
}
- (IBAction)pressedKaatsen:(id)sender {
    if (_buttonKaatsen.selected) {
        [_buttonKaatsen setSelected:NO];
    } else{
        [_buttonKaatsen setSelected:YES];
    }
}
- (IBAction)pressedKoppen:(id)sender {
    if (_buttonKoppen.selected) {
        [_buttonKoppen setSelected:NO];
    } else{
        [_buttonKoppen setSelected:YES];
    }
}
- (IBAction)pressedPartijspel:(id)sender {
    if (_buttonPartijspel.selected) {
        [_buttonPartijspel setSelected:NO];
    } else{
        [_buttonPartijspel setSelected:YES];
    }
}
- (IBAction)pressedPositiespel:(id)sender {
    if (_buttonPositiespel.selected) {
        [_buttonPositiespel setSelected:NO];
    } else{
        [_buttonPositiespel setSelected:YES];
    }
}
- (IBAction)pressedRondo:(id)sender {
    if (_buttonRondo.selected) {
        [_buttonRondo setSelected:NO];
    } else{
        [_buttonRondo setSelected:YES];
    }
}
- (IBAction)pressedUitloop:(id)sender {
    if (_buttonUitloop.selected) {
        [_buttonUitloop setSelected:NO];
    } else{
        [_buttonUitloop setSelected:YES];
    }
}
- (IBAction)pressedVS:(id)sender {
    if (_buttonVS.selected) {
        [_buttonVS setSelected:NO];
    } else{
        [_buttonVS setSelected:YES];
    }
}
- (IBAction)pressedWarmingUp:(id)sender {
    if (_buttonWarmingUp.selected) {
        [_buttonWarmingUp setSelected:NO];
    } else{
        [_buttonWarmingUp setSelected:YES];
    }
}
@end
