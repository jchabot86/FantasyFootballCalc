//
//  SQLiteHelper.h
//  FantasyFootballCalc
//
//  Created by Justin Port on 7/5/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLite : NSObject
    - (void) test;
    - (id)initWithPath:(NSString *)path;
    - (NSArray *)performQuery:(NSString *)query;
    - (bool)executeSQL:(NSString *)query;
    -(void)closeConnection;
@end
