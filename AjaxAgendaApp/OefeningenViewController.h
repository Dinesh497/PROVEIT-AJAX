//
//  OefeningenViewController.h
//  AjaxAgendaApp
//
//  Created by Ralph Oud on 17-04-14.
//  Copyright (c) 2014 Prove IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OefeningenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollForm;
@property (weak, nonatomic) IBOutlet UIView *Form;


- (IBAction)pressedAfwerken:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonAfwerken;

- (IBAction)pressedAnders:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonAnders;

- (IBAction)pressedCornerTrap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonCornerTrap;

- (IBAction)pressedIngooien:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonIngooien;

- (IBAction)pressedKaatsen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonKaatsen;

- (IBAction)pressedKoppen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonKoppen;

- (IBAction)pressedPartijspel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonPartijspel;

- (IBAction)pressedPositiespel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonPositiespel;

- (IBAction)pressedRondo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRondo;

- (IBAction)pressedUitloop:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonUitloop;

- (IBAction)pressedVS:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonVS;

- (IBAction)pressedWarmingUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonWarmingUp;

@end
