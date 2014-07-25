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
#define ACCEPTABLE_CHARACTERS @"0123456789-"

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
bool didClickDone = false;

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
    [self loadSettings];
}

-(void)doneWithNumberPad{
    NSLog(@"doneWithNumberPad");
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


- (void) loadSettingsInMemory{
    Settings* properties = [Settings new];
    PassingTdWeight = [[properties getProperty:PASSING_TD] floatValue];
    PassingYardsWeight = [[properties getProperty:PASSING_YARDS] floatValue];
    DefenseFumbleRecoveryWeight = [[properties getProperty:DEFENSE_FUMREC] floatValue];
    PassingAttemptsWeight = [[properties getProperty:PASSING_ATTEMPTS] floatValue];
    PassingIntWeight = [[properties getProperty:PASSING_INT] floatValue];
    RushingYardsWeight = [[properties getProperty:RUSHING_YARDS] floatValue];
    RushingTdWeight = [[properties getProperty:RUSHING_TD] floatValue];
    RushingAttemptsWeight = [[properties getProperty:RUSHING_ATTEMPS] floatValue];
    ReceivingYardsWeight = [[properties getProperty:RECEIVING_YARDS] floatValue];
    ReceivingReceptionsWeight = [[properties getProperty:RECEIVING_RECEPTIONS] floatValue];
    ReceivingTdWeight = [[properties getProperty:RECEIVING_TD] floatValue];
    KickingXpWeight = [[properties getProperty:KICKING_XP] floatValue];
    KickingFgWeight = [[properties getProperty:KICKING_FG] floatValue];
    KickingFg50Weight = [[properties getProperty:KICKING_FG50] floatValue];
    DefenseTdWeight = [[properties getProperty:DEFENSE_TD] floatValue];
    DefenseInterceptionWeight = [[properties getProperty:DEFENSE_INTERCEPTION] floatValue];
    DefenseSackWeight = [[properties getProperty:DEFENSE_SACK] floatValue];
    DefenseSafetyWeight = [[properties getProperty:DEFENSE_SAFETY] floatValue];
    DefenseSpTdWeight = [[properties getProperty:DEFENSE_SPTD] floatValue];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_activityIndicator setHidesWhenStopped:YES];

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
                            [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];

    
    [numberToolbar sizeToFit];

    PassingTd.inputAccessoryView = numberToolbar;
    PassingTd.delegate = self;
    PassingYards.inputAccessoryView = numberToolbar;
    PassingYards.delegate = self;
    DefenseFumbleRecovery.inputAccessoryView = numberToolbar;
    DefenseFumbleRecovery.delegate = self;
    PassingAttempts.inputAccessoryView = numberToolbar;
    PassingAttempts.delegate = self;
    PassingInt.inputAccessoryView = numberToolbar;
    PassingInt.delegate = self;
    RushingYards.inputAccessoryView = numberToolbar;
    RushingYards.delegate = self;
    RushingTd.inputAccessoryView = numberToolbar;
    RushingTd.delegate = self;
    RushingAttempts.inputAccessoryView = numberToolbar;
    RushingAttempts.delegate = self;
    ReceivingYards.inputAccessoryView = numberToolbar;
    ReceivingYards.delegate = self;
    ReceivingReceptions.inputAccessoryView = numberToolbar;
    ReceivingReceptions.delegate = self;
    ReceivingTd.inputAccessoryView = numberToolbar;
    ReceivingTd.delegate = self;
    KickingXp.inputAccessoryView = numberToolbar;
    KickingXp.delegate = self;
    KickingFg.inputAccessoryView = numberToolbar;
    KickingFg.delegate = self;
    KickingFg50.inputAccessoryView = numberToolbar;
    KickingFg50.delegate = self;
    DefenseTd.inputAccessoryView = numberToolbar;
    DefenseTd.delegate = self;
    DefenseInterception.inputAccessoryView = numberToolbar;
    DefenseInterception.delegate = self;
    DefenseSack.inputAccessoryView = numberToolbar;
    DefenseSack.delegate = self;
    DefenseSafety.inputAccessoryView = numberToolbar;
    DefenseSafety.delegate = self;
    DefenseSPTD.inputAccessoryView = numberToolbar;
    DefenseSPTD.delegate = self;
    //[[Settings new] resetTable];
    
    [self loadSettings];
    [self loadSettingsInMemory];

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
        [alertView addSubview:_activityIndicator];
        [_activityIndicator setHidden:NO];
        [alertView bringSubviewToFront:_activityIndicator];
        [_activityIndicator startAnimating];
        [settings resetTable];
        [self loadSettingsInMemory];
        [self loadSettings];
        [settings refreshScores];
        [_activityIndicator stopAnimating];

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
        if(buttonIndex == 0){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            //build connection - will need to replace URL String
            [_activityIndicator setHidden:NO];
            [_activityIndicator startAnimating];
            NSURL *url = [NSURL URLWithString:@"http://www.profootballfocus.com/toolkit/export/RyanWetter/?password=sdhjgkd5j45jhdgfyh4fhdf5h"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    
    }
    
    
}
- (IBAction)syncData:(id)sender {
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Sync Data" message:@"This will update all players projected stats.  Do you wish to continue?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [resetAlert show];
}

- (void) saveSettings{
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];

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
    [self loadSettingsInMemory];
    [_activityIndicator stopAnimating];

}

