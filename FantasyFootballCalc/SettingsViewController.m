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
#import "DataHelper.h"

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
@synthesize scrolldown;

float PassingTdWeight;
float PassingYardsWeight;
float PassingCompletionWeight;
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
    [PassingCompletion resignFirstResponder];
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
    PassingCompletion.inputAccessoryView = numberToolbar;
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
        DataHelper *dataHelper = [DataHelper new];
        [dataHelper recalculatePlayerScores];
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
        DataHelper *dataHelper = [DataHelper new];
        [dataHelper importPlayerData];


    
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
    [properties setProperty:PASSING_COMPLETION:PassingCompletion.text];
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
    
    [properties refreshScores];
}

- (IBAction)saveButtonClick:(id)sender {
       //NSLog(@"Test: %@",PassingTd.text);
}

- (void) loadSettings{
    Settings* properties = [Settings new];
    PassingTd.text = [properties getProperty:PASSING_TD];
    PassingYards.text = [properties getProperty:PASSING_YARDS];
    PassingCompletion.text = [properties getProperty:PASSING_COMPLETION];
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
}

/*- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
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
        float calcPassingCompletion = 0;
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
        
        
        NSNumber *passTdNumber = [[_players objectAtIndex: i] objectForKey:@"Pass TD"];
        if(passTdNumber != [NSNull null]){
            calcPassingTd = PassingTdWeight * [passTdNumber floatValue];
        }
        
        
        NSNumber *passYardsNumber = [[_players objectAtIndex: i] objectForKey:@"Pass Yds"];
        if(passYardsNumber != [NSNull null]){
            calcPassingYards = PassingYardsWeight * ([passYardsNumber floatValue] / 25);
        }
        
        NSNumber *passCompletionNumber = [[_players objectAtIndex: i] objectForKey:@"Pass Comp"];
        if(passCompletionNumber != [NSNull null]){
            calcPassingCompletion = PassingCompletionWeight * [passCompletionNumber floatValue];
        }
        
        
        NSNumber *passingAttemptsNumber = [[_players objectAtIndex: i] objectForKey:@"Pass Att"];
        if(passingAttemptsNumber != [NSNull null]){
            calcPassingAttempts = PassingCompletionWeight * [passingAttemptsNumber floatValue];
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
        
        
        float score = calcPassingYards + calcPassingTd + calcPassingCompletion + calcPassingAttempts + calcPassingInt + calcRushingYards +calcRushingTd + calcRushingAttempts + calcReceivingYards + calcReceivingReceptions + calcReceivingTd + calcKickingXp + calcKickingFg + calcKickingFg50 + calcDefenseTd + calcDefenseInterception + calcDefenseSack;
        
        NSString *scoreAsString = [[NSNumber numberWithFloat:score] stringValue];
        
        NSString *refreshPlayers = [NSString stringWithFormat:@"insert into player (pid, player, pos, team, adp, passcomp,passatt, passyds, passtd,int,rushatt,rushyds,rushtd,rec,recyds, rectd, xp, fg, fg50, deftd, deffum, defint,defsack, defsafety, bye, opponent, news, score) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[_players objectAtIndex: i] objectForKey:@"PID"], [[_players objectAtIndex: i] objectForKey:@"Player"], [[_players objectAtIndex: i] objectForKey:@"Pos"], [[_players objectAtIndex: i] objectForKey:@"Team"], [[_players objectAtIndex: i] objectForKey:@"ADP"], [[_players objectAtIndex: i] objectForKey:@"Pass Comp"], [[_players objectAtIndex: i] objectForKey:@"Pass Att"], [[_players objectAtIndex: i] objectForKey:@"Pass Yds"], [[_players objectAtIndex: i] objectForKey:@"Pass TD"], [[_players objectAtIndex: i] objectForKey:@"INT"], [[_players objectAtIndex: i] objectForKey:@"Rush Att"], [[_players objectAtIndex: i] objectForKey:@"Rush Yds"], [[_players objectAtIndex: i] objectForKey:@"Rush TD"], [[_players objectAtIndex: i] objectForKey:@"Rec"], [[_players objectAtIndex: i] objectForKey:@"Rec Yds"], [[_players objectAtIndex: i] objectForKey:@"Rec TD"], [[_players objectAtIndex: i] objectForKey:@"XP"], [[_players objectAtIndex: i] objectForKey:@"FG"], [[_players objectAtIndex: i] objectForKey:@"FG50"], [[_players objectAtIndex: i] objectForKey:@"DefTD"], [[_players objectAtIndex: i] objectForKey:@"DefFum"], [[_players objectAtIndex: i] objectForKey:@"DefInt"], [[_players objectAtIndex: i] objectForKey:@"DefSack"], [[_players objectAtIndex: i] objectForKey:@"DefSafety"], [[_players objectAtIndex: i] objectForKey:@"Bye"], [[_players objectAtIndex: i] objectForKey:@"Opponent"], [[_players objectAtIndex: i] objectForKey:@"News"],scoreAsString];
        [database performQuery:refreshPlayers];
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
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //TODO do something here
    NSLog(@"Failed!!!");
    //stop the networkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}*/



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
