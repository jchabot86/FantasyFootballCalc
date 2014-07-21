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
#import "Settings.h"

@interface SettingsViewController ()
{
    SQLite *database;
}
@end

@implementation SettingsViewController

@synthesize PassingYards;
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
@synthesize scrolldown;
@synthesize DefenseSPTD;
@synthesize DefenseFumbleRecovery;

float PassingTdWeight;
float PassingYardsWeight;
float DefenseFumbleRecoveryWeight;
float PassingAttemptsWeight;
float PassingIntWeight;
float RushingYardsWeight;
float RushingTdWeight;
float RushingAttemptsWeight;
float ReceivingYardsWeight;
float ReceivingReceptionsWeight;
float ReceivingTdWeight;
float KickingXpWeight;
float KickingFgWeight;
float KickingFg50Weight;
float DefenseTdWeight;
float DefenseInterceptionWeight;
float DefenseSackWeight;
float DefenseSafetyWeight;
float DefenseSpTdWeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)cancelNumberPad{
    [self loadSettings];
    //[PassingTd resignFirstResponder];
    //PassingTd.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = PassingTd.text;
    [PassingTd resignFirstResponder];
    [PassingTd resignFirstResponder];
    [PassingYards resignFirstResponder];
    [DefenseFumbleRecovery resignFirstResponder];
    [PassingAttempts resignFirstResponder];
    [PassingInt resignFirstResponder];
    [RushingYards resignFirstResponder];
    [RushingTd resignFirstResponder];
    [RushingAttempts resignFirstResponder];
    [ReceivingYards resignFirstResponder];
    [ReceivingReceptions resignFirstResponder];
    [ReceivingTd resignFirstResponder];
    [KickingXp resignFirstResponder];
    [KickingFg resignFirstResponder];
    [KickingFg50 resignFirstResponder];
    [DefenseTd resignFirstResponder];
    [DefenseInterception resignFirstResponder];
    [DefenseSack resignFirstResponder];
    [DefenseSafety resignFirstResponder];
    [DefenseSPTD resignFirstResponder];
    
    [self saveSettings];
    //PassingTd.inputAccessoryView = numberFromTheKeyboard;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52.0f/255.0f green:111.0f/255.0f blue:200.0f/255.0f alpha:255.0f/255.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    // Do any additional setup after loading the view.
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    /*numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];*/
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];

    
    [numberToolbar sizeToFit];

    PassingTd.inputAccessoryView = numberToolbar;
    PassingYards.inputAccessoryView = numberToolbar;
    DefenseFumbleRecovery.inputAccessoryView = numberToolbar;
    PassingAttempts.inputAccessoryView = numberToolbar;
    PassingInt.inputAccessoryView = numberToolbar;
    RushingYards.inputAccessoryView = numberToolbar;
    RushingTd.inputAccessoryView = numberToolbar;
    RushingAttempts.inputAccessoryView = numberToolbar;
    ReceivingYards.inputAccessoryView = numberToolbar;
    ReceivingReceptions.inputAccessoryView = numberToolbar;
    ReceivingTd.inputAccessoryView = numberToolbar;
    KickingXp.inputAccessoryView = numberToolbar;
    KickingFg.inputAccessoryView = numberToolbar;
    KickingFg50.inputAccessoryView = numberToolbar;
    DefenseTd.inputAccessoryView = numberToolbar;
    DefenseInterception.inputAccessoryView = numberToolbar;
    DefenseSack.inputAccessoryView = numberToolbar;
    DefenseSafety.inputAccessoryView = numberToolbar;
    DefenseSPTD.inputAccessoryView = numberToolbar;
    //[[Settings new] resetTable];
    
    [self loadSettings];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cutAllPlayers:(id)sender {
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Reset My Team" message: @"Do you want to remove all the players from My Team?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [updateAlert show];
}

- (IBAction)resetScoring:(id)sender {
    
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Reset Scoring" message: @"Do you want to reset all scoring back to their default values?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [updateAlert show];

    
}


