//
//  Settings.h
//  FantasyFootballCalc
//
//  Created by Justin Port on 7/5/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
    extern NSString *const PASSING_YARDS;
    extern NSString *const DEFENSE_FUMREC;
    extern NSString *const PASSING_ATTEMPTS;
    extern NSString *const PASSING_TD;
    extern NSString *const PASSING_INT;
    extern NSString *const RUSHING_YARDS;
    extern NSString *const RUSHING_TD;
    extern NSString *const RUSHING_ATTEMPS;
    extern NSString *const RECEIVING_YARDS;
    extern NSString *const RECEIVING_RECEPTIONS;
    extern NSString *const RECEIVING_TD;
    extern NSString *const KICKING_XP;
    extern NSString *const KICKING_FG;
    extern NSString *const KICKING_FG50;
    extern NSString *const DEFENSE_TD;
    extern NSString *const DEFENSE_INTERCEPTION;
    extern NSString *const DEFENSE_SACK;
    extern NSString *const DEFENSE_SAFETY;
    extern NSString *const DEFENSE_SPTD;

 - (void) setProperty:(NSString *)property:(NSString *)value;
 - (NSString *)getProperty:(NSString *)property;
 - (bool)propertyExists:(NSString *)property;
 - (void)resetTable;
 - (void) refreshScores;

@end
