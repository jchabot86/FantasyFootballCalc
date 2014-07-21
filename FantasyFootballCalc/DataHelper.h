//
//  DataHelper.h
//  FantasyFootballCalc
//
//  Created by Justin Port on 7/20/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSMutableData *data;

- (void)importPlayerData;
- (void) recalculatePlayerScores;
@end
