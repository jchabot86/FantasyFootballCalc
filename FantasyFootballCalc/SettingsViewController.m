//
//  SettingsViewController.m
//  FantasyFootballCalc
//
//  Created by Jon on 7/6/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "SettingsViewController.h"
#import "SQLite.h"
#import "Config.h"

@interface SettingsViewController ()
{
    SQLite *database;
}
@end

@implementation SettingsViewController

@synthesize PassingYards;
@synthesize PassingCompletion;
@synthesize PassingAttempts;
@synthesize PassingTd;
@synthesize PassingInt;
@synthesize RushingYards;
@synthesize RushingTd;
@synthesize RushingAttempts;
@synthesize ReceivingYards;
@synthesize ReceivingReceptions;
@synthesize ReceivingTd;
@synthesize KickingXp;
@synthesize KickingFg;
@synthesize KickingFg50;
@synthesize DefenseTd;
@synthesize DefenseInterception;
@synthesize DefenseSack;
@synthesize DefenseSafety;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)cancelNumberPad{
    [PassingTd resignFirstResponder];
    PassingTd.text = @"";
}

-(void)doneWithNumberPad{
    NSString *numberFromTheKeyboard = PassingTd.text;
    [PassingTd resignFirstResponder];
    PassingTd.text = numberFromTheKeyboard;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [numberToolbar sizeToFit];
    PassingTd.inputAccessoryView = numberToolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cutAllPlayers:(id)sender {
    database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    [database performQuery:@"delete from team where key = 0"];
    [database closeConnection];
    //need to refresh players list
}

- (IBAction)buttonTest:(id)sender {
    
    NSLog(@"Test: %@",PassingTd.text);
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
