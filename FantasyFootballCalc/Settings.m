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
    - (void) setProperty:(NSString *)property{
        
    }

    - (NSString *)getProperty:(NSString *)property{
        return @"test";
    }

    - (bool) propertyExists:(NSString *)property{
        NSString *sql = [NSString stringWithFormat:@"SELECT count(key) as count FROM settings where key = '%@'", property];
        
        SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
        NSArray *results = [database performQuery: sql];
        
        
        [database closeConnection];
        
        return true;
    }

@end