- (IBAction)saveButtonClick:(id)sender {
       ////NSLog(@"Test: %@",PassingTd.text);
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



#pragma mark - methods for connecting to feed
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    _players = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    [database performQuery:@"delete from player"];
    for(int i = 0; i< _players.count; i++)
    {
        
        
        float calcPassingYards = 0;
        float calcPassingTd = 0;
        float calcPassingAttempts = 0;
        float calcPassingInt = 0;
        float calcRushingYards = 0;
        float calcRushingTd = 0;
        float calcRushingAttempts = 0;
        float calcReceivingYards = 0;
        float calcReceivingReceptions = 0;
        float calcReceivingTd = 0;
        float calcKickingXp = 0;
        float calcKickingFg =0;
        float calcKickingFg50 = 0;
        float calcDefenseTd = 0;
        float calcDefenseInterception = 0;
        float calcDefenseSack = 0;
        float calcDefenseSafety = 0;
        float calcDefenseSpTd = 0;
        float calcDefenseFumRec = 0;
        
        //heyy
        NSNumber *passTdNumber = [[_players objectAtIndex: i] objectForKey:@"Pass TD"];
        if(passTdNumber != [NSNull null]){
            calcPassingTd = PassingTdWeight * [passTdNumber floatValue];
        }
        
        
        NSNumber *passYardsNumber = [[_players objectAtIndex: i] objectForKey:@"Pass Yds"];
        if(passYardsNumber != [NSNull null]){
            calcPassingYards = PassingYardsWeight * ([passYardsNumber floatValue] / 25);
        }
        
        
        NSNumber *passingAttemptsNumber = [[_players objectAtIndex: i] objectForKey:@"Pass Att"];
        if(passingAttemptsNumber != [NSNull null]){
            calcPassingAttempts = PassingAttemptsWeight * [passingAttemptsNumber floatValue];
        }
        
        NSNumber *passingIntNumber = [[_players objectAtIndex: i] objectForKey:@"Pass Int"];
        if(passingIntNumber != [NSNull null]){
            calcPassingInt = PassingIntWeight * [passingIntNumber floatValue];
        }
        
        NSNumber *rushingYardsNumber = [[_players objectAtIndex: i] objectForKey:@"Rush Yds"];
        if(rushingYardsNumber != [NSNull null]){
            calcRushingYards = PassingYardsWeight * ([rushingYardsNumber floatValue] / 10);
        }
        
        NSNumber *rushingTdNumber = [[_players objectAtIndex: i] objectForKey:@"Rush TD"];
        if(rushingTdNumber != [NSNull null]){
            calcRushingTd = RushingTdWeight * [rushingTdNumber floatValue];
        }
        
        NSNumber *rushingAttempsNumber = [[_players objectAtIndex: i] objectForKey:@"Rush Att"];
        if(rushingAttempsNumber != [NSNull null]){
            calcRushingAttempts = RushingAttemptsWeight * [rushingAttempsNumber floatValue];
        }
        
        NSNumber *receivingYardsNumber = [[_players objectAtIndex: i] objectForKey:@"Rec Yds"];
        if(receivingYardsNumber != [NSNull null]){
            calcReceivingYards = ReceivingYardsWeight * ([receivingYardsNumber floatValue] / 10);
        }
        
        
        NSNumber *receivingReceptionsNumber = [[_players objectAtIndex: i] objectForKey:@"Rush Att"];
        if(receivingReceptionsNumber != [NSNull null]){
            calcReceivingReceptions = ReceivingReceptionsWeight * [receivingReceptionsNumber floatValue];
        }
        
        NSNumber *receivingTdNumber = [[_players objectAtIndex: i] objectForKey:@"Rec TD"];
        if(receivingTdNumber != [NSNull null]){
            calcReceivingTd = ReceivingTdWeight * [receivingTdNumber floatValue];
        }
        
        NSNumber *kickingXpNumber = [[_players objectAtIndex: i] objectForKey:@"XP"];
        if(kickingXpNumber != [NSNull null]){
            calcKickingXp = KickingXpWeight * [kickingXpNumber floatValue];
        }
        
        
        NSNumber *kickingFgNumber = [[_players objectAtIndex: i] objectForKey:@"FG"];
        if(kickingFgNumber != [NSNull null]){
            calcKickingFg = KickingFgWeight * [kickingFgNumber floatValue];
        }
        
        NSNumber *kickingFg50Number = [[_players objectAtIndex: i] objectForKey:@"FG50"];
        if(kickingFg50Number != [NSNull null]){
            calcKickingFg50 = KickingFg50Weight * [kickingFg50Number floatValue];
        }
        
        NSNumber *defenseTdNumber = [[_players objectAtIndex: i] objectForKey:@"DefTD"];
        if(defenseTdNumber != [NSNull null]){
            calcDefenseTd = DefenseTdWeight * [defenseTdNumber floatValue];
        }
        
        NSNumber *defenseInterceptionNumber = [[_players objectAtIndex: i] objectForKey:@"DefInt"];
        if(defenseInterceptionNumber != [NSNull null]){
            calcDefenseInterception = DefenseInterceptionWeight * [defenseInterceptionNumber floatValue];
        }
        
        NSNumber *defenseSackNumber = [[_players objectAtIndex: i] objectForKey:@"DefSack"];
        if(defenseSackNumber != [NSNull null]){
            calcDefenseSack = DefenseSackWeight * [defenseSackNumber floatValue];
        }
        
        
        NSNumber *defenseSafetyNumber = [[_players objectAtIndex: i] objectForKey:@"RushSafety"];
        if(defenseSafetyNumber != [NSNull null]){
            calcDefenseSafety = DefenseSafetyWeight * [defenseSafetyNumber floatValue];
        }
        
        
        NSNumber *defenseSpTdNumber = [[_players objectAtIndex: i] objectForKey:@"DefSP TD"];
        if(defenseSpTdNumber != [NSNull null]){
            calcDefenseSpTd = DefenseSpTdWeight * [defenseSpTdNumber floatValue];
        }
        
        NSNumber *defenseFumRecNumber = [[_players objectAtIndex: i] objectForKey:@"DefFum"];
        if(defenseFumRecNumber != [NSNull null]){
            calcDefenseFumRec = DefenseFumbleRecoveryWeight * [defenseFumRecNumber floatValue];
        }
        
        
        
        float score = calcPassingYards + calcPassingTd + calcPassingInt + calcRushingYards +calcRushingTd + calcRushingAttempts + calcReceivingYards + calcReceivingReceptions + calcReceivingTd + calcKickingXp + calcKickingFg + calcKickingFg50 + calcDefenseTd + calcDefenseInterception + calcDefenseSack + calcDefenseSpTd +calcDefenseFumRec;
        
        
        NSString *scoreAsString = [[NSNumber numberWithFloat:score] stringValue];
        
        NSLog(@"Score... %@",scoreAsString);
        
        NSString *refreshPlayers = [NSString stringWithFormat:@"insert into player (pid, player, pos, team, adp, passcomp,passatt, passyds, passtd,int,rushatt,rushyds,rushtd,rec,recyds, rectd, xp, fg, fg50, deftd, deffum, defint,defsack, defsafety, bye, opponent, news, score,defsptd) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[_players objectAtIndex: i] objectForKey:@"PID"], [[_players objectAtIndex: i] objectForKey:@"Player"], [[_players objectAtIndex: i] objectForKey:@"Pos"], [[_players objectAtIndex: i] objectForKey:@"Team"], [[_players objectAtIndex: i] objectForKey:@"ADP"], [[_players objectAtIndex: i] objectForKey:@"Pass Comp"], [[_players objectAtIndex: i] objectForKey:@"Pass Att"], [[_players objectAtIndex: i] objectForKey:@"Pass Yds"], [[_players objectAtIndex: i] objectForKey:@"Pass TD"], [[_players objectAtIndex: i] objectForKey:@"INT"], [[_players objectAtIndex: i] objectForKey:@"Rush Att"], [[_players objectAtIndex: i] objectForKey:@"Rush Yds"], [[_players objectAtIndex: i] objectForKey:@"Rush TD"], [[_players objectAtIndex: i] objectForKey:@"Rec"], [[_players objectAtIndex: i] objectForKey:@"Rec Yds"], [[_players objectAtIndex: i] objectForKey:@"Rec TD"], [[_players objectAtIndex: i] objectForKey:@"XP"], [[_players objectAtIndex: i] objectForKey:@"FG"], [[_players objectAtIndex: i] objectForKey:@"FG50"], [[_players objectAtIndex: i] objectForKey:@"DefTD"], [[_players objectAtIndex: i] objectForKey:@"DefFum"], [[_players objectAtIndex: i] objectForKey:@"DefInt"], [[_players objectAtIndex: i] objectForKey:@"DefSack"], [[_players objectAtIndex: i] objectForKey:@"DefSafety"], [[_players objectAtIndex: i] objectForKey:@"Bye"], [[_players objectAtIndex: i] objectForKey:@"Opponent"], [[_players objectAtIndex: i] objectForKey:@"News"],scoreAsString,[[_players objectAtIndex: i] objectForKey:@"DefSP TD"]];
        [database performQuery:refreshPlayers];
         //NSLog(@"%@",refreshPlayers);
    }
    NSArray *lastSyncDate = [database performQuery:@"select date from last_sync_date"];
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currDateString = [DateFormatter stringFromDate:[NSDate date]];
    if(lastSyncDate.count == 0) {
        [database performQuery:[NSString stringWithFormat:@"insert into last_sync_date (date) values (\"%@\")",currDateString]];
    } else {
        [database performQuery:[NSString stringWithFormat:@"update last_sync_date set date = \"%@\"",currDateString]];
    }
    [database closeConnection];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_activityIndicator stopAnimating];

}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //TODO do something here
    //NSLog(@"Failed!!!");
    //stop the networkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_activityIndicator stopAnimating];

    
}

