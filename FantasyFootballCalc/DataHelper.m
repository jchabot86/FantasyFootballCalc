//
//  DataHelper.m
//  FantasyFootballCalc
//
//  Created by Justin Port on 7/20/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "DataHelper.h"
#import "Settings.h"
#import "SQLite.h"
#import "Config.h"

@implementation DataHelper


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
float DefenseSpTdWeight;


- (void)importPlayerData{
    //build connection - will need to replace URL String
    NSURL *url = [NSURL URLWithString:@"http://www.profootballfocus.com/toolkit/export/RyanWetter/?password=sdhjgkd5j45jhdgfyh4fhdf5h"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)recalculatePlayerScores{
    Settings *settings = [Settings new];
    [settings resetTable];
    [settings refreshScores];
}


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
        float calcDefenseSpTd = 0;
        
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
        
        
        NSNumber *defenseSpTdNumber = [[_players objectAtIndex: i] objectForKey:@"DefSP TD"];
        if(defenseSpTdNumber != [NSNull null]){
            calcDefenseSpTd = DefenseSpTdWeight * [defenseSpTdNumber floatValue];
        }

        
        float score = calcPassingYards + calcPassingTd + calcPassingCompletion + calcPassingAttempts + calcPassingInt + calcRushingYards +calcRushingTd + calcRushingAttempts + calcReceivingYards + calcReceivingReceptions + calcReceivingTd + calcKickingXp + calcKickingFg + calcKickingFg50 + calcDefenseTd + calcDefenseInterception + calcDefenseSack + calcDefenseSpTd;
        
        NSString *scoreAsString = [[NSNumber numberWithFloat:score] stringValue];
        
        NSString *refreshPlayers = [NSString stringWithFormat:@"insert into player (pid, player, pos, team, adp, passcomp,passatt, passyds, passtd,int,rushatt,rushyds,rushtd,rec,recyds, rectd, xp, fg, fg50, deftd, deffum, defint,defsack, defsafety, bye, opponent, news, score,defsptd) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[_players objectAtIndex: i] objectForKey:@"PID"], [[_players objectAtIndex: i] objectForKey:@"Player"], [[_players objectAtIndex: i] objectForKey:@"Pos"], [[_players objectAtIndex: i] objectForKey:@"Team"], [[_players objectAtIndex: i] objectForKey:@"ADP"], [[_players objectAtIndex: i] objectForKey:@"Pass Comp"], [[_players objectAtIndex: i] objectForKey:@"Pass Att"], [[_players objectAtIndex: i] objectForKey:@"Pass Yds"], [[_players objectAtIndex: i] objectForKey:@"Pass TD"], [[_players objectAtIndex: i] objectForKey:@"INT"], [[_players objectAtIndex: i] objectForKey:@"Rush Att"], [[_players objectAtIndex: i] objectForKey:@"Rush Yds"], [[_players objectAtIndex: i] objectForKey:@"Rush TD"], [[_players objectAtIndex: i] objectForKey:@"Rec"], [[_players objectAtIndex: i] objectForKey:@"Rec Yds"], [[_players objectAtIndex: i] objectForKey:@"Rec TD"], [[_players objectAtIndex: i] objectForKey:@"XP"], [[_players objectAtIndex: i] objectForKey:@"FG"], [[_players objectAtIndex: i] objectForKey:@"FG50"], [[_players objectAtIndex: i] objectForKey:@"DefTD"], [[_players objectAtIndex: i] objectForKey:@"DefFum"], [[_players objectAtIndex: i] objectForKey:@"DefInt"], [[_players objectAtIndex: i] objectForKey:@"DefSack"], [[_players objectAtIndex: i] objectForKey:@"DefSafety"], [[_players objectAtIndex: i] objectForKey:@"Bye"], [[_players objectAtIndex: i] objectForKey:@"Opponent"], [[_players objectAtIndex: i] objectForKey:@"News"],scoreAsString,[[_players objectAtIndex: i] objectForKey:@"DefSP TD"]];
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
    
}


@end
