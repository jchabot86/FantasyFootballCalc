//
//  PlayersViewController.h
//  FantasyFootballCalc
//
//  Created by Jon on 7/3/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayersViewController : UITableViewController

@property (nonatomic, strong) NSArray *PID;
@property (nonatomic, strong) NSArray *Player;
@property (nonatomic, strong) NSArray *Team;
@property (nonatomic, strong) NSArray *Pos;

@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSMutableData *data;
@end
