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
        [self setProperty:PASSING_YARDS:@"test1"];
        [self setProperty:PASSING_COMPLETION:@"test2"];
        [self setProperty:PASSING_ATTEMPTS:@"Test3"];
        [self setProperty:PASSING_TD:@"Test4"];
        [self setProperty:PASSING_INT:@"Test5"];
        [self setProperty:RUSHING_YARDS:@"Test6"];
        [self setProperty:RUSHING_TD:@"Test7"];
        [self setProperty:RUSHING_ATTEMPS:@"Test8"];
        [self setProperty:RECEIVING_YARDS:@"Test9"];
        [self setProperty:RECEIVING_RECEPTIONS:@"Test10"];
        [self setProperty:RECEIVING_TD:@"Test11"];
        [self setProperty:KICKING_XP:@"Test12"];
        [self setProperty:KICKING_FG:@"Test13"];
        [self setProperty:KICKING_FG50:@"Test14"];
        [self setProperty:DEFENSE_TD:@"Test15"];
        [self setProperty:DEFENSE_INTERCEPTION:@"Test16"];
        [self setProperty:DEFENSE_SACK:@"Test17"];
        [self setProperty:DEFENSE_SAFETY:@"Test18"];
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

@end
