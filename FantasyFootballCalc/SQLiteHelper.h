//
//  SQLiteHelper.h
//  FantasyFootballCalc
//
//  Created by Justin Port on 7/5/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteHelper : NSObject
    @property NSString *dbPath;
    @property NSString *dbName;

    - (NSString *)test;
@end
