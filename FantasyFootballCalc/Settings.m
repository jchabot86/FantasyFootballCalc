//
//  Settings.m
//  FantasyFootballCalc
//
//  Created by Justin Port on 7/5/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "Settings.h"
#import "SQLite.h"
#import "Config.h"

@implementation Settings
    NSString *const PASSING_YARDS = @"PassingYards";
    NSString *const PASSING_COMPLETION = @"PassingCompletion";
    NSString *const PASSING_ATTEMPTS = @"PassingAttempts";
    NSString *const PASSING_TD = @"PassingTd";
    NSString *const PASSING_INT = @"PassingInt";
    NSString *const RUSHING_YARDS = @"RushingYards";
    NSString *const RUSHING_TD = @"RushingTd";
    NSString *const RUSHING_ATTEMPS = @"RushingAttempts";
    NSString *const RECEIVING_YARDS = @"ReceivingYards";
    NSString *const RECEIVING_RECEPTIONS = @"ReceivingReceptions";
    NSString *const RECEIVING_TD = @"ReceivingTd";
    NSString *const KICKING_XP = @"KickingXp";
    NSString *const KICKING_FG = @"KickingFg";
    NSString *const KICKING_FG50 = @"KickingFg50";
    NSString *const DEFENSE_TD = @"DefenseTd";
    NSString *const DEFENSE_INTERCEPTION = @"DefenseInterception";
    NSString *const DEFENSE_SACK = @"DefenseSack";
    NSString *const DEFENSE_SAFETY =@"DefenseSafety";

    - (void) resetTable{
        [self setProperty:PASSING_YARDS:@".25"];
        [self setProperty:PASSING_COMPLETION:@".25"];
        [self setProperty:PASSING_ATTEMPTS:@".25"];
        [self setProperty:PASSING_TD:@".25"];
        [self setProperty:PASSING_INT:@".25"];
        [self setProperty:RUSHING_YARDS:@".25"];
        [self setProperty:RUSHING_TD:@".25"];
        [self setProperty:RUSHING_ATTEMPS:@".25"];
        [self setProperty:RECEIVING_YARDS:@".25"];
        [self setProperty:RECEIVING_RECEPTIONS:@".25"];
        [self setProperty:RECEIVING_TD:@".25"];
        [self setProperty:KICKING_XP:@".25"];
        [self setProperty:KICKING_FG:@".25"];
        [self setProperty:KICKING_FG50:@".25"];
        [self setProperty:DEFENSE_TD:@".25"];
        [self setProperty:DEFENSE_INTERCEPTION:@".25"];
        [self setProperty:DEFENSE_SACK:@".25"];
        [self setProperty:DEFENSE_SAFETY:@".25"];
    }

    - (void) setProperty:(NSString *)property:(NSString *)value{
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO settings ('key','value') VALUES('%@','%@');", property,value];
        NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE settings SET value = '%@' WHERE key = '%@'", value,property];
        
        SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
        
        BOOL properyExists = [self propertyExists:property];
        
        if(properyExists){
            [database performQuery: sqlUpdate];
        }else{
            [database performQuery: sqlInsert];
        }
        
        [database closeConnection];
        
    }

    - (NSString *)getProperty:(NSString *)property{
        NSString *sql = [NSString stringWithFormat:@"SELECT value as count FROM settings where key = '%@'", property];
        
        SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
        NSArray *results = [database performQuery: sql];
        
        NSString *value = Nil;
        
        for (NSArray *row in results) {
            value = [row objectAtIndex:0];
            break;
        }
        
        [database closeConnection];
        
        return value;

    }

    - (bool) propertyExists:(NSString *)property{
        NSString *sql = [NSString stringWithFormat:@"SELECT count(key) as count FROM settings where key = '%@'", property];
        
        SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
        NSArray *results = [database performQuery: sql];
        
        int count = 0;
        
        for (NSArray *row in results) {
            count = [[row objectAtIndex:0] intValue];
            break;
        }
        
        [database closeConnection];
        
        if(count == 1){
            return true;
        }else{
            return false;
        }
        
    }

