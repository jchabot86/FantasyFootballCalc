//
//  SQLiteHelper.m
//  FantasyFootballCalc
//
//  Created by Justin Port on 7/5/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "SQLite.h"
#import <sqlite3.h>

@implementation SQLite

 sqlite3 *database;

- (void) closeConnection{
    sqlite3_close(database);
}


 - (bool)executeSQL:(NSString *)query{
    sqlite3_stmt *statement = nil;
     const char *sql = [query UTF8String];
    
     if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
         //NSLog(@"[SQLITE] Error when preparing query!");
         return false;
     }
    return true;
}


- (id)initWithPath:(NSString *)path {
    if (self = [super init]) {
        sqlite3 *dbConnection;
        if (sqlite3_open([path UTF8String], &dbConnection) != SQLITE_OK) {
            
            //NSLog(@"[SQLITE] Unable to open database!");
            return nil; // if it fails, return nil obj
        }
        database = dbConnection;
    }
    return self;
}

- (NSArray *)performQuery:(NSString *)query {
    sqlite3_stmt *statement = nil;
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
        //NSLog(@"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    } else {
        NSMutableArray *result = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableArray *row = [NSMutableArray array];
            for (int i=0; i<sqlite3_column_count(statement); i++) {
                int colType = sqlite3_column_type(statement, i);
                id value;
                if (colType == SQLITE_TEXT) {
                    const unsigned char *col = sqlite3_column_text(statement, i);
                    value = [NSString stringWithFormat:@"%s", col];
                } else if (colType == SQLITE_INTEGER) {
                    int col = sqlite3_column_int(statement, i);
                    value = [NSNumber numberWithInt:col];
                } else if (colType == SQLITE_FLOAT) {
                    double col = sqlite3_column_double(statement, i);
                    value = [NSNumber numberWithDouble:col];
                } else if (colType == SQLITE_NULL) {
                    value = [NSNull null];
                } else {
                    //NSLog(@"[SQLITE] UNKNOWN DATATYPE");
                }
                
                [row addObject:value];
            }
            [result addObject:row];
        }
        return result;
    }
    return nil;
}
@end