#pragma mark - text fields
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL validLength = YES;
    BOOL validChar = NO;
    BOOL isNumber = NO;
    NSString *newString = [[textField.text stringByAppendingString:string]
                           stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if(newString.length != 0){
    NSUInteger newLength = [newString length]  - range.length;
    if(newLength > 2) {
        validLength = NO;
    }
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    if([string isEqualToString:filtered]){
        validChar = YES;
    }
    isNumber = isNumeric([textField.text stringByAppendingString:string]);
    return (validLength && validChar && isNumber) ? YES :NO;
}

BOOL isNumeric(NSString *s)
{
    NSUInteger len = [s length];
    NSUInteger i;
    BOOL status = NO;
    
    for(i=0; i < len; i++)
    {
        unichar singlechar = [s characterAtIndex: i];
        if ( (singlechar == ' ') && (!status) )
        {
            continue;
        }
        if ( ( singlechar == '+' ||
              singlechar == '-' ) && (!status) ) { status=YES; continue; }
        if ( ( singlechar >= '0' ) &&
            ( singlechar <= '9' ) )
        {
            status = YES;
        } else {
            return NO;
        }
    }
    return (i == len) && status;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"doneWithNumberPad from textFieldShouldReturn");
    [self doneWithNumberPad];
    didClickDone = true;
    return YES;
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