- (void) refreshScores{
    NSString *sql = @"SELECT * FROM player";
    
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSArray *results = [database performQuery: sql];
    
    NSString *sqlUpdatePlayer = @"UPDATE player SET score = %@ WHERE pid = '%@';";
    Settings* properties = [Settings new];
    float PassingTdWeight = [[properties getProperty:PASSING_TD] floatValue];
    float PassingYardsWeight = [[properties getProperty:PASSING_YARDS] floatValue];
    float PassingCompletionWeight = [[properties getProperty:PASSING_COMPLETION] floatValue];
    float PassingAttemptsWeight = [[properties getProperty:PASSING_ATTEMPTS] floatValue];
    float PassingIntWeight = [[properties getProperty:PASSING_INT] floatValue];
    float RushingYardsWeight = [[properties getProperty:RUSHING_YARDS] floatValue];
    float RushingTdWeight = [[properties getProperty:RUSHING_TD] floatValue];
    float RushingAttemptsWeight = [[properties getProperty:RUSHING_ATTEMPS] floatValue];
    float ReceivingYardsWeight = [[properties getProperty:RECEIVING_YARDS] floatValue];
    float ReceivingReceptionsWeight = [[properties getProperty:RECEIVING_RECEPTIONS] floatValue];
    float ReceivingTdWeight = [[properties getProperty:RECEIVING_TD] floatValue];
    float KickingXpWeight = [[properties getProperty:KICKING_XP] floatValue];
    float KickingFgWeight = [[properties getProperty:KICKING_FG] floatValue];
    float KickingFg50Weight = [[properties getProperty:KICKING_FG50] floatValue];
    float DefenseTdWeight = [[properties getProperty:DEFENSE_TD] floatValue];
    float DefenseInterceptionWeight = [[properties getProperty:DEFENSE_INTERCEPTION] floatValue];
    float DefenseSackWeight = [[properties getProperty:DEFENSE_SACK] floatValue];
    float DefenseSafetyWeight = [[properties getProperty:DEFENSE_SAFETY] floatValue];

    for (NSArray *player in results) {
        NSString *pid = [player objectAtIndex:0];
        NSString *name = [player objectAtIndex:1];
        float adp = [[player objectAtIndex:4] floatValue];
        float passcomp = [[player objectAtIndex:5] floatValue];
        float passatt = [[player objectAtIndex:6] floatValue];
        float passyds = [[player objectAtIndex:7] floatValue];
        float passtd = [[player objectAtIndex:8] floatValue];
        float interceptions = [[player objectAtIndex:9] floatValue];
        float rushatt = [[player objectAtIndex:10] floatValue];
        float rushyds = [[player objectAtIndex:11] floatValue];
        float rushtd = [[player objectAtIndex:12] floatValue];
        float recyds = [[player objectAtIndex:13] floatValue];
        float rectd = [[player objectAtIndex:14] floatValue];
        float xp = [[player objectAtIndex:15] floatValue];
        float fg = [[player objectAtIndex:16] floatValue];
        float fg50 = [[player objectAtIndex:17] floatValue];
        float deftd = [[player objectAtIndex:18] floatValue];
        float deffum = [[player objectAtIndex:19] floatValue];
        float defint = [[player objectAtIndex:20] floatValue];
        float defsack = [[player objectAtIndex:21] floatValue];
        float defsafety = [[player objectAtIndex:22] floatValue];
        
        
        
        
        
        NSString *scoreAsString = @"0";
        
        
        sqlUpdatePlayer = [NSString stringWithFormat:sqlUpdatePlayer,scoreAsString,pid];
        [database performQuery: sqlUpdatePlayer];
        
        NSLog(@"%@",sqlUpdatePlayer);
       
    }
    
    [database closeConnection];
}

@end
