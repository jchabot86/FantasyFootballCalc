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
    - (void) setProperty:(NSString *)property:(NSString *)value{
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO settings ('key','value') VALUES('%@','%@');", property,value];
        NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE settings WHERE key = '%@' SET value = '%@'", property,value];
        
        SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
        
        BOOL *properyExists = [self propertyExists:property];
        
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