- (IBAction)resetPlayerList:(id)sender {
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Reset Players" message:@"Do you want to reset your player list?  This will bring back players you have removed from the Player List." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [resetAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:@"Reset Scoring"]){
    if(buttonIndex==0)
    {
        Settings *settings = [Settings new];
        [settings refreshScores];
        [self loadSettings];
    }
    } else if ([alertView.title isEqualToString:@"Reset Players"]){
        if(buttonIndex == 0){
        database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
        [database performQuery:@"delete from removed_players"];
        [database closeConnection];
        }

    } else if ([alertView.title isEqualToString:@"Reset My Team"]){
        if(buttonIndex == 0){
            database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
            [database performQuery:@"delete from team where key = 0"];
            [database closeConnection];

        }
    } else if([alertView.title isEqualToString:@"Sync Data"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //build connection - will need to replace URL String
       // NSURL *url = [NSURL URLWithString:@"http://www.profootballfocus.com/toolkit/export/RyanWetter/?password=sdhjgkd5j45jhdgfyh4fhdf5h"];
        //NSURLRequest *request = [NSURLRequest requestWithURL:url];
       // [[NSURLConnection alloc] initWithRequest:request delegate:self];
        Settings *settings = [Settings new];
        [settings refreshScores];
        [self loadSettings];


    
    }
    
    
}
- (IBAction)syncData:(id)sender {
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Sync Data" message:@"This will update all players projected stats.  Do you wish to continue?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [resetAlert show];
}

- (void) saveSettings{
    
    Settings* properties = [Settings new];
    
    [properties setProperty:PASSING_TD:PassingTd.text];
    [properties setProperty:PASSING_YARDS:PassingYards.text];
    [properties setProperty:DEFENSE_FUMREC:DefenseFumbleRecovery.text];
    [properties setProperty:PASSING_ATTEMPTS:PassingAttempts.text];
    [properties setProperty:PASSING_INT:PassingInt.text];
    [properties setProperty:RUSHING_YARDS:RushingYards.text];
    [properties setProperty:RUSHING_TD:RushingTd.text];
    [properties setProperty:RUSHING_ATTEMPS:RushingAttempts.text];
    [properties setProperty:RECEIVING_YARDS:ReceivingYards.text];
    [properties setProperty:RECEIVING_RECEPTIONS:ReceivingReceptions.text];
    [properties setProperty:RECEIVING_TD:ReceivingTd.text];
    [properties setProperty:KICKING_XP:KickingXp.text];
    [properties setProperty:KICKING_FG:KickingFg.text];
    [properties setProperty:KICKING_FG50:KickingFg50.text];
    [properties setProperty:DEFENSE_TD:DefenseTd.text];
    [properties setProperty:DEFENSE_INTERCEPTION:DefenseInterception.text];
    [properties setProperty:DEFENSE_SACK:DefenseSack.text];
    [properties setProperty:DEFENSE_SAFETY:DefenseSafety.text];
    [properties setProperty:DEFENSE_SPTD:DefenseSPTD.text];
    
    [properties refreshScores];
}

- (IBAction)saveButtonClick:(id)sender {
       //NSLog(@"Test: %@",PassingTd.text);
}

- (void) loadSettings{
    Settings* properties = [Settings new];
    PassingTd.text = [properties getProperty:PASSING_TD];
    PassingYards.text = [properties getProperty:PASSING_YARDS];
    DefenseFumbleRecovery.text = [properties getProperty:DEFENSE_FUMREC];
    PassingAttempts.text = [properties getProperty:PASSING_ATTEMPTS];
    PassingInt.text = [properties getProperty:PASSING_INT];
    RushingYards.text = [properties getProperty:RUSHING_YARDS];
    RushingTd.text = [properties getProperty:RUSHING_TD];
    RushingAttempts.text = [properties getProperty:RUSHING_ATTEMPS];
    ReceivingYards.text = [properties getProperty:RECEIVING_YARDS];
    ReceivingReceptions.text = [properties getProperty:RECEIVING_RECEPTIONS];
    ReceivingTd.text = [properties getProperty:RECEIVING_TD];
    KickingXp.text = [properties getProperty:KICKING_XP];
    KickingFg.text = [properties getProperty:KICKING_FG];
    KickingFg50.text = [properties getProperty:KICKING_FG50];
    DefenseTd.text = [properties getProperty:DEFENSE_TD];
    DefenseInterception.text = [properties getProperty:DEFENSE_INTERCEPTION];
    DefenseSack.text = [properties getProperty:DEFENSE_SACK];
    DefenseSafety.text = [properties getProperty:DEFENSE_SAFETY];
    DefenseSPTD.text = [properties getProperty:DEFENSE_SPTD];
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
