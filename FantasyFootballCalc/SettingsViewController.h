//
//  SettingsViewController.h
//  FantasyFootballCalc
//
//  Created by Jon on 7/6/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSMutableData *data;
@property (strong, nonatomic) IBOutlet UITextField *PassingYards;
@property (strong, nonatomic) IBOutlet UITextField *PassingAttempts;
@property (strong, nonatomic) IBOutlet UITextField *PassingTd;
@property (strong, nonatomic) IBOutlet UITextField *PassingInt;
@property (strong, nonatomic) IBOutlet UITextField *RushingYards;
@property (strong, nonatomic) IBOutlet UITextField *RushingTd;
@property (strong, nonatomic) IBOutlet UITextField *RushingAttempts;
@property (strong, nonatomic) IBOutlet UITextField *ReceivingYards;
@property (strong, nonatomic) IBOutlet UITextField *ReceivingReceptions;
@property (strong, nonatomic) IBOutlet UITextField *ReceivingTd;
@property (strong, nonatomic) IBOutlet UITextField *KickingXp;
@property (strong, nonatomic) IBOutlet UITextField *KickingFg;
@property (strong, nonatomic) IBOutlet UITextField *KickingFg50;
@property (strong, nonatomic) IBOutlet UITextField *DefenseTd;
@property (strong, nonatomic) IBOutlet UITextField *DefenseInterception;
@property (strong, nonatomic) IBOutlet UITextField *DefenseSack;
@property (strong, nonatomic) IBOutlet UITextField *DefenseSPTD;
@property (strong, nonatomic) IBOutlet UITextField *DefenseSafety;
@property (strong, nonatomic) IBOutlet UITextField *DefenseFumbleRecovery;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolldown;
@property (strong, nonatomic) IBOutlet UIButton *syncDataButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
